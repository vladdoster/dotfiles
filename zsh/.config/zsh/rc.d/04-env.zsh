#!/usr/bin/env zsh
setopt extendedglob

##
# Environment variables
#
# -U ensures each entry in these is unique (that is, discards duplicates).
# typeset -agU fpath manpath path
#
# fpath+=( ~zsh/(func|comple)tions $fpath )
# local fn
# # for fn in ${0:A:h}/functions/*; do
# for fn in ~zsh/functions/*; do
#   # (( $+functions[${fn:t}] )) && unfunction ${fn:t}
#   # only autoload extensionless files
#   [[ -z "${fn:e}" ]] && autoload -Uz "${fn}"
# done
# typeset -U fpath path
# fpath=( ~/.config/zsh/functions ~/.config/zsh/completions "${fpath[@]}" )
# autoload -Uz $fpath[1]/*(.:t)
#
# autoload -Uz zrecompile
# for ((i=1; i <= $#fpath; ++i)); do
#   dir=$fpath[i]
#   zwc=${dir:t}.zwc
#   if [[ $dir == (.|..) || $dir == (.|..)/* ]]; then
#     continue
#   fi
#   files=($dir/*(N-.))
#   if [[ -w $dir:h && -n $files ]]; then
#     files=(${${(M)files%/*/*}#/})
#     if ( cd $dir:h &&
#       zrecompile -p -U -z $zwc $files ); then
#       fpath[i]=$fpath[i].zwc
#     fi
#   fi
# done
# export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.
(( ${+TERM} )) || export TERM="xterm-256color"; COLORTERM="truecolor"
(( ${+USER} )) || export USER="${USERNAME}"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
# configuration directories
export \
  DOTFILES="${XDG_CONFIG_HOME}/dotfiles" GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" \
  PIP_CONFIG="${XDG_CONFIG_HOME}/pip" PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/init-repl.py" \
  VIMDOTDIR="${XDG_CONFIG_HOME}/vim" ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
# program options
export \
  COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="*zinit[-]*" \
  DISABLE_MAGIC_FUNCTIONS=1 DOCKER_BUILDKIT=1 \
  HOMEBREW_NO_{ENV_HINTS,INSTALL_CLEANUP}=1 \
  SHELL_SESSIONS_DISABLE=1
export L{ANG{,UAGE},C_ALL}='en_US.UTF-8'
# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
typeset -gU fpath FPATH path PATH
path=(
  ~/.local/bin(N)
  ~/.local/bin/python/bin(N)
  /opt/homebrew/bin(N)
  /usr/local/homebrew/bin(N)
  /home/linuxbrew/.linuxbrew/bin(N)
  $path
)
# Add your functions to your $fpath, so you can autoload them.
# fpath=(
#   ~zsh/functions/*(N)
#   $fpath
# )
#
#
# 0=${(%):-%x}
# print "location ${0:A:h}"
# fpath=( "${0:A:h}" $fpath )
# local fn
# # for fn in ${0:A:h}/functions/*; do
# for fn in ${0:A:h}/*; do
#   (( $+functions[${fn:t}] )) && unfunction ${fn:t}
#   # only autoload extensionless files
#   [[ -z "${fn:e}" ]] && autoload -Uz "${fn}"
# done
# print -l $fpath
eval "$(brew shellenv)"
fpath=(
  ~/.config/zsh/{func,comple}tions(N)
  ~/.config/zsh/completions(N)
  $fpath
)
autoload -Uz ~/.config/zsh/functions/**/*
if command -v brew > /dev/null; then
  eval "$(brew shellenv)"
  path+=(
    ${HOMEBREW_PREFIX}/(s|)bin
    $path
  )
  # Add dirs containing completion functions to your $fpath and they will be
  # picked up automatically when the completion system is initialized.
  # Here, we add it to the end of $fpath, so that we use brew's completions
  # only for those commands that zsh doesn't already know how to complete.
  fpath+=(
    $HOMEBREW_PREFIX/share/zsh/site-functions(N)
    $fpath
  )
fi
