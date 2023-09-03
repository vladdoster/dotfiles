autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

[[ -z $HISTFILE ]] && HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
