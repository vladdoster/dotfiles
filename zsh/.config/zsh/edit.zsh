#!/usr/bin/env zsh

edit-function(){ $EDITOR $(type "${1}" | grep -oE '[^[:space:]]+$'); }

find-replace(){
  print -R "--- replacing ${1} -> ${2}"
  find . -type f -print -test-exec gsed --in-place "s/${1}/${2}/gc" {} \;
}

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
