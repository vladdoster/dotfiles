#!/usr/bin/env zsh

function _accept-line-with-url {
  if [[ $BUFFER =~ ^https.*git ]]; then
    echo $BUFFER >> $HISTFILE
    fc -R
    BUFFERz="git clone $BUFFER && cd $(basename $BUFFER .git)"
    zle .kill-whole-line
    BUFFER=$BUFFERz
    zle .accept-line
  elif [[ $BUFFER =~ ^[[:space:]]?\$[[:space:]] ]]; then
    echo $BUFFER >> $HISTFILE
    fc -R
    BUFFERz="$(echo ${BUFFER/\$/} | xargs)"
    BUFFER=$BUFFERz
    zle .accept-line
  else
    zle .accept-line
  fi
}
zle -N accept-line _accept-line-with-url

# Bind <alt>+s to `git status`
function _git-status {
    zle .kill-whole-line
    BUFFER="git status"
    zle .accept-line
}
zle -N _git-status
bindkey '\es' _git-status

# Bind <alt>+d to `git diff`
# function _git-diff {
#     zle .kill-whole-line
#     BUFFER="git diff"
#     zle .accept-line
# }
# zle -N _git-diff
# bindkey '\ed' _git-diff


function reset_broken_terminal() {
  printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd reset_broken_terminal

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
