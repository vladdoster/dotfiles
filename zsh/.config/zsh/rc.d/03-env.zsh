#!/usr/bin/env zsh

##
# Environment variables
#

# -U ensures each entry in these is unique (that is, discards duplicates).
typeset -gU PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

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
path+=(
    ~/.local/bin/{,python/bin}
    /home/linuxbrew/.linuxbrew/bin(N)   # (N): null if file doesn't exist
    /opt/homebrew/bin(N)
    /usr/local/homebrew/bin(N)
    $path
)

# Add your functions to your $fpath, so you can autoload them.
fpath+=(
    $ZDOTDIR/{comple,func}tions
    $fpath
)


if ! command -v brew > /dev/null; then
  # `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
  # caching and compilation of <command>'s output, making it 10 times faster.
    eval "$(brew shellenv)"
    path+=(${HOMEBREW_PREFIX}/(s|)bin path)

      # Add dirs containing completion functions to your $fpath and they will be
      # picked up automatically when the completion system is initialized.
      # Here, we add it to the end of $fpath, so that we use brew's completions
      # only for those commands that zsh doesn't already know how to complete.
      fpath+=(
          $HOMEBREW_PREFIX/share/zsh/site-functions
      )
fi
