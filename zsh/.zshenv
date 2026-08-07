#!/usr/bin/env zsh
# vim: set ft=zsh:et:sts=2:sw=2:ts=2:tw=100:

(){
  setopt localoptions verbose
  : ${ZDOTDIR:=$HOME/.config/zsh}
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
}

print -- "==> ZDOTDIR $ZDOTDIR"
