#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# SYSTEM SPECIFIC 

# $- includes i if bash is interactive, allowing a shell script or startup file to test this state
_print() { [[ $- == *i* ]] && print -P "${1}"; }

path_append() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
        _print "%F{blue}[INFO]%f: %F{cyan}Appended to PATH%f -> %F{green}${ARG}%f"
    fi
  done
}

activate_brew() {
  LOCATIONS=( '/opt/homebrew' '/usr/local' '$HOME/.linuxbrew/Homebrew' '/home/linuxbrew/.linuxbrew' )
  for ARG in $LOCATIONS; do
    if [[ -e "${ARG}"/bin/brew  ]] {
      _print "%F{blue}[INFO]%f: %F{cyan}OS%f @ %F{green}${OSTYPE} ($(uname -m))%f"
      if eval "$( ${ARG}/bin/brew shellenv )"
      _print "%F{blue}[INFO]%f: %F{cyan}Homebrew%f @ %F{green}${ARG}/bin/brew%f"
      break
    }
  done
}
activate_brew
# RESERVED VARIABLES
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+USER}   )) || export USER="$USERNAME"
path_append "$HOME/.local/bin" # personal scriptsbrew
path_append "/opt/homebrew/opt/make/libexec/gnubin"
path_append "/usr/local/opt/coreutils/libexec/gnubin"
path_append "/usr/local/opt/gnu-sed/libexec/gnubin"
path_append "/usr/local/opt/gnu-tar/libexec/gnubin"
path_append "/Users/$USER/Library/Python/3.8/bin"
path_append "/Users/$USER/Library/Python/3.9/bin"
# XDG ENV VARIABLES 
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
# ENV VARIABLES
export COMPOSE_DOCKER_CLI_BUILD=0
export DISABLE_MAGIC_FUNCTIONS=true
export DOCKER_BUILDKIT=0
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export KEYTIMEOUT=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
# PATH
setopt autocd autopushd pushdignoredups

# vim:ft=zsh:sw=2:sts=2
