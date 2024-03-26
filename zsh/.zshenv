#!/usr/bin/env zsh
# vim: set expandtab filetype=zsh shiftwidth=4 softtabstop=4 tabstop=4:

typeset -g zsh_load_info='print -P -- [ %2N %i %y ]'
${=zsh_load_info}

if [ -n "${ZSH_VERSION-}" ]; then
  : ${ZDOTDIR:=${XDG_CONFIG_HOME:-$HOME/.config}/zsh}
  setopt no_global_rcs
  [[ -o no_interactive ]] && return
  setopt rcs
fi
