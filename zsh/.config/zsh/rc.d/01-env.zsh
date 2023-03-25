#!/usr/bin/env zsh

# emulate -L zsh -o EXTENDED_GLOB

#
# Environment variables
#
(( ${+TERM} )) || export TERM="xterm-256color"; COLORTERM="truecolor"
(( ${+USER} )) || export USER="${USERNAME}"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
# configuration directories
export \
  DOTFILES="${XDG_CONFIG_HOME}/dotfiles" GIT_CONFIG="${XDG_CONFIG_HOME}/git/config"             \
  PIP_CONFIG="${XDG_CONFIG_HOME}/pip"    PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/init-repl.py" \
  VIMDOTDIR="${XDG_CONFIG_HOME}/vim"     ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
# program options
export \
  COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="*zinit[-]*" \
  DISABLE_MAGIC_FUNCTIONS=1  DOCKER_BUILDKIT=1           \
  HOMEBREW_NO_{ENV_HINTS,INSTALL_CLEANUP}=1 \
  SHELL_SESSIONS_DISABLE=1
export L{ANG{,UAGE},C_ALL}='en_US.UTF-8'
# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
_comp_dumpfile="$ZDOTDIR/zcompdump"
typeset -gU FPATH PATH fpath path
path=( /{opt,usr/local}/homebrew/bin(N) /home/linuxbrew/.linuxbrew/bin(N) $path )
fpath=( ~/.config/zsh/(func|comple)tions(N) $fpath )
autoload -Uz ~/.config/zsh/functions/**/*

if (( $+commands[brew] )); then
  eval "$(brew shellenv)"
  path+=( ${HOMEBREW_PREFIX}/(s|)bin $path )
  fpath+=( $HOMEBREW_PREFIX/share/zsh/site-functions(/N) $fpath )
fi
path=( ~/.local/bin(N) ~/.local/bin/python/bin(N) $path )
