# ~/.zshenv should only be a one-liner that sources this file
# echo "source ~/.config/zsh/.zshenv" >| ~/.zshenv

export ZDOTDIR="$HOME"/.config/zsh

# set xdg dirs
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_RUNTIME_DIR="$HOME"/.xdg

if [[ "$OSTYPE" == darwin* ]]; then
  export XDG_DESKTOP_DIR="$HOME"/Desktop
  export XDG_DOCUMENTS_DIR="$HOME"/Documents
  export XDG_DOWNLOAD_DIR="$HOME"/Downloads
  export XDG_MUSIC_DIR="$HOME"/Music
  export XDG_PICTURES_DIR="$HOME"/Pictures
  export XDG_VIDEOS_DIR="$HOME"/Videos
fi

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GIT_CONFIG="$XDG_CONFIG_HOME"/git
export HG_CONFIG="$XDG_CONFIG_HOME"/hg
export PIP_CONFIG="$XDG_CONFIG_HOME"/pip
export TMUX_CONFIG="$XDG_CONFIG_HOME"/tmux
export TRANSMISSION_CONFIG="$XDG_CONFIG_HOME"/transmission
export GOPATH="$XDG_DATA_HOME"/go
export TERMINFO="$XDG_DATA_HOME"/terminfo

export SHELL_SESSIONS_DISABLE=1
#
# [[ -d "$HOME"/.config/dotfiles ]] && export DOTFILES="$HOME"/.config/dotfiles
#
#
#--- default programs
export EDITOR="nvim"
#--- less
export LESS=-R
export LESSHISTFILE="-"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
