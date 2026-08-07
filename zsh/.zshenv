#!/usr/bin/env zsh
# vim: set ft=zsh:et:sts=2:sw=2:ts=2:tw=100:

# .zshenv runs for every zsh, including scripts and subshells: keep it minimal.
# Homebrew setup lives in .zprofile, which already probes every install prefix.
: ${ZDOTDIR:=$HOME/.config/zsh}
