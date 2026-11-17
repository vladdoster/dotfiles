#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:
# environment variables
(( ${+TERM} )) || export TERM="xterm-256color"
export COLORTERM="truecolor"
(( ${+USER} )) || export USER="${USERNAME}"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
# configuration directories
CODEDIR="$HOME/code"
# this file is stow-linked into the repo, so walking up from it finds the checkout
if [[ -z $DOTFILES ]]; then
  DOTFILES=${${(%):-%N}:A:h}
  while [[ $DOTFILES != / && ! -d $DOTFILES/.git ]]; do DOTFILES=${DOTFILES:h}; done
  [[ -d $DOTFILES/.git ]] || DOTFILES=${XDG_CONFIG_HOME}/dotfiles
fi
export \
  CODEDIR DOTFILES \
  ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
# editor: must be a real binary. External tools (git commit, crontab -e,
# sudoedit) spawn $EDITOR via execvp and cannot resolve zsh functions.
export EDITOR="${commands[nvim]:-${commands[vim]:-vi}}"
export VISUAL="${EDITOR}"
# program options
export \
  COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="*zinit[-]*" \
  DISABLE_MAGIC_FUNCTIONS=1 DOCKER_BUILDKIT=1 \
  HOMEBREW_NO_{ENV_HINTS,INSTALL_CLEANUP}=1 \
  RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config" \
  SHELL_SESSIONS_DISABLE=1

export PIP_UPGRADE='true'
export PIP_NO_CACHE_DIR='true'
