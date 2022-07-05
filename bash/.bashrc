#!/bin/bash

function git_stashes_count {
	st_num=$(/usr/bin/git stash list 2>/dev/null | wc -l | tr -d ' ')
	if [[ $st_num != "0" ]]; then
		echo "stashes($st_num) "
	fi
}

function parse_git_branch {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/{\1}/'
}

BLUE="\[\e[0;34m\]"
LIGHT_BLUE="\[\e[1;34m\]"
RED="\[\e[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
GREEN="\[\e[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\e[1;37m\]"
YELLOW="\[\e[0;33m\]"
LIGH_YELLOW="\[\e[1;33m\]"
LIGHT_GRAY="\[\e[0;37m\]"
NO_COLOUR="\[\e[0m\]"

PS1="[$WHITE\u@\h\[\e[m\] $LIGH_YELLOW\t] $LIGHT_BLUE\w $LIGHT_GREEN\$(parse_git_branch) $RED\$(git_stashes_count)$LIGHT_RED\$ \[\e[m\]$LIGHT_GRAY"
export PATH=/Applications/kitty.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin:/application/jdk-11.0.1/bin/

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
