#!/usr/bin/env zsh

# +──────────+
# │ HOMEBREW │
# +──────────+
zprofile::initialize-homebrew() {
  (( ! $+commands[brew] )) && {
    if [[ -x /opt/homebrew/bin/brew ]]; then BREW_LOCATION="/opt/homebrew/bin/brew"
    elif [[ -x /usr/local/bin/brew ]]; then BREW_LOCATION="/usr/local/bin/brew"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then BREW_LOCATION="/home/linuxbrew/.linuxbrew/bin/brew"
    elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then BREW_LOCATION="$HOME/.linuxbrew/bin/brew"
    else return
    fi
    eval "$("$BREW_LOCATION" shellenv)"
    unset BREW_LOCATION
  }
}
# +──────+
# │ PATH │
# +──────+
zprofile::update-path() {
  path=(
    $HOME/.local/bin{,/python/bin}(N)
    /usr/local/{,s}bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    $path
  )
}
# +────────+
# │ LOCALE │
# +────────+
zprofile::locale() {
  (( $+commands[locale] )) && local loc=(${(@M)$(locale -a):#*.(utf|UTF)(-|)8})
  (( $#loc )) && export LC_ALL=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}}
}
# +───────────────+
# │ ENV VARIABLES │
# +───────────────+
zprofile::env-variables() {
  (( ${+LANGUAGE} )) || export LANGUAGE="${LANG}"
  (( ${+USER} )) || export USER="${USERNAME}"
  (( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
  (( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
  (( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
  export \
    DOTFILES="${XDG_CONFIG_HOME}/dotfiles" GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" \
    PIP_CONFIG="${XDG_CONFIG_HOME}/pip" PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/init-repl.py" \
    VIMDOTDIR="${XDG_CONFIG_HOME}/vim" ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
  # program options
  export \
    COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="[_|.]*" \
    DISABLE_MAGIC_FUNCTIONS=1 DOCKER_BUILDKIT=1
}
# +──────+
# │ MAIN │
# +──────+
zprofile::env-variables
zprofile::locale
zprofile::initialize-homebrew
zprofile::update-path

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
