#!/usr/bin/env zsh

_accept-line-with-url() {
  if  [[ $BUFFER =~ ^https.*git ]]; then
    echo $BUFFER >> $HISTFILE
    fc -R
    BUFFERz="cd ${HOME} && git clone ${BUFFER} && cd $(basename ${BUFFER} .git)"
    zle .kill-whole-line
    BUFFER=${BUFFER}z
    zle .accept-line
  else
    zle .accept-line
  fi
}
zle -N accept-line _accept-line-with-url
