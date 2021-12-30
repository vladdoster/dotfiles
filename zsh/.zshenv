#
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
case $OSTYPE in
    darwin*)
        case $CPUTYPE in
            arm64*) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
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
    linux*) eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ;;
    *) echo "--- ERROR: $OSTYPE is unsupported" && exit 1 ;;
esac
# Sets $(env) variables for various programs.
#
# 10ms for key sequences (Decrease key input delay)
# https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1
## -- Reserved Variables -------------------------------------------------------
## XDG  Base Directory
# https://specifications.freedesktop.org/basedir-spec/latest/
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
## (( ${+*} )) = if variable is set don't set it anymore. or use [[ -z ${*} ]]
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"
## Other System
(( ${+USER}     )) || export USER="$USERNAME"
(( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
(( ${+LANG}     )) || export LANG="en_US.UTF-8"
(( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
(( ${+LC_ALL}   )) || export LC_ALL="$LANG"
## Common Apps
# https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_01
export EDITOR="vim"
export VISUAL=$EDITOR
export FCEDIT=$EDITOR
export SYSTEMD_EDITOR=$EDITOR # for systemctl
export PAGER=less
export MANPAGER="$PAGER"
## == Set Path =================================================================
## -- CDPATH ---------------------------------------------------------------------
# on cd command offer dirs in home and one dir up.
cdpath+=("$HOME" "..")
export cdpath
## -- FPATH ---------------------------------------------------------------------
## -- MANPATH ---------------------------------------------------------------------
manpath+=(/usr/local/man /usr/share/man)
export manpath
## -- PATH ---------------------------------------------------------------------
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/Application" ] ; then
  export PATH="$PATH:$HOME/Application"
fi
if [ -d "$HOME/Applications" ] ; then
  export PATH="$PATH:$HOME/Applications"
fi
if [ -d "$HOME/bin" ] ; then
  export PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/.bin" ] ; then
  export PATH="$PATH:$HOME/.bin"
fi
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$PATH:$HOME/.local/bin"
fi
if [ -d "$HOME/.cargo/bin" ] ; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
if [ -d "$HOME/.yarn/bin" ] ; then
  export PATH="$PATH:$HOME/.yarn/bin"
fi
if [ -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi
if [ -d "/snap/bin" ] ; then
  export PATH="$PATH:/snap/bin"
fi
if [ -d "/usr/sbin" ] ; then
  export PATH="$PATH:/usr/sbin"
fi
if [ -d "/usr/local/bin" ] ; then
  export PATH="$PATH:/usr/local/bin"
fi
## -- Cleanup --------------------------------------------------------------------
# remove empty components to avoid '::' ending up + resulting in './' being in $PATH
path=( "${path[@]:#}" )
## eliminates duplicates in *paths
typeset -gU cdpath fpath path
#  #=== MISC =========================================
#  export XDG_DESKTOP_DIR="$HOME"/Desktop
#  export XDG_DOCUMENTS_DIR="$HOME"/Documents
#  export XDG_DOWNLOAD_DIR="$HOME"/Downloads
#  export XDG_MUSIC_DIR="$HOME"/Music
#  export XDG_PICTURES_DIR="$HOME"/Pictures
#  export XDG_VIDEOS_DIR="$HOME"/Videos
#  #=== XDG DIRS =====================================
#  # personal scripts
#  export XDG_CONFIG_HOME="$HOME"/.config
#  export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
#  export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
#  export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
#  export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
#  export LESSHISTFILE="$XDG_CONFIG_HOME"/less/history
#  export LESSKEY="$XDG_CONFIG_HOME"/less/keys
#  export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
#  export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
#  export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
#  export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
#  #=== CONFIG =======================================
#  export XDG_CACHE_HOME="$HOME"/.cache
#  #-- CACHE
#  export XDG_DATA_HOME="$HOME"/.local/share
#  export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
#  #=== DATA =========================================
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export ZHOMEDIR="$HOME"/.config/zsh/zsh.d
