#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub: vladdoster
# Repo: https://dotfiles.vdoster.com
#
# +──────────────────+
# │ HELPER FUNCTIONS │
# +──────────────────+
-def() { [[ ! -z "${(tP)1}" ]]; }
# $- includes i if bash is interactive, allowing a shell script or startup file to test this state
-log() { [[ "{$-}" == *i* ]] && print -Pr -- "%F{green}==>%f %F{white}$1 → ${2}%f"; }
-path-append() {
  for arg in "$@"; do
    if [ -d "${arg}" ] && [[ ":$PATH:" != *":${arg}:"* ]]; then
      export PATH="${arg}:${PATH}"
      -log "Appended to PATH" "${arg}"
    fi
  done
}
# +──────────+
# │ HOMEBREW │
# +──────────+
zprofile::initialize-homebrew() {
  for repo in /{opt,usr,home/.linuxbrew/linuxbrew}/{h,H}omebrew; do
    if [[ -d $repo ]]; then
      eval "${repo}/bin/brew shellenv &>/dev/null"
      for dir in '' 's'; do
        export PATH="${repo}/${dir}bin:$PATH"
      done
      -log "homebrew" "$(brew --repository)"
      FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
      break
    fi
  done
}
# +──────+
# │ PATH │
# +──────+
zprofile::update-path(){
  typeset -aU path
  -path-append "${HOME}/.local/bin"{'',/python/bin}
  # -path-append $HOME/.{'local','luarocks'}/bin
}
# +────────+
# │ LOCALE │
# +────────+
zprofile::locale(){
  (( $+commands[locale] )) && local loc=(${(@M)$(locale -a):#*.(utf|UTF)(-|)8})
  (( $#loc )) && export LC_ALL=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}}
}
# +───────────────+
# │ ENV VARIABLES │
# +───────────────+
zprofile::env-variables(){
  (( ${+LANGUAGE} )) || export LANGUAGE="${LANG}"
  (( ${+USER} )) || export USER="${USERNAME}"
  (( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
  (( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
  (( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
  export \
    DOTFILES="${XDG_DATA_HOME}/dotfiles" GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" \
    PIP_CONFIG="${XDG_CONFIG_HOME}/pip"  PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/init-repl.py" \
    VIMDOTDIR="${XDG_CONFIG_HOME}/vim"   ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
  export \
    COMPOSE_DOCKER_CLI_BUILD=1 \
    DISABLE_MAGIC_FUNCTIONS=1 \
    DOCKER_BUILDKIT=1 \
    CORRECT_IGNORE="[_|.]*" # ignore everything starting with _ or .
}

-log "OS" ${OSTYPE}' - '$(uname -m)
zprofile::locale
zprofile::env-variables
zprofile::initialize-homebrew
zprofile::update-path

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
