#!/usr/bin/env zsh
#
# source zsh configuration
#
alias v="nvim"; alias la="exa -al"; alias l="exa -l"
function plugin-compile() {
  ZPLUGINDIR=${ZDOTDIR:-$HOME/.config/zsh}
  autoload -U zrecompile
  local f
  for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
    zrecompile -pq "$f"
  done
}
local files=(aliases fzf git-fzf zinit)
for f in $files[@]; do
  . "${ZDOTDIR:-$HOME/.config/zsh}/$f".zsh
done
plugin-compile
