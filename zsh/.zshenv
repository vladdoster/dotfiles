#!/usr/bin/env zsh
# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:

if [ -n "${ZSH_VERSION-}" ]; then
  print -P '['%x %I %y']'
  : ${ZDOTDIR:=${XDG_CONFIG_HOME:-$HOME/.config}/zsh}
  setopt no_global_rcs
  [[ -o no_interactive ]] && return
  setopt rcs
fi
