#!/usr/bin/env zsh

alias v="nvim"; alias la="exa -al"; alias l="exa -l"

local files=(aliases fzf zinit)

for f in $files[@]; do
  . "${ZDOTDIR:-$HOME/.config/zsh}/$f".zsh
done

ulimit -c unlimited
zmodload zsh/complist

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

setopt ALWAYS_TO_END    # Move cursor to the end of a completed word.
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt AUTO_MENU        # Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH # If completed parameter is a directory, add a trailing slash.
setopt CASE_GLOB
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
setopt EXTENDED_GLOB    # Needed for file modification glob modifiers with compinit.
setopt MENU_COMPLETE    # Do not autoselect the first completion entry.
setopt PATH_DIRS        # Perform path search even on command names with slashes.

zle_highlight=('paste:none')

zstyle ':completion:*' complete-options true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'

zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'

zstyle ':completion:*:*:make:*' tag-order 'targets'
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
