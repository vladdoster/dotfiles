#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# Sets $(env) variables for various programs.
#
#=== OS SPECIFIC =============================================
case $OSTYPE in
    darwin*)
        case $CPUTYPE in
            arm64*) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
            x86_64*)
                eval "$(/usr/local/bin/brew shellenv)"
                BREW_HOME=$(brew --prefix)
                #  export CPPFLAGS="-I${BREW_HOME}/opt/libressl/include"
                #  export LDFLAGS="-L${BREW_HOME}/opt/libressl/lib"
                #  export PATH="${BREW_HOME}/opt/libressl/bin:$PATH"
                #  export PKG_CONFIG_PATH="${BREW_HOME}/opt/libressl/lib/pkgconfig"
                #  export PATH="/usr/local/opt/libressl/bin:$PATH"
                #  export PKG_CONFIG_PATH="${BREW_HOME}/opt/libressl/lib/pkgconfig"
                #  export PKG_CONFIG_PATH="/usr/local/opt/libressl/lib/pkgconfig"
                export CPPFLAGS="-I${BREW_HOME}/opt/flex/include"
                export INFOPATH="${BREW_HOME}/share/info:$INFOPATH"
                export LDFLAGS="-L${BREW_HOME}/opt/bison/lib"
                export LDFLAGS="-L${BREW_HOME}/opt/flex/lib"
                export MANPATH="${BREW_HOME}/opt/coreutils/libexec/gnuman:$MANPATH"
                export MANPATH="${BREW_HOME}/opt/make/libexec/gnuman:$MANPATH"
                export MANPATH="${BREW_HOME}/share/man:$MANPATH"
                export PATH="${BREW_HOME}/bin:$PATH"
                export PATH="${BREW_HOME}/opt/bison/bin:$PATH"
                export PATH="${BREW_HOME}/opt/coreutils/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/ed/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/file-formula/bin:$PATH"
                export PATH="${BREW_HOME}/opt/findutils/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/flex/bin:$PATH"
                export PATH="${BREW_HOME}/opt/gnu-indent/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/gnu-sed/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/gnu-tar/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/gnu-which/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/grep/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/m4/bin:$PATH"
                export PATH="${BREW_HOME}/opt/make/libexec/gnubin:$PATH"
                export PATH="${BREW_HOME}/opt/man-db/libexec/bin:$PATH"
                export PATH="${BREW_HOME}/opt/python/libexec/bin:$PATH"
                export PATH="${BREW_HOME}/opt/unzip/bin:$PATH"
                export PATH="/usr/local/opt/krb5/bin:$PATH"
                export PATH="/usr/local/opt/krb5/sbin:$PATH"
                export PKG_CONFIG_PATH="/usr/local/opt/krb5/lib/pkgconfig"
                export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
                unset BREW_HOME
                ;;
        esac
        ;;
    linux*)
        export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/openjdk@8/include"
        export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@8/bin:$PATH"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        export PATH="/home/linuxbrew/.linuxbrew/opt/go@1.13/bin:$PATH"
        export PATH="/home/linuxbrew/.linuxbrew/opt/terraform@0.12/bin:$PATH"
        ;;
    *)
        echo --- ERROR: "$OSTYPE" is unsupported
        exit 1a
        ;;
esac
#=== OS SPECIFIC =============================================
export PATH=$HOME/.local/bin:/usr/local/sbin:$PATH
# Rust
export PATH=$HOME/.cargo/bin:$PATH
export HOMEBREW_NO_ENV_HINTS=1
#=== MISC =========================================
export XDG_DESKTOP_DIR="$HOME"/Desktop
export XDG_DOCUMENTS_DIR="$HOME"/Documents
export XDG_DOWNLOAD_DIR="$HOME"/Downloads
export XDG_MUSIC_DIR="$HOME"/Music
export XDG_PICTURES_DIR="$HOME"/Pictures
export XDG_VIDEOS_DIR="$HOME"/Videos
#=== XDG DIRS =====================================
# personal scripts
export PATH="${HOME}/.local/bin:$PATH"
export PATH="usr/local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME"/.config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export LESSHISTFILE="$XDG_CONFIG_HOME"/less/history
export LESSKEY="$XDG_CONFIG_HOME"/less/keys
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
#=== CONFIG =======================================
export XDG_CACHE_HOME="$HOME"/.cache
#-- CACHE
export XDG_DATA_HOME="$HOME"/.local/share
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
#=== DATA =========================================
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export ZHOMEDIR="$HOME"/.config/zsh/zsh.d
