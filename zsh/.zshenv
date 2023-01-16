#!/usr/bin/env zsh

skip_global_compinit=1

[[ "$OSTYPE" == darwin* ]] && export SHELL_SESSIONS_DISABLE=1

# if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${HOME}/.zprofile" ]] {
source "${HOME}/.zprofile"
# }
# vim: set sw=2 sts=2 et ft=zsh et:
