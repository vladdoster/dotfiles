#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
case $OSTYPE in
    darwin*)
        case $CPUTYPE in
            arm64*) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
            x86_64*) eval "$(/usr/local/bin/brew shellenv)" ;;
        esac
    ;;
    linux*) eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ;;
    *) echo "--- ERROR: $OSTYPE is unsupported" && exit 1 ;;
esac
# -- RESERVED VARIABLES -------------------------------------------------------
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+LANG}   )) || export LANG="en_US.UTF-8"
(( ${+LC_ALL} )) || export LC_ALL="$LANG"
(( ${+USER}   )) || export USER="$USERNAME"
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin" # personal scripts
#-- ENV VARIABLES -------------------------------------------------------------
export HOMEBREW_BOOTSNAP=1
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1
export KEYTIMEOUT=1
export MANPAGER="${PAGER:-less}"
export PAGER=less
export PYTHONWARNINGS="ignore"
#-- CONFIGURATIONS ------------------------------------------------------------
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# -- PATH ---------------------------------------------------------------------
cdpath+=("$HOME" "..") && export cdpath
manpath+=(/usr/local/man /usr/share/man) && export manpath
typeset -agU cdpath fpath path
path=( "${path[@]:#}" ) # de-deduplicate
