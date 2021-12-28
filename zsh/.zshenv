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
            arm64*)
                eval "$(/opt/homebrew/bin/brew shellenv)"
              ;;
            x86_64*)
                eval "$(/usr/local/bin/brew shellenv)"
                export CPPFLAGS="-I/usr/local/opt/curl/include:$CPPFLAGS"
                export CPPFLAGS="-I/usr/local/opt/expat/include:$CPPFLAGS"
                export LDFLAGS="-L/usr/local/opt/curl/lib:$LDFLAGS"
                export LDFLAGS="-L/usr/local/opt/expat/lib:$LDFLAGS"
                export PATH="/usr/local/opt/curl/bin:$PATH"
                export PATH="/usr/local/opt/expat/bin:$PATH"
                export PATH="/usr/local/opt/libtool/libexec/gnubin:$PATH"
                export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"
                export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"
                export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig:$PKG_CONFIG_PATH"
                export PKG_CONFIG_PATH="/usr/local/opt/expat/lib/pkgconfig:$PKG_CONFIG_PATH"
            ;;
        esac
    ;;
    linux*)
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || true
        echo "--- INFO: $OSTYPE supported"
    ;;
    *)
        echo "--- ERROR: $OSTYPE is unsupported"
        exit 1
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
