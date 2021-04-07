#!/usr/bin/env zsh
#--- GENERAL
export CURL_SSL_BACKEND=secure-transport
export EDITOR=nvim
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
#---HOMEBREW
export HOMEBREW_FORCE_BREWED_CURL=1
#--- LESS
export LESS=-R
export LESSHISTFILE="-"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
#--- XDG DIRS
if [[ "$OSTYPE" == darwin* ]]; then
  export XDG_DESKTOP_DIR="$HOME"/Desktop
  export XDG_DOCUMENTS_DIR="$HOME"/Documents
  export XDG_DOWNLOAD_DIR="$HOME"/Downloads
  export XDG_MUSIC_DIR="$HOME"/Music
  export XDG_PICTURES_DIR="$HOME"/Pictures
  export XDG_VIDEOS_DIR="$HOME"/Videos
fi
#- cache
export XDG_CACHE_HOME="$HOME"/.cache
#- config
export XDG_CONFIG_HOME="$HOME"/.config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
#- data
export XDG_DATA_HOME="$HOME"/.local/share
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export GOPATH="$XDG_DATA_HOME"/go
export OHMYZSH="$XDG_DATA_HOME"/ohmyzsh
export HOMEBREW_BUNDLE_FILE="$XDG_DATA_HOME"/homebrew/Brewfile
# vim: ft=zsh
