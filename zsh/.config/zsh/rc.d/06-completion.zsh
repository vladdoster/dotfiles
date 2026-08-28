autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
# only run self-insert-alikes on paste; keeps pasting fast with autosuggestions
zstyle ':bracketed-paste-magic' active-widgets 'self-*'

# Set/unset shell options
setopt   notify globdots pushdtohome cdablevars autolist
setopt   autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
setopt   completeinword alwaystoend
unsetopt bgnice autoparamslash
unsetopt correct correct_all

# load complist before compinit so the menuselect keymap exists
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xi' vi-insert

zstyle ':completion:*' completer _expand _complete _ignored _approximate

# cache slow generated completions (brew, docker, ...)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache

zstyle ':completion:*' rehash true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:-command-:*:*' group-order functions builtins commands
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS:-di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01}"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' verbose yes

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# exact match first, then case-insensitive, then partial-word on ._-, then substring
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# complete the directory stack (autopushd) before path-directories for cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# split man page completions by section
zstyle ':completion:*:manuals' separate-sections true

# complete ssh host aliases from ~/.ssh/config, skipping wildcard patterns
zstyle -e ':completion:*:(ssh|scp|rsync|sftp):*' hosts 'reply=()
  [[ -r ~/.ssh/config ]] && reply=(${${=${${(M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }}:#*[*?]*})'

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
