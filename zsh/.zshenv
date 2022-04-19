#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#

# arm64*) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
case $OSTYPE in
    darwin*)
        case $CPUTYPE in
            x86_64*)
              eval "$(/usr/local/bin/brew shellenv)"
              LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
              export CPPFLAGS="-I/usr/local/opt/llvm/include"
              export LDFLAGS="-L/usr/local/opt/llvm/lib"
              # export LDFLAGS="-L/usr/local/opt/python@3.7/lib"
              # export PKG_CONFIG_PATH="/usr/local/opt/python@3.7/lib/pkgconfig"
              # export LDFLAGS="-L/usr/local/opt/node@14/lib"
              # export CPPFLAGS="-I/usr/local/opt/node@14/include"
              export CPPFLAGS="-I/usr/local/opt/ruby@3.0/include"
              export LDFLAGS="-L/usr/local/opt/ruby@3.0/lib"
              export PATH="/usr/local/opt/llvm/bin:$PATH"
              export PATH="/usr/local/opt/node@14/bin:$PATH"
              export PATH="/usr/local/opt/python@3.7/bin:$PATH"
              export PATH="/usr/local/opt/ruby@3.0/bin:$PATH"
              ;;
        esac
    ;;
    linux*) eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ;;
    *) echo "--- ERROR: $OSTYPE is unsupported" && exit 1 ;;
esac
# RESERVED VARIABLES -------------------------------------------------------[[[
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+USER}   )) || export USER="$USERNAME"
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin" # personal scripts
export PATH="/usr/local/bin:$PATH"
# ]]]
# CONFIGURATIONS ------------------------------------------------------------[[[
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# ]]]
# ENV VARIABLES -------------------------------------------------------------[[[
export CGO_CFLAGS="-g -O2 -Wno-return-local-addr"
export CGO_ENABLED=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster
export DOCKER_BUILDKIT=1

export KEYTIMEOUT=1

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPAGER=less
export PAGER="${MANPAGER:-less}"

export PYTHONWARNINGS="ignore"

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
# ]]]
# HOMEBREW [[[
# export HOMEBREW_BOOTSNAP=0
# export HOMEBREW_INSTALL_FROM_API=0
export HOMEBREW_AUTO_UPDATE_SECS="86400"
export HOMEBREW_NO_ENV_HINTS=1
# ]]]
# PATH ---------------------------------------------------------------------[[[
setopt autocd autopushd pushdignoredups
# ]]]

# vim:ft=zsh:sw=4:sts=4:et:foldmarker=[[[,]]]:foldmethod=marker
