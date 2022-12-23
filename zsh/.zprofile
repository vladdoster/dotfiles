#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
# Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
# +─────────────────+
# │ SYSTEM SPECIFIC │
# +─────────────────+
# $- includes i if bash is interactive, allowing a shell script or startup file to test this state
_def() { [[ ! -z "${(tP)1}" ]]; }
_log() { [[ $- == *i* ]] && print -P "%F{white}[INFO]%f %F{cyan}${1}%f ⮕  %F{green}${2}%f"; }
path_append() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      export PATH="${ARG}:${PATH}"
      _log "Appended to PATH" "${ARG}"
    fi
  done
}
activate_brew() {
  LOCATIONS=( $HOME/homebrew ${HOME}/.linuxbrew/Homebrew /home/linuxbrew/.linuxbrew /opt/homebrew /usr/local )
  for F_PATH in $LOCATIONS; do
    if [[ -e "${F_PATH}/bin/brew"  ]] {
      _log "OS" "${OSTYPE} - $(uname -m)"
      if eval "${F_PATH}/bin/brew shellenv" &>/dev/null; then
          export PATH="${F_PATH}/bin:${PATH}"
          _log "Homebrew" "$(brew --repository)"
        break
      fi
    }
  done
}
activate_brew
# +────────────────────+
# │ RESERVED VARIABLES │
# +────────────────────+
typeset -aU path
local USR_PATH="/usr/local/opt"
if (( $+commands[brew] )) {
  local BREW_PATH="$(brew --prefix)"
  path_append ${BREW_PATH}/{sbin,bin}
}
path_append ${HOME}/.local/bin
# +────────+
# │ LOCALE │
# +────────+
(( $+commands[locale] )) && local loc=(${(@M)$(locale -a):#*.(utf|UTF)(-|)8})
(( $#loc )) && export LC_ALL=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}}
# +──────────────+
# │ CONFIG PATHS │
# +──────────────+
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+USER} )) || export USER="$USERNAME"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="$HOME/.local/share"
export \
  AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure \
  DOTFILES="$XDG_CONFIG_HOME"/dotfiles \
  GIT_CONFIG="$XDG_CONFIG_HOME"/git/config \
  PIP_CONFIG="$XDG_CONFIG_HOME"/pip \
  PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py \
  SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion \
  TFENV_INSTALL_DIR="${XDG_DATA_HOME}"/.tfenv \
  VIMDOTDIR="$XDG_CONFIG_HOME"/vim \
  ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# +───────────────+
# │ ENV VARIABLES │
# +───────────────+
export \
  COMPOSE_DOCKER_CLI_BUILD=1 \
  DISABLE_MAGIC_FUNCTIONS=true \
  DOCKER_BUILDKIT=1

# Zsh variable ignore everything starting with _ or .
CORRECT_IGNORE="[_|.]*"

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
