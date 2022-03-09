#!/usr/bin/env zsh
#
# source zsh configuration
#
# ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
# function plugin-compile() {
#   ZPLUGINDIR=${ZDOTDIR:-$HOME/.config/zsh}
#   autoload -U zrecompile
#   local f
#   for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
#     zrecompile -pq "$f"
#   done
# }
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

HISTFILE="$HOME/zsh_history"; HISTSIZE=50000; SAVEHIST=50000
# WORDCHARS='*?_-.[]~&;!#$%^(){}<>|'

alias v="nvim"; alias la="exa -al"; alias l="exa -l"

local files
files=(aliases fzf git-fzf zinit)
for f in $files[@]; do
  . "${ZDOTDIR:-$HOME/.config/zsh}/$f".zsh
done

if [[ "$ZPROF" = true ]]; then
  zprof
fi

# plugin-compile
