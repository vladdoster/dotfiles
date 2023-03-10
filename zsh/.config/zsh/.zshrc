#!/usr/bin/env zsh


# [[ -n $PROFILE_ZSH ]] && {
#   PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
#   exec 3>&2 2>"${HOME}/zshstart.$$.log"
#   setopt xtrace prompt_subst
# }

() {
  # `local` sets the variable's scope to this function and its descendendants.
  local CODEDIR=~/code  # where to keep repos and plugins

  # Load all of the files in rc.d that start with <number>- and end in `.zsh`.
  # (n) sorts the results in numerical order.
  #  <->  is an open-ended range. It matches any non-negative integer.
  # <1->  matches any integer >= 1.
  #  <-9> matches any integer <= 9.
  # <1-9> matches any integer that's >= 1 and <= 9.
  # See https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Operators
  #
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file   # `.` is like `source`, but doesn't search your $path.
  done
} "$@"
# zshrc::autoload
# zshrc::completion
# zshrc::misc
# zshrc::history
# zshrc::update-path

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
