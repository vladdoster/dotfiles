#!/usr/bin/env zsh

edit-function(){ $EDITOR $(type "${1}" | grep -oE '[^[:space:]]+$'); }

find-replace(){
  print -R "--- replacing ${1} -> ${2}"
  (( $+commands[gsed] )) && local sed="gsed" && print -R "--- using gsed"
  find . -not -path '*/\.*' -type f -print -exec ${sed} -i "s|${1}|${2}|" {} \;
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
