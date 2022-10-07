#!/usr/bin/env zsh

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${HOME}/.zprofile" ]]; then
  source "${HOME}/.zprofile"
fi

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
