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

#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
	IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
	key=$(head -1 <<<"$out")
	file=$(head -2 <<<"$out" | tail -1)
	if [ -n "$file" ]; then
		[ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
	fi
}

#--------------------------------------------------#
# cdf - cd into the directory of the selected file #
#--------------------------------------------------#
cdf() {
	local file
	local dir
	file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

#----------------------------------------#
# using ripgrep combined with preview    #
# find-in-file - usage: fif <searchTerm> #
#----------------------------------------#
grep --line-buffered --color=never -r "" * | fzf
ag --nobreak --nonumbers --noheading . | fzf
fif() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

fkill() {
	pid=$(ps -ef | sed 1d | fzf | awk '{print $2}')

	if [ "x$pid" != "x" ]; then
		kill -${1:-9} $pid
	fi
}

#------------------------------------------------------------------------------------------#
# A CTRL-R script to insert the selected command from history into the command line/region
#------------------------------------------------------------------------------------------#
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history'
__fzf_history() {
	__ehc $(history | fzf --tac --tiebreak=index | perl -ne 'm/^\s*([0-9]+)/ and print "!$1"')
}

__ehc() {
	if
		[[ -n $1 ]]
	then
		bind '"\er": redraw-current-line'
		bind '"\e^": magic-space'
		READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${1}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
		READLINE_POINT=$((READLINE_POINT + ${#1}))
	else
		bind '"\er":'
		bind '"\e^":'
	fi
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
