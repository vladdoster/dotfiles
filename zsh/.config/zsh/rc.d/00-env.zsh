#!/usr/bin/env zsh
# environment variables
((${+TERM})) || export TERM="xterm-256color"
COLORTERM="truecolor"
((${+USER})) || export USER="${USERNAME}"
((${+XDG_CACHE_HOME})) || export XDG_CACHE_HOME="${HOME}/.cache"
((${+XDG_CONFIG_HOME})) || export XDG_CONFIG_HOME="${HOME}/.config"
((${+XDG_DATA_HOME})) || export XDG_DATA_HOME="${HOME}/.local/share"
# configuration directories
CODEDIR="$HOME/code"
# this file is stow-linked into the repo, so :A resolves back to the repo root
if [[ -z $DOTFILES ]]; then
  DOTFILES=${${(%):-%N}:A:h:h:h:h:h}
  [[ -d $DOTFILES/.git ]] || DOTFILES=${XDG_CONFIG_HOME}/dotfiles
fi
export \
  CODEDIR DOTFILES \
  GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" PIP_CONFIG="${XDG_CONFIG_HOME}/pip" \
  VIMDOTDIR="${XDG_CONFIG_HOME}/vim" \
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
  SHELL_SESSIONS_DISABLE=1

export PIP_TRUSTED_HOST='files.pythonhosted.org pypi.org'
export PIP_UPGRADE='true'
export PIP_NO_CACHE_DIR='true'
# export PIP_TARGET="$HOME/.local/share/python"

# vim: set expandtab filetype=zsh shiftwidth=4 tabstop=4 :
