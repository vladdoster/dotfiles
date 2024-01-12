#!/usr/bin/env zsh

SAVEHIST=200000
HISTSIZE=$SAVEHIST
: ${HISTFILE=$ZDOTDIR/zsh_history}

setopt {'extended','inc_append','share'}_history
setopt hist_{'verify','expire_dups_first','ignore_dups'}
setopt auto_cd extended_glob glob_dots interactive_comments prompt_subst

(){
  local -A dirs=( bin "${HOME}/.local/bin" share "${HOME}/.local/share" config "${HOME}/.config" code "${HOME}/code" )
  for k v in ${(kv)dirs}; do
    hash -dv "${k}"="${v}"
  done
}

[ -z "$ZPROF" ] || zmodload zsh/zprof

if (( ! $#NO_RC )); then
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
  done
fi
export PATH="/opt/homebrew/bin:$PATH"

[ -z "$ZPROF" ] || zprof

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
