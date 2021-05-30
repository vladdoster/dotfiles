#--- GENERAL
#-------------------------------
export EDITOR=nvim
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
#--- XDG DIRS
if [[ "$OSTYPE" == darwin* ]]; then
  export XDG_DESKTOP_DIR="$HOME"/Desktop
  export XDG_DOCUMENTS_DIR="$HOME"/Documents
  export XDG_DOWNLOAD_DIR="$HOME"/Downloads
  export XDG_MUSIC_DIR="$HOME"/Music
  export XDG_PICTURES_DIR="$HOME"/Pictures
  export XDG_VIDEOS_DIR="$HOME"/Videos
fi
#--- cache
export XDG_CACHE_HOME="$HOME"/.cache
#--- config
export XDG_CONFIG_HOME="$HOME"/.config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GIT_CONFIG="$XDG_CONFIG_HOME"/git/config
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
#--- data
export XDG_DATA_HOME="$HOME"/.local/share
export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure
export GOPATH="$XDG_DATA_HOME"/go
export OHMYZSH="$XDG_DATA_HOME"/ohmyzsh
# PROGRAMS
#-------------------------------
export INFOPATH="/usr/local/share/info:$INFOPATH"
export MANPATH="/usr/local/share/man:$MANPATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$USER/.local/bin:$PATH"
# GNU
#-------------------------------
#--- bison
export PATH="/usr/local/opt/bison/bin:$PATH" # GNU BISON
export LDFLAGS="-L/usr/local/opt/bison/lib" # GNU BISON
#--- coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # COREUTILS
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH" # COREUTILS
#--- ed
export PATH="/usr/local/opt/ed/libexec/gnubin:$PATH" # ED
#--- find
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH" # FINDUTILS
#--- indent
export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH" # GNU-INDENT
#--- Make
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH" # MAKE
export MANPATH="/usr/local/opt/make/libexec/gnuman:$MANPATH" # MAKE
#--- sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH" # GNU-SED
#--- tar
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" # GNU-TAR
#--- which
export PATH="/usr/local/opt/gnu-which/libexec/gnubin:$PATH" # GNU-WHICH
#--- grep
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH" # GREP
# MISC. PROGRAMS
# -------------------------------
#--- curl
export PATH="/usr/local/opt/curl/bin:$PATH"
export CURL_SSL_BACKEND=secure-transport
#--- less
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
#--- flex
export PATH="/usr/local/opt/flex/bin:$PATH" # FLEX
export LDFLAGS="-L/usr/local/opt/flex/lib" # FLEX
export CPPFLAGS="-I/usr/local/opt/flex/include" # FLEX
#--- file-formula
export PATH="/usr/local/opt/file-formula/bin:$PATH" # FILE-FORMULA
#--- homebrew
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_BUNDLE_FILE="$XDG_DATA_HOME"/homebrew/Brewfile
#--- libre SSL
export PATH="/usr/local/opt/libressl/bin:$PATH" # LIBRESSL
export LDFLAGS="-L/usr/local/opt/libressl/lib" # LIBRESSL
export CPPFLAGS="-I/usr/local/opt/libressl/include" # LIBRESSL
export PKG_CONFIG_PATH="/usr/local/opt/libressl/lib/pkgconfig" # LIBRESSL
#--- m4
export PATH="/usr/local/opt/m4/bin:$PATH" # M4
#--- python
export PATH="/usr/local/opt/python/libexec/bin:$PATH" # PYTHON
#--- unzip
export PATH="/usr/local/opt/unzip/bin:$PATH" # unzip

