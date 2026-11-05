#!/usr/bin/env zsh
# End-to-end test of the README's curl one-liner on a fresh Linux account. Run as root on a
# throwaway machine (CI runner, container):
#   zsh .github/tests/e2e.zsh --branch <branch> [--ref <commit>] --destroy-homebrew
# Deletes any Homebrew in /home/linuxbrew and recreates the user dotfiles-e2e with an empty home
# and a sudo password, like a new Mac account. Runs the one-liner (install.zsh fetched at <ref>,
# cloning <branch>) on a pseudo-terminal, checks the install, re-runs it, then runs the shell
# section. HOMEBREW_BUNDLE_<TYPE>_SKIP and HTTPS proxy variables pass through to the user.
emulate -L zsh
setopt extended_glob pipe_fail

zmodload zsh/zutil
local -a opt_branch opt_ref flag_destroy
zparseopts -D -E -F -- -branch:=opt_branch -ref:=opt_ref -destroy-homebrew=flag_destroy || exit 1
die() { print -u2 -r -- "e2e.zsh: $*"; exit 1 }
((EUID == 0)) || die "run as root"
[[ $OSTYPE == linux* ]] || die "Linux only"
(($#flag_destroy)) || die "pass --destroy-homebrew: this deletes /home/linuxbrew and recreates user dotfiles-e2e"
(($#opt_branch)) || die "--branch is required"

readonly branch=${opt_branch[-1]#=}
readonly ref=${${${opt_ref[-1]-}#=}:-$branch}
readonly user=dotfiles-e2e here=${0:A:h} logs=$(mktemp -d)
readonly url=https://raw.githubusercontent.com/vladdoster/dotfiles/$ref/install.zsh
readonly oneliner="/bin/zsh -c \"\$(curl -fsSL $url)\" install.zsh"
readonly password=$(od -An -N12 -tx1 /dev/urandom | tr -d ' \n')
integer pass=0 fail=0
ok()  { print -r -- "ok   $1"; ((++pass)) }
bad() { print -r -- "FAIL $1"; ((++fail)) }

##############################################################################
# A fresh account on a machine without Homebrew                              #
##############################################################################
if id $user &> /dev/null; then
  pkill -KILL -u $user 2> /dev/null
  userdel -rf $user 2> /dev/null
fi
rm -rf /home/linuxbrew
local group=sudo
getent group sudo > /dev/null || group=wheel
useradd --create-home --skel $(mktemp -d) --shell /bin/bash --groups $group $user || die "useradd failed"
print -r -- "$user:$password" | chpasswd || die "chpasswd failed"

# session <name> <command> -- run <command> as the user in a clean login environment on a
# pseudo-terminal, answering password prompts. Sets $rc, $out (ANSI-stripped transcript), and
# $prompts (password prompts answered, e.g. "sudo=1").
session() {
  local -a env=(
    HOME=/home/$user USER=$user LOGNAME=$user SHELL=$(getent passwd $user | cut -d: -f7)
    TERM=xterm-256color LANG=C.UTF-8 PATH=/usr/bin:/bin:/usr/sbin:/sbin
  )
  local v
  for v in HTTPS_PROXY https_proxy NO_PROXY no_proxy ${(k)parameters[(I)HOMEBREW_BUNDLE_*_SKIP]}; do
    [[ -n ${(P)v-} ]] && env+=("$v=${(P)v}")
  done
  print -r -- "==> e2e: $1: $2"
  PTY_PASSWORD=$password python3 $here/terminal.py $logs/$1.log \
    runuser -u $user -- env -i $env bash --noprofile --norc -c "cd ~ && $2" 2> $logs/$1.prompts
  rc=$?
  prompts=$(< $logs/$1.prompts)
  out=$(sed -e $'s/\e\\[[0-9;?]*[a-zA-Z]//g' $logs/$1.log | tr '\r' '\n')
}

##############################################################################
# Fresh install                                                              #
##############################################################################
session fresh "$oneliner --branch $branch"
((rc == 0)) && ok "the one-liner installs on a fresh account" || bad "the one-liner exited $rc"
# The bug this guards: NONINTERACTIVE Homebrew never asked, then failed on sudo.
[[ $prompts == *sudo=* ]] && ok "brew-install asked for the sudo password" || bad "no sudo prompt ($prompts)"
[[ $prompts != *press-return* ]] && ok "the Homebrew installer ran unattended" || bad "installer prompted ($prompts)"
[[ $out != *'==> skipped'* ]] && ok "stow linked every package" || bad "stow skipped: ${(M)${(f)out}:#==> skipped*}"

session check 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&
  brew bundle check --no-upgrade --file=~/.config/dotfiles/Brewfile && command -v node stow zsh'
((rc == 0)) && ok "every Brewfile entry is installed; node, stow, zsh on PATH" || bad "check exited $rc"

##############################################################################
# Re-run and the shell section                                               #
##############################################################################
session rerun "$oneliner --branch $branch"
((rc == 0)) && [[ $out == *'updating the existing clone'* && $out == *'homebrew already installed'* ]] \
  && ok "re-running the one-liner updates and finishes" || bad "re-run exited $rc"

session shell "$oneliner --only shell"
[[ $rc == 0 && $(getent passwd $user | cut -d: -f7) == */zsh ]] \
  && ok "the shell section sets the login shell to zsh" || bad "shell exited $rc ($prompts)"

print -r -- "---- $pass passed, $fail failed (transcripts: $logs)"
((fail == 0))
