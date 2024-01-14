#!/usr/bin/env zsh
# environment variables
(( ${+TERM} )) || export TERM="xterm-256color"; COLORTERM="truecolor"
(( ${+USER} )) || export USER="${USERNAME}"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
# configuration directories
export \
  CODEDIR="$HOME/code" DOTFILES="${XDG_CONFIG_HOME}/dotfiles" \
  GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" PIP_CONFIG="${XDG_CONFIG_HOME}/pip" \
  PYTHONPATH="${XDG_DATA_HOME}/python" VIMDOTDIR="${XDG_CONFIG_HOME}/vim" \
  ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
# program options
export \
  COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="*zinit[-]*" \
  DISABLE_MAGIC_FUNCTIONS=1  DOCKER_BUILDKIT=1 \
  HOMEBREW_NO_{ENV_HINTS,INSTALL_CLEANUP}=1 \
  SHELL_SESSIONS_DISABLE=1

#------------------------------
# Prompt
#------------------------------
autoload -U colors zsh/terminfo
colors
