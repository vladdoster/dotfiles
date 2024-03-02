#!/usr/bin/env zsh

SAVEHIST=200000
HISTSIZE=$SAVEHIST
: ${HISTFILE=$ZDOTDIR/zsh_history}
setopt {'extended','inc_append','share'}_history
setopt HIST_{'EXPIRE_DUPS_FIRST','FIND_NO_DUPS','IGNORE_ALL_DUPS','REDUCE_BLANKS','VERIFY'}

(){
  local -A dirs=( bin "${HOME}/.local/bin" share "${HOME}/.local/share" config "${HOME}/.config" code "${HOME}/code" zsh "${ZDOTDIR:-$HOME/.config/zsh}" )
  for k v in ${(kv)dirs}; do
    builtin hash -d "${k}"="${v}"
  done
}

if (( ! $#NO_RC )); then
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
  done
fi

setopt auto_cd extended_glob glob_dots interactive_comments prompt_subst

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
