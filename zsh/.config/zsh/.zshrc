#!/usr/bin/env zsh

# Search path for the cd command
cdpath=(..)
# Fix common locale issues (e.g. less, tmux).
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export LC_LANG="${LC_LANG:-en_US.UTF-8}"
export LESSCHARSET="${LESSCHARSET:-utf-8}"
[[ $(uname) =~ 'Linux' ]] && export LC_TIME="${LC_TIME:-C.UTF-8}"

# Enable colorized otput (e.g. for `ls`).
alias lsd='ls -ld *(-/DN)' lsa='ls -ld .*'
# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
# Where to look for autoloaded function definitions
fpath=($fpath)
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath
# Global aliases -- These do not have to be at the beginning of the command line.
alias -g M='|more' H='|head' T='|tail'
# +─────────────────────+
# │ LOAD CONFIGURATIONS │
# +─────────────────────+
for f in edit fzf aliases zinit rld widget; do
  source ${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh
done
# +──────────────+
# │ SETUP EDITOR │
# +──────────────+
_log() { [[ $- == *i* ]] && print -P "%F{white}[INFO]%f %F{cyan}${1}%f ⮕  %F{green}${2}%f"; }
if has nvim && { nvim --headless -c ':qall' }; then
  EDITOR="nvim"
else
  EDITOR="vim"
fi
_log 'Editor' "$EDITOR"
export EDITOR=$EDITOR
for i (v vi vim); do alias $i="$EDITOR"; done
# +───────────────────────+
# │ Zsh Line Editor (ZLE) │
# +───────────────────────+
typeset -g zle_highlight=(region:bg=black) # Highlight the background of the text when selecting.
bindkey -M menuselect 'h' vi-backward-char; bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char;  bindkey -M menuselect 'j' vi-down-line-or-history;
# +──────────────────────+
# │ Changing Directories │
# +──────────────────────+
setopt GLOB_DOTS MARK_DIRS NOCORRECTALL NO_BEEP NO_NOMATCH VI
# +────────────+
# │ Completion │
# +────────────+
zstyle ':completion:*:*:make:*' tag-order 'targets'
zstyle ':completion:*' rehash true
PROMPT_EOL_MARK='%K{red} %k'   # mark the missing \n at the end of a comand output with a red block
WORDCHARS=''                   # only alphanums make up words in word-based zle widgets
ZLE_REMOVE_SUFFIX_CHARS=''     # don't eat space when typing '|' after a tab completion
zle_highlight=('paste:none')   # disable highlighting of text pasted into the command line

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
