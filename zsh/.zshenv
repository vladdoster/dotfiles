#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:

# .zshenv runs for every zsh, including scripts and subshells: keep it minimal.
# Homebrew setup lives in .zprofile, which already probes every install prefix.
: ${ZDOTDIR:=$HOME/.config/zsh}
