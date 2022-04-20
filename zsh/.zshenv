#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# SYSTEM SPECIFIC <<
print -P "%F{blue}[INFO]%f: %F{cyan} ${OSTYPE} ($(arch)) detected %f"
case "${OSTYPE}" in
  darwin*)
    case $(arch) in
      arm*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
        export PATH="/opt/homebrew/bin:${PATH}"
        export PATH="/opt/homebrew/opt:$PATH"
        export PATH="/opt/homebrew/sbin:${PATH}"
        ;;
      x86_64)
        eval "$(/usr/local/bin/brew shellenv)"
        ;;
    esac
    ;;
  linux*) eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ;;
  *) print -P "%F{red}[WARNING]%f:%F{yellow} ${OSTYPE} is unsupported %f"
      ;;
esac # >>
# RESERVED VARIABLES <<
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+USER}   )) || export USER="$USERNAME"
[[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin" # personal scripts
# >>
# XDG ENV VARIABLES <<
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# >>
# ENV VARIABLES <<
export CGO_ENABLED=1
export COMPOSE_DOCKER_CLI_BUILD=1

export DISABLE_MAGIC_FUNCTIONS=true
export DOCKER_BUILDKIT=1

export HOMEBREW_INSTALL_FROM_API=0
export HOMEBREW_NO_ENV_HINTS=1

export KEYTIMEOUT=1

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PYTHONWARNINGS="ignore"

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
# >>
# PATH <<
setopt autocd autopushd pushdignoredups
# >>

# vim:ft=zsh:sw=2:sts=2:et:foldmarker=<<,>>:foldmethod=marker
