#!/usr/bin/env zsh

typeset -gx ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
SAVEHIST=200000
HISTSIZE=$SAVEHIST
: ${HISTFILE=$ZDOTDIR/zsh_history}

setopt extended_history
setopt inc_append_history     share_history    hist_verify
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space
zstyle ':completion:*' range 1000:100 # Try 100 history words at a time; max 1000 words.

setopt extendedglob promptsubst glob_dots

[ -z "$ZPROF" ] || zmodload zsh/zprof

if (( ! $#NO_RC )); then
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
  done
fi

for func in $^fpath/*(.N:t); builtin autoload -Uz -- "$func" >/dev/null

[ -z "$ZPROF" ] || zprof

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
