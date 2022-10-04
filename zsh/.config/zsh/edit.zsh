#!/usr/bin/env zsh

edit-function(){ $EDITOR $(type "${1}" | grep -oE '[^[:space:]]+$'); }

find-replace(){
  print -R "--- replacing ${1} -> ${2}"
  find . -type f -print -test-exec gsed --in-place "s/${1}/${2}/gc" {} \;
}

# vim:ft=zsh:sw=2:sts=2
