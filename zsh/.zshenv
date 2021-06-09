#- GENERAL -------------------------------------------
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
#- XDG DIRS ------------------------------------------
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
if [[ "$OSTYPE" == darwin* ]]; then
  export XDG_DESKTOP_DIR="$HOME"/Desktop
  export XDG_DOCUMENTS_DIR="$HOME"/Documents
  export XDG_DOWNLOAD_DIR="$HOME"/Downloads
  export XDG_MUSIC_DIR="$HOME"/Music
  export XDG_PICTURES_DIR="$HOME"/Pictures
  export XDG_VIDEOS_DIR="$HOME"/Videos
  # homebrew
  if ! command -v brew &> /dev/null; then
      if [[ -e /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      export HOMEBREW_FORCE_BREWED_CURL=1
      export HOMEBREW_BUNDLE_FILE="$XDG_DATA_HOME"/homebrew/Brewfile
  fi
fi
#- PROGRAMS ------------------------------------------
export INFOPATH="/usr/local/share/info:$INFOPATH"
export MANPATH="/usr/local/share/man:$MANPATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="~/.local/bin:$PATH"
#- GNU -----------------------------------------------
export PATH="/usr/local/opt/ed/libexec/gnubin:$PATH"         # ED
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"  # FINDUTILS
export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH" # GNU-INDENT
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"    # GNU-SED
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"    # GNU-TAR
export PATH="/usr/local/opt/gnu-which/libexec/gnubin:$PATH"  # GNU-WHICH
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"       # GREP
# bison
export PATH="/usr/local/opt/bison/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/bison/lib"
# coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# make
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/make/libexec/gnuman:$MANPATH"
#- MISC. PROGRAMS -------------------------------------
export PATH="/usr/local/opt/file-formula/bin:$PATH"   # FILE-FORMULA
export PATH="/usr/local/opt/m4/bin:$PATH"             # M4
export PATH="/usr/local/opt/python/libexec/bin:$PATH" # PYTHON
export PATH="/usr/local/opt/unzip/bin:$PATH"          # UNZIP
# cURL
export PATH="/usr/local/opt/curl/bin:$PATH"
export CURL_SSL_BACKEND="secure-transport"
# flex
export PATH="/usr/local/opt/flex/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/flex/lib"
export CPPFLAGS="-I/usr/local/opt/flex/include"
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
export PATH="/usr/local/opt/libressl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libressl/lib"
export CPPFLAGS="-I/usr/local/opt/libressl/include"
export PKG_CONFIG_PATH="/usr/local/opt/libressl/lib/pkgconfig"
