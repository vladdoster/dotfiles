#!/usr/bin/env zsh
# Regression checks for install.zsh, the Makefile targets it drives, and the Brewfile.
# Needs only zsh, git, make, and python3; nothing is installed. Runs on macOS and Linux:
#   zsh .github/tests/install.zsh
# In GitHub Actions, failures are also annotations, and the results go to the job summary.
emulate -L zsh
setopt extended_glob pipe_fail

readonly repo=${0:A:h:h:h}
readonly work=$(mktemp -d)
trap 'rm -rf -- $work' EXIT
source ${0:A:h}/report.zsh

# Keep the user's git config (signing, hooks, pull.rebase) out of the test repositories.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
gitc() { command git -c user.name=test -c user.email=test@example.com "$@" }

##############################################################################
# Makefile                                                                   #
##############################################################################
area Makefile Makefile
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
[[ $(< $CALL_LOG) == $'sudo --validate\ninstaller NONINTERACTIVE=1' ]]
check "\`brew-install\` on a TTY caches sudo credentials, then runs the installer" $? \
  "expected: sudo --validate, then installer NONINTERACTIVE=1" "calls:" "${(@f)$(< $CALL_LOG)}"

: > $CALL_LOG
PATH=$work/bin:$PATH make -C $repo brew-install < /dev/null > /dev/null 2>&1
[[ $(< $CALL_LOG) == 'installer NONINTERACTIVE=1' ]]
check "\`brew-install\` without a TTY never prompts for sudo" $? "calls:" "${(@f)$(< $CALL_LOG)}"

# --verbose makes brew bundle run npm with a PATH that lacks node; --jobs is deprecated.
recipe=$(make -n -C $repo brew-bundle 2>&1)
[[ $recipe == *'brew bundle install'* && $recipe != *--verbose* && $recipe != *--jobs* ]]
check "\`brew-bundle\` passes neither \`--verbose\` nor \`--jobs\`" $? "${(@f)recipe}"

##############################################################################
# Brewfile                                                                   #
##############################################################################
area Brewfile Brewfile
# brew bundle only knows link: true, false, and :overwrite; it treats anything else as unset,
# which leaves keg-only formulae unlinked.
bogus=(${(f)"$(grep -nE 'link: *:[a-z_]+' $repo/Brewfile | grep -v 'link: *:overwrite')"})
((! $#bogus))
check "uses only \`link:\` values brew bundle supports" $? "unsupported:" $bogus

# brew bundle runs npm with only $HOMEBREW_PREFIX/opt/node/bin added to PATH, and
# --force-cleanup removes the node formula unless the Brewfile lists it.
! grep -q '^npm ' $repo/Brewfile || grep -qE '^brew "node"(,|$)' $repo/Brewfile
check "lists the \`node\` formula that its npm entries need" $? 'npm entries, but no brew "node"'

##############################################################################
# install.zsh options                                                        #
##############################################################################
area Options install.zsh
run() { out=$(zsh $repo/install.zsh "$@" 2>&1 < /dev/null) && rc=0 || rc=$? }

run --help
((rc == 0)) && [[ $out == install.zsh* ]]
check "\`--help\` prints usage" $? "exit $rc" "${(@f)out}"
run stow
((rc == 1)) && [[ $out == *'did you mean: install.zsh --only stow'* ]]
check "an operand is rejected with a hint" $? "exit $rc" "${(@f)out}"
run --only bogus
((rc == 1)) && [[ $out == *'unknown section: bogus'* ]]
check "an unknown section is rejected" $? "exit $rc" "${(@f)out}"
run --only ''
((rc == 1)) && [[ $out == *'--only given with no sections'* ]]
check "\`--only\` with no sections is rejected" $? "exit $rc" "${(@f)out}"

##############################################################################
# install.zsh clone section                                                  #
##############################################################################
area Clone install.zsh
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
((rc == 0)) && [[ -f $work/fresh/dotfiles/Makefile ]]
check "a fresh prefix is cloned" $? "exit $rc" "${(@f)out}"

# Re-running the one-liner after a failed bootstrap must resume, not stop at the clone.
gitc clone -q https://github.com/vladdoster/dotfiles.git $work/behind
gitc -C $work/behind reset -q --hard HEAD~1
run --only clone --prefix $work/behind
((rc == 0)) && [[ $(gitc -C $work/behind rev-parse HEAD) == $origin_head ]]
check "an existing clone is fast-forwarded" $? "exit $rc" "${(@f)out}"

run --only clone --prefix $work/behind --dry-run
((rc == 0)) && [[ $out == *"git -C $work/behind pull --ff-only"* ]]
check "\`--dry-run\` prints the update instead of running it" $? "exit $rc" "${(@f)out}"

gitc -C $work/behind reset -q --hard HEAD~1
gitc -C $work/behind commit -q --allow-empty -m local
local_head=$(gitc -C $work/behind rev-parse HEAD)
run --only clone --prefix $work/behind
((rc == 0)) && [[ $(gitc -C $work/behind rev-parse HEAD) == $local_head && $out == *Warning* ]]
check "a clone that cannot fast-forward is kept, with a warning" $? "exit $rc" "${(@f)out}"

mkdir -p $work/foreign/sub
run --only clone --prefix $work/foreign
((rc == 1)) && [[ $out == *'already exists'* ]]
check "a directory that is not a clone is refused" $? "exit $rc" "${(@f)out}"

[[ $OSTYPE == darwin* ]] && os=macOS || os=Linux
report "Install regression checks · $os" \
  "$(alert NOTE "Checks \`install.zsh\`, the \`Makefile\` targets it runs, and the \`Brewfile\`." \
    "Stand-ins replace sudo, the Homebrew installer, and GitHub, so nothing is installed.")"
