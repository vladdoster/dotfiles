#!/usr/bin/env zsh

[ -z "$ZPROF" ] || zmodload zsh/zprof

  0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
  0="${${(M)0:#/*}:-$PWD/$0}"
  # print -- "${0:h}"
  local ZDOTDIR="${0:h}"
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
    # print -- "$f"
  done

[ -z "$ZPROF" ] || zprof

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
