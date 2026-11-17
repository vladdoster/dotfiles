#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:

setopt auto_cd extended_glob glob_dots interactive_comments prompt_subst

SAVEHIST=200000
HISTSIZE=$SAVEHIST
# macOS /etc/zshrc sets HISTFILE first in non-login shells. A default-only assignment splits history.
HISTFILE=$ZDOTDIR/zsh_history
setopt {'extended','share'}_history
setopt HIST_{'EXPIRE_DUPS_FIRST','FIND_NO_DUPS','IGNORE_ALL_DUPS','VERIFY'}

# brew env, path/fpath and autoloads live in .zprofile, which only login shells
# read; pull it in here so non-login shells get them before rc.d runs compinit
[[ -o login ]] || source ${ZDOTDIR}/.zprofile

(){
  local -A dirs=( bin "${HOME}/.local/bin" share "${HOME}/.local/share" config "${HOME}/.config" code "${HOME}/code" zsh "${ZDOTDIR:-$HOME/.config/zsh}" )
  local k v
  for k v in ${(kv)dirs}; do
    builtin hash -d "${k}"="${v}"
  done
}

if (( ! $#NO_RC )); then
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
  done
  unset f
fi

# one compinit after all plugins; cdreplay applies the compdefs zinit recorded
autoload -Uz compinit bashcompinit
compinit
# zsh::rld reads the exit status of `zsh -ilc exit`. An if statement keeps it 0 without zinit.
if (( ${+functions[zinit]} )); then
  zinit cdreplay -q
fi
# bashcompinit
