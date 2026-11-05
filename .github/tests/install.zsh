#!/usr/bin/env zsh
# Regression checks for install.zsh, the Makefile targets it drives, and the Brewfile.
# Needs only zsh, git, make, and python3; nothing is installed. Runs on macOS and Linux:
#   zsh .github/tests/install.zsh
emulate -L zsh
setopt extended_glob pipe_fail

readonly repo=${0:A:h:h:h}
readonly work=$(mktemp -d)
trap 'rm -rf -- $work' EXIT
integer pass=0 fail=0
ok()  { print -r -- "ok   $1"; ((pass++)) }
bad() { print -r -- "FAIL $1"; ((fail++)) }

# Keep the user's git config (signing, hooks, pull.rebase) out of the test repositories.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
gitc() { command git -c user.name=test -c user.email=test@example.com "$@" }

##############################################################################
# Makefile                                                                   #
##############################################################################
# Stand-ins for sudo and the Homebrew installer record the order of calls.
mkdir -p $work/bin
print -r -- '#!/bin/sh
echo "sudo $*" >> "$CALL_LOG"' > $work/bin/sudo
print -r -- '#!/bin/sh
echo '\''echo "installer NONINTERACTIVE=${NONINTERACTIVE-unset}" >> "$CALL_LOG"'\''' > $work/bin/curl
chmod +x $work/bin/*
export CALL_LOG=$work/calls.log

# NONINTERACTIVE makes Homebrew's installer check sudo with `sudo -n`, which fails on a fresh
# Mac with no cached credentials. On a TTY, brew-install must cache them first.
: > $CALL_LOG
PATH=$work/bin:$PATH python3 $repo/.github/tests/terminal.py $work/tty.log make -C $repo brew-install > /dev/null 2>&1
if [[ $(< $CALL_LOG) == $'sudo --validate\ninstaller NONINTERACTIVE=1' ]]; then
  ok "brew-install on a TTY caches sudo credentials, then runs the installer"
else
  bad "brew-install on a TTY: calls were: ${(@f)$(< $CALL_LOG)}"
fi

: > $CALL_LOG
PATH=$work/bin:$PATH make -C $repo brew-install < /dev/null > /dev/null 2>&1
if [[ $(< $CALL_LOG) == 'installer NONINTERACTIVE=1' ]]; then
  ok "brew-install without a TTY never prompts for sudo"
else
  bad "brew-install without a TTY: calls were: ${(@f)$(< $CALL_LOG)}"
fi

# --verbose makes brew bundle run npm with a PATH that lacks node; --jobs is deprecated.
recipe=$(make -n -C $repo brew-bundle 2>&1)
if [[ $recipe == *'brew bundle install'* && $recipe != *--verbose* && $recipe != *--jobs* ]]; then
  ok "brew-bundle passes neither --verbose nor --jobs"
else
  bad "brew-bundle recipe: $recipe"
fi

##############################################################################
# Brewfile                                                                   #
##############################################################################
# brew bundle only knows link: true, false, and :overwrite; it treats anything else as unset,
# which leaves keg-only formulae unlinked.
bogus=(${(f)"$(grep -nE 'link: *:[a-z_]+' $repo/Brewfile | grep -v 'link: *:overwrite')"})
if ((! $#bogus)); then
  ok "Brewfile uses only link: values brew bundle supports"
else
  bad "Brewfile has unsupported link: values: ${(j:; :)bogus}"
fi

# brew bundle runs npm with only $HOMEBREW_PREFIX/opt/node/bin added to PATH, and
# --force-cleanup removes the node formula unless the Brewfile lists it.
if ! grep -q '^npm ' $repo/Brewfile || grep -qE '^brew "node"(,|$)' $repo/Brewfile; then
  ok "Brewfile lists the node formula that its npm entries need"
else
  bad "Brewfile has npm entries but does not list brew \"node\""
fi

##############################################################################
# install.zsh options                                                        #
##############################################################################
run() { out=$(zsh $repo/install.zsh "$@" 2>&1 < /dev/null) && rc=0 || rc=$? }

run --help
((rc == 0)) && [[ $out == install.zsh* ]] && ok "--help prints usage" || bad "--help: rc=$rc out=$out"
run stow
((rc == 1)) && [[ $out == *'did you mean: install.zsh --only stow'* ]] \
  && ok "an operand is rejected with a hint" || bad "operand: rc=$rc out=$out"
run --only bogus
((rc == 1)) && [[ $out == *'unknown section: bogus'* ]] \
  && ok "an unknown section is rejected" || bad "unknown section: rc=$rc out=$out"
run --only ''
((rc == 1)) && [[ $out == *'--only given with no sections'* ]] \
  && ok "--only with no sections is rejected" || bad "empty --only: rc=$rc out=$out"

##############################################################################
# install.zsh clone section                                                  #
##############################################################################
# A two-commit origin stands in for GitHub through url.*.insteadOf.
gitc init -q -b master $work/src
print 'all:' > $work/src/Makefile
gitc -C $work/src add Makefile
gitc -C $work/src commit -qm one
gitc -C $work/src commit -q --allow-empty -m two
gitc clone -q --bare $work/src $work/origin.git
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=url.$work/origin.git.insteadOf
export GIT_CONFIG_VALUE_0=https://github.com/vladdoster/dotfiles.git
readonly origin_head=$(gitc -C $work/origin.git rev-parse HEAD)

run --only clone --branch master --prefix $work/fresh/dotfiles
((rc == 0)) && [[ -f $work/fresh/dotfiles/Makefile ]] \
  && ok "a fresh prefix is cloned" || bad "fresh prefix: rc=$rc out=$out"

# Re-running the one-liner after a failed bootstrap must resume, not stop at the clone.
gitc clone -q https://github.com/vladdoster/dotfiles.git $work/behind
gitc -C $work/behind reset -q --hard HEAD~1
run --only clone --prefix $work/behind
((rc == 0)) && [[ $(gitc -C $work/behind rev-parse HEAD) == $origin_head ]] \
  && ok "an existing clone is fast-forwarded" || bad "existing clone: rc=$rc out=$out"

run --only clone --prefix $work/behind --dry-run
((rc == 0)) && [[ $out == *"git -C $work/behind pull --ff-only"* ]] \
  && ok "--dry-run prints the update instead of running it" || bad "dry run: rc=$rc out=$out"

gitc -C $work/behind reset -q --hard HEAD~1
gitc -C $work/behind commit -q --allow-empty -m local
local_head=$(gitc -C $work/behind rev-parse HEAD)
run --only clone --prefix $work/behind
((rc == 0)) && [[ $(gitc -C $work/behind rev-parse HEAD) == $local_head && $out == *Warning* ]] \
  && ok "a clone that cannot fast-forward is kept, with a warning" || bad "diverged clone: rc=$rc out=$out"

mkdir -p $work/foreign/sub
run --only clone --prefix $work/foreign
((rc == 1)) && [[ $out == *'already exists'* ]] \
  && ok "a directory that is not a clone is refused" || bad "foreign directory: rc=$rc out=$out"

print -r -- "---- $pass passed, $fail failed"
((fail == 0))
