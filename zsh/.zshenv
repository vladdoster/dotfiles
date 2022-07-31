#!/usr/bin/env zsh
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# +─────────────────+
# │ SYSTEM SPECIFIC │
# +─────────────────+
# $- includes i if bash is interactive, allowing a shell script or startup file to test this state
_def() { [[ ! -z "${(tP)1}" ]]; }
_echo() { [[ $- == *i* ]] && print -P "${1}"; }
path_append() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
      _echo "%F{blue}[INFO]%f: %F{cyan}Appended to PATH%f -> %F{green}${ARG}%f"
    fi
  done
}
activate_brew() {
  LOCATIONS=( '$HOME/.linuxbrew/Homebrew' '/home/linuxbrew/.linuxbrew' '/opt/homebrew' '/usr/local' )
  for F_PATH in $LOCATIONS; do
    if [[ -e "${F_PATH}/bin/brew"  ]] {
      _echo "%F{blue}[INFO]%f: %F{cyan}OS%f @ %F{green}${OSTYPE} [$(uname -m)]%f"
      if eval "${F_PATH}/bin/brew shellenv" &>/dev/null; then
        export PATH="${PATH:+"$PATH:"}${F_PATH}/bin"
        # export PATH="${F_PATH}/bin:$PATH"
        _echo "%F{blue}[INFO]%f: %F{cyan}Homebrew%f @ %F{green}${F_PATH}/bin/brew%f"
        break
      fi
    }
  done
}
activate_brew
# +────────────────────+
# │ RESERVED VARIABLES │
# +────────────────────+
local usr_path="/usr/local/opt" brew_path="$(brew --prefix)"
path_append \
  "${HOME}/.cargo/bin" \
  "${HOME}/.local/bin" \
  "${HOME}/Library/Python/3.8/bin" \
  "${HOME}/Library/Python/3.9/bin" \
  "${brew_path}/lib/ruby/gems/3.1.0/bin" \
  "${brew_path}/llvm/bin" \
  "${brew_path}/make/libexec/gnubin" \
  "${brew_path}/opt/libtool/libexec/gnubin" \
  "${brew_path}/opt/ruby/bin" \
  "${brew_path}/opt/texinfo/bin" \
  "${usr_path}/binutils/bin" \
  "${usr_path}/coreutils/libexec/gnubin" \
  "${usr_path}/gnu-sed/libexec/gnubin" \
  "${usr_path}/gnu-tar/libexec/gnubin" \
# +─────────────────+
# │ # ENV VARIABLES │
# +─────────────────+
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+USER} )) || export USER="$USERNAME"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="$HOME/.local/share"
export CLICOLOR=1
export XML_CATALOG_FILES=/opt/homebrew/etc/xml/catalog # asciidoc related
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

export ARCHPREFERENCE="arm64e,arm64,x86_64"
export COMPOSE_DOCKER_CLI_BUILD=0
export DISABLE_MAGIC_FUNCTIONS=true
export DOCKER_BUILDKIT=0
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export LESS='-F -g -i -M -R -S -w -X -z-4'
# vim:ft=zsh:sw=2:sts=2
