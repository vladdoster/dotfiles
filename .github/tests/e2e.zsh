#!/usr/bin/env zsh
# End-to-end test of the README's curl one-liner on a fresh Linux account. Run as root on a
# throwaway machine (CI runner, container):
#   zsh .github/tests/e2e.zsh --branch <branch> [--ref <commit>] --destroy-homebrew
# Deletes any Homebrew in /home/linuxbrew and recreates the user dotfiles-e2e with an empty home
# and a sudo password, like a new Mac account. Runs the one-liner (install.zsh fetched at <ref>,
# cloning <branch>) on a pseudo-terminal, checks the install, re-runs it, then runs the shell
# section. HOMEBREW_BUNDLE_<TYPE>_SKIP and HTTPS proxy variables pass through to the user. In
# GitHub Actions, each step's transcript is a collapsed log group, failures are annotations, and
# the results go to the job summary.
emulate -L zsh
setopt extended_glob pipe_fail

source ${0:A:h}/report.zsh
readonly title="End to end · curl one-liner on a fresh Linux account"
zmodload zsh/zutil
local -a opt_branch opt_ref flag_destroy
zparseopts -D -E -F -- -branch:=opt_branch -ref:=opt_ref -destroy-homebrew=flag_destroy || exit 1
((EUID == 0)) || abort $title "run as root"
[[ $OSTYPE == linux* ]] || abort $title "Linux only"
(($#flag_destroy)) || abort $title "pass --destroy-homebrew: this deletes /home/linuxbrew and recreates user dotfiles-e2e"
(($#opt_branch)) || abort $title "--branch is required"

readonly branch=${opt_branch[-1]#=}
readonly ref=${${${opt_ref[-1]-}#=}:-$branch}
readonly user=dotfiles-e2e here=${0:A:h} logs=$(mktemp -d)
readonly url=https://raw.githubusercontent.com/vladdoster/dotfiles/$ref/install.zsh
readonly oneliner="/bin/zsh -c \"\$(curl -fsSL $url)\" install.zsh"
readonly password=$(od -An -N12 -tx1 /dev/urandom | tr -d ' \n')
((gha)) && print -r -- "::add-mask::$password"
readonly -a skips=(${(k)parameters[(I)HOMEBREW_BUNDLE_*_SKIP]})

# A failed download makes the one-liner run `zsh -c ""`, which exits 0. Fail fast instead.
curl -fsSL -o /dev/null $url || abort $title "Cannot fetch \`$url\`."

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
useradd --create-home --skel $(mktemp -d) --shell /bin/bash --groups $group $user \
  || abort $title "useradd failed"
print -r -- "$user:$password" | chpasswd || abort $title "chpasswd failed"

local -a steps=("| Step | Exit | Password prompts | Time |" "| --- | :-: | --- | --: |")
# session <id> <step> <command> -- run <command> as the user in a clean login environment on a
# pseudo-terminal, answering password prompts, and add a row to the steps table. Sets $rc, $out
# (ANSI-stripped transcript), $prompts (e.g. "sudo=1"), and $excerpt (exit code and the end of
# $out, the details for a failed check). In GitHub Actions the transcript is a collapsed log
# group, and workflow commands are off while it streams: install output must not run them.
session() {
  local -a env=(
    HOME=/home/$user USER=$user LOGNAME=$user SHELL=$(getent passwd $user | cut -d: -f7)
    TERM=xterm-256color LANG=C.UTF-8 PATH=/usr/bin:/bin:/usr/sbin:/sbin
  )
  local v token=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
  for v in HTTPS_PROXY https_proxy NO_PROXY no_proxy $skips; do
    [[ -n ${(P)v-} ]] && env+=("$v=${(P)v}")
  done
  if ((gha)); then
    print -rl -- "::group::$2" "\$ $3" "::stop-commands::$token"
  else
    print -r -- "==> e2e: $2: $3"
  fi
  integer started=SECONDS
  PTY_PASSWORD=$password python3 $here/terminal.py $logs/$1.log \
    runuser -u $user -- env -i $env bash --noprofile --norc -c "cd ~ && $3" 2> $logs/$1.prompts
  rc=$?
  # The blank line puts the resume token at the start of a line.
  ((gha)) && print -rl -- "" "::$token::" "::endgroup::"
  integer took=$((SECONDS - started))
  prompts=${${(M)${(f)"$(< $logs/$1.prompts)"}:#prompts:*}#prompts:}
  prompts=${prompts## #}
  out=$(sed -e $'s/\e\\[[0-9;?]*[a-zA-Z]//g' $logs/$1.log | tr '\r' '\n')
  excerpt=("exit $rc" "${(@)${(f)out}[-25,-1]}")
  local time=$((took % 60))s
  ((took >= 60)) && time="$((took / 60))m $time"
  # "sudo=1 password=1" -> "sudo ×1, password ×1"
  steps+=("| $2 | $rc | ${${${prompts:-none}// /, }//=/ ×} | $time |")
}

##############################################################################
# Fresh install                                                              #
##############################################################################
area "Fresh install" install.zsh
session fresh "Fresh install" "$oneliner --branch $branch"
((rc == 0)); check "the one-liner installs on a fresh account" $? $excerpt
# The bug this guards: NONINTERACTIVE Homebrew never asked, then failed on sudo.
[[ $prompts == *sudo=* ]]; check "\`brew-install\` asked for the sudo password" $? "prompts: ${prompts:-none}"
[[ $prompts != *press-return* ]]; check "the Homebrew installer ran unattended" $? "prompts: $prompts"
[[ $out != *'==> skipped'* ]]; check "stow linked every package" $? ${(M)${(f)out}:#==> skipped*}

area Installed Brewfile
session check "Check the install" 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&
  brew bundle check --no-upgrade --file=~/.config/dotfiles/Brewfile && command -v node stow zsh'
((rc == 0)); check "every Brewfile entry is installed; \`node\`, \`stow\`, \`zsh\` on PATH" $? $excerpt

##############################################################################
# Re-run and the shell section                                               #
##############################################################################
area Re-run install.zsh
session rerun "Re-run" "$oneliner --branch $branch"
((rc == 0)) && [[ $out == *'updating the existing clone'* && $out == *'homebrew already installed'* ]]
check "re-running the one-liner updates the clone and finishes" $? $excerpt

area Shell Makefile
session shell "Shell section" "$oneliner --only shell"
((rc == 0)) && [[ $(getent passwd $user | cut -d: -f7) == */zsh ]]
check "the shell section sets the login shell to zsh" $? "login shell: $(getent passwd $user | cut -d: -f7)" $excerpt

local -a context=(
  "$(alert NOTE "Ran the README one-liner on a pseudo-terminal as \`$user\`, a new account whose sudo asks" \
    "for a password: [\`install.zsh\` at \`${ref:0:12}\`](https://github.com/vladdoster/dotfiles/blob/$ref/install.zsh)," \
    "cloning \`$branch\`.")"
)
if (($#skips)); then
  local -a skipped=()
  for v in $skips; do skipped+=("\`$v=${(P)v}\`"); done
  annotate warning "Skipped Brewfile entries" "Not tested: ${(j:, :)skipped}" Brewfile
  context+=("$(alert WARNING "**Not tested.** These Brewfile entries were skipped: ${(j:, :)skipped}.")")
fi
print -r -- "transcripts: $logs"
report $title $context "${(F)steps}"
