#!/usr/bin/env bash

function git_stashes_count {
	st_num=$(/usr/bin/git stash list 2>/dev/null | wc -l | tr -d ' ')
	if [[ $st_num != "0" ]]; then
		echo "stashes($st_num) "
	fi
}

function parse_git_branch { git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/{\1}/'; }

BLUE="\[\e[1;34m\]"
GRAY="\[\e[0;37m\]"
GREEN="\[\033[1;32m\]"
RED="\[\033[1;31m\]"
YELLOW="\[\e[1;33m\]"
RED="\[\e[0;31m\]"
WHITE="\[\e[1;37m\]"

PS1="[$WHITE\u@\h\[\e[m\] $YELLOW\t] $BLUE\w $GREEN\$(parse_git_branch) $RED\$(git_stashes_count)$RED\$ \[\e[m\]$GRAY"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=bash sw=2 ts=2 et
