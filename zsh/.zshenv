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
export KEYTIMEOUT=1
#  ## -- Reserved Variables -------------------------------------------------------
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_CACHE_HOME}  )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+XDG_DATA_HOME}   )) || export XDG_DATA_HOME="$HOME/.local/share"
#  (( ${+USER}     )) || export USER="$USERNAME"
#  (( ${+HOSTNAME} )) || export HOSTNAME="$HOST"
#  (( ${+LANG}     )) || export LANG="en_US.UTF-8"
#  (( ${+LANGUAGE} )) || export LANGUAGE="$LANG"
#  (( ${+LC_ALL}   )) || export LC_ALL="$LANG"
## Common Apps
export EDITOR="vim"
export VISUAL=$EDITOR
export FCEDIT=$EDITOR
export SYSTEMD_EDITOR=$EDITOR
export PAGER=less
export MANPAGER="$PAGER"
#  ## -- CDPATH ---------------------------------------------------------------------
#  cdpath+=("$HOME" "..")
#  export cdpath
#  ## -- MANPATH ---------------------------------------------------------------------
#  manpath+=(/usr/local/man /usr/share/man)
#  export manpath
## -- PATH ---------------------------------------------------------------------
#  if [ -d "$HOME/.bin" ]; then export PATH="$PATH:$HOME/.bin" fi
#  if [ -d "$HOME/.cargo/bin" ]; then export PATH="$PATH:$HOME/.cargo/bin" fi
#  if [ -d "$HOME/.local/bin" ]; then export PATH="$PATH:$HOME/.local/bin" fi
#  if [ -d "$HOME/.yarn/bin" ]; then export PATH="$PATH:$HOME/.yarn/bin" fi
#  if [ -d "$HOME/Application" ]; then export PATH="$PATH:$HOME/Application" fi
#  if [ -d "$HOME/Applications" ]; then export PATH="$PATH:$HOME/Applications" fi
#  if [ -d "$HOME/bin" ]; then export PATH="$PATH:$HOME/bin" fi
#  if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin" fi
#  if [ -d "/snap/bin" ]; then export PATH="$PATH:/snap/bin" fi
#  if [ -d "/usr/local/bin" ]; then export PATH="$PATH:/usr/local/bin" fi
#  if [ -d "/usr/sbin" ]; then export PATH="$PATH:/usr/sbin" fi
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export DOTFILES="$XDG_CONFIG_HOME"/dotfiles
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init-repl.py
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export VIMDOTDIR="$XDG_CONFIG_HOME"/vim
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
path=( "${path[@]:#}" )
typeset -gU cdpath fpath path
