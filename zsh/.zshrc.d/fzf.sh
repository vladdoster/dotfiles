#!/bin/bash

if [ -d /usr/share/fzf/shell ]; then
	source /usr/share/zsh/site-functions/fzf
	source /usr/share/fzf/shell/key-bindings.zsh
elif [ -d /usr/share/fzf ]; then
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
elif [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
elif [ -f $XDG_CONFIG_HOME/fzf/zsh.zsh ]; then
	source $XDG_CONFIG_HOME/fzf/zsh.zsh
fi

#-----------------------------#
# cf - fuzzy cd from anywhere #
#-----------------------------#
cf() {
	local file

	file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

	if [[ -n $file ]]; then
		if [[ -d $file ]]; then
			cd -- $file
		else
			cd -- ${file:h}
		fi
	fi
}
#--------------------------------------------------
# cdf - cd into the directory of the selected file 
#--------------------------------------------------
cdf() {
	local file
	local dir
	file=$(fzf +m -q "${1}") && dir=$(dirname "$file") && cd "$dir"
}
#---------------------#
# fh - repeat history #
#---------------------#
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}
#-------------------------------#
# fhe - repeat history and edit #
#-------------------------------#
fhe() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}
#----------------------------------------------------------------------------------------#
# fkill - kill processes - list only the ones you can kill. Modified the earlier script. #
#----------------------------------------------------------------------------------------#
fkill() {
	local pid
	if [ "$UID" != "0" ]; then
		pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
	else
		pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
	fi

	if [ "x$pid" != "x" ]; then
		echo $pid | xargs kill -${1:-9}
	fi
}
#-----------------------------------------#
# fo - open files in finder or editor     #
# - CTRL-O to open with `open` command,   #
# - CTRL-E/Enter to open with the $EDITOR #
#-----------------------------------------#
fo() {
	IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
	key=$(head -1 <<<"$out")
	file=$(head -2 <<<"$out" | tail -1)
	if [ -n "$file" ]; then
		[[ "$key" == "ctrl-o" ]] && open "$file" || "${EDITOR:-vim}" "$file"
	fi
}
#------------------------------------------------------------#
# fssh - ssh into a host specified in ~/.ssh/config          #
# Takes an argument which will instead execute that command. #
#------------------------------------------------------------#
fssh() {
	local command="${1}"
	local host
	host=$(grep '^host .*' ~/.ssh/config | cut -d ' ' -f 2 | fzf)

	[ -z $host ] && return

	echo "Connecting to ${host}"
	[ -n $command ] && echo "Command: ${command}"

	ssh -t $host $command
}

