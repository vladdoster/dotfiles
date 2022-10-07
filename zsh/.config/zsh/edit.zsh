#!/usr/bin/env zsh

edit-function(){ $EDITOR $(type "${1}" | grep -oE '[^[:space:]]+$'); }

find-replace(){
  print -R "--- replacing ${1} -> ${2}"
  find . -type f -print -test-exec gsed --in-place "s/${1}/${2}/gc" {} \;
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
