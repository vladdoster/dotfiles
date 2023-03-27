#!/usr/bin/env zsh
# [[ -n $PROFILE_ZSH ]] && {
#   PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
#   exec 3>&2 2>"${HOME}/zshstart.$$.log"
#   setopt xtrace prompt_subst
# }
  # `local` sets the variable's scope to this function and its descendendants.
  local ZDOTDIR=$HOME/.config/zsh
  # load all of the files in rc.d that start with <number>- and end in `.zsh`.
  for f in $ZDOTDIR/rc.d/<->-*zsh(n); source $f

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
