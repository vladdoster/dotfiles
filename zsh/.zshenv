#!/usr/bin/env zsh

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${HOME}/.zprofile" ]]; then
  source "${HOME}/.zprofile"
fi

# vim: set sw=2 sts=2 et ft=zsh et:
