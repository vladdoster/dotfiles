#!/usr/bin/env zsh

setopt extendedglob promptsubst

[ -z "$ZPROF" ] || zmodload zsh/zprof

for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
  source "$f"
done

[ -z "$ZPROF" ] || zprof

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
