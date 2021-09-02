#!/usr/bin/env bash

#- GENERAL -------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export SHELL=$(which zsh)
#- XDG DIRS ------------------------------------------
export XDG_DESKTOP_DIR="$HOME"/Desktop
export XDG_DOCUMENTS_DIR="$HOME"/Documents
export XDG_DOWNLOAD_DIR="$HOME"/Downloads
export XDG_MUSIC_DIR="$HOME"/Music
export XDG_PICTURES_DIR="$HOME"/Pictures
export XDG_VIDEOS_DIR="$HOME"/Videos
# cache
export XDG_CACHE_HOME="$HOME"/.cache
# config
export XDG_CONFIG_HOME="$HOME"/.config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# data
export XDG_DATA_HOME="$HOME"/.local/share
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export GOPATH="$XDG_DATA_HOME"/go
export OHMYZSH="$XDG_DATA_HOME"/ohmyzsh

# enabling buildkit backend in docker and docker-compose
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# LOCAL SCRIPTS
export PATH="$HOME/.local/bin:$PATH"

if [[ $OSTYPE == darwin* ]]; then
        #- PROGRAMS ------------------------------------------
        export INFOPATH="/usr/local/share/info:$INFOPATH"
        export MANPATH="/usr/local/share/man:$MANPATH"
        export PATH="/usr/local/bin:$PATH"
        export PATH="/usr/local/sbin:$PATH"
        #- GNU -----------------------------------------------
        local_opt="$local_opt"
        export PATH="$local_opt/ed/libexec/gnubin:$PATH"         # ED
        export PATH="$local_opt/findutils/libexec/gnubin:$PATH"  # FINDUTILS
        export PATH="$local_opt/gnu-indent/libexec/gnubin:$PATH" # GNU-INDENT
        export PATH="$local_opt/gnu-sed/libexec/gnubin:$PATH"    # GNU-SED
        export PATH="$local_opt/gnu-tar/libexec/gnubin:$PATH"    # GNU-TAR
        export PATH="$local_opt/gnu-which/libexec/gnubin:$PATH"  # GNU-WHICH
        export PATH="$local_opt/grep/libexec/gnubin:$PATH"       # GREP
        # bison
        export PATH="$local_opt/bison/bin:$PATH"
        export LDFLAGS="-L$local_opt/bison/lib"
        # coreutils
        export PATH="$local_opt/coreutils/libexec/gnubin:$PATH"
        export MANPATH="$local_opt/coreutils/libexec/gnuman:$MANPATH"
        # make
        export PATH="$local_opt/make/libexec/gnubin:$PATH"
        export MANPATH="$local_opt/make/libexec/gnuman:$MANPATH"
        #- MISC. PROGRAMS -------------------------------------
        export PATH="$local_opt/file-formula/bin:$PATH"   # FILE-FORMULA
        export PATH="$local_opt/m4/bin:$PATH"             # M4
        export PATH="$local_opt/python/libexec/bin:$PATH" # PYTHON
        export PATH="$local_opt/unzip/bin:$PATH"          # UNZIP
        # cURL
        export PATH="$local_opt/curl/bin:$PATH"
        export CURL_SSL_BACKEND="secure-transport"
        # flex
        export PATH="$local_opt/flex/bin:$PATH"
        export LDFLAGS="-L$local_opt/flex/lib"
        export CPPFLAGS="-I$local_opt/flex/include"
        # golang
        export PATH="$(go env GOPATH)/bin:$PATH"
        # less
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
        # libre SSL
        export PATH="$local_opt/libressl/bin:$PATH"
        export LDFLAGS="-L$local_opt/libressl/lib"
        export CPPFLAGS="-I$local_opt/libressl/include"
        export PKG_CONFIG_PATH="$local_opt/libressl/lib/pkgconfig"
fi
