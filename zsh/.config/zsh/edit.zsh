#!/usr/bin/env zsh

edit-function(){ $EDITOR $(type "${1}" | grep -oE '[^[:space:]]+$'); }

find-replace(){
  (( $+commands[gsed] )) && sed="gsed" || sed='sed'
  print -R "--- replacing ${1} -> ${2} via ${sed}"
  find . -type d -path '*/.*' -prune -o -not -name '.*' -type f -print -exec ${sed} -i "s|${1}|${2}|" {} \;
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
