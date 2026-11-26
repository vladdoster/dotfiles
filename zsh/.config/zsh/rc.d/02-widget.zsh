#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:

zmodload -i zsh/parameter
autoload -Uz add-zsh-hook

_accept-line-with-url() {
  setopt localoptions extended_glob
  local repo
  # Heredoc bodies, continuation lines and vared input are data. Accept them unchanged.
  if [[ $CONTEXT != start ]]; then
    zle .accept-line
    return
  fi
  # GitHub Enterprise Cloud serves repos from <tenant>.ghe.com.
  if [[ $BUFFER =~ '^https://([^/]*git[^/]*/|[^/]*\.ghe\.com/|[^[:space:]]*\.git$)' ]]; then
    repo=${BUFFER//\/tree\/*/.git}
    print -rs -- $repo
    BUFFER="git clone ${(q)repo} && cd ${(q)${repo:t}%.git}"
  elif [[ $BUFFER =~ '^[[:space:]]?\$[[:space:]]' ]]; then
    print -rs -- $BUFFER
    BUFFER=${BUFFER##[[:space:]]#\$[[:space:]]#}
  fi
  zle .accept-line
}
zle -N accept-line _accept-line-with-url

# Bind <alt>+s to `git status`
_git-status() {
  zle .kill-whole-line
  BUFFER="git status"
  zle .accept-line
}
zle -N _git-status && bindkey '\es' _git-status

# share_history imports commands from other shells into $history. Record the command this shell ran.
_record-last-command() {
  typeset -g _last_command=$1
}
add-zsh-hook preexec _record-last-command

# runs the previous command again to capture its output, so side effects repeat
insert-last-command-output() {
  [[ -n $_last_command ]] || return 1
  LBUFFER+="$(eval $_last_command)"
}
zle -N insert-last-command-output && bindkey -M vicmd '\ew' insert-last-command-output

prepend-sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}
zle -N prepend-sudo && bindkey -M vicmd s prepend-sudo

reset_broken_terminal() {
  printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
add-zsh-hook -Uz precmd reset_broken_terminal
