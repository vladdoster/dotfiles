#!/usr/bin/env zsh

# disable ubunutu calling compinit
skip_global_compinit=1

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${HOME}/.zprofile" ]]; then
  source "${HOME}/.zprofile"
fi

# vim: set sw=2 sts=2 et ft=zsh et:
. "$HOME/.cargo/env"
