#!/usr/bin/env zsh

[[ ! -z $PROFILE_ZSH ]] && {
  PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
  exec 3>&2 2> "${HOME}/zshstart.$$.log"
  setopt xtrace prompt_subst
}

zshrc::autoload() {
  fpath=( ${ZDOTDIR:-~/.config/zsh}/functions $fpath )
  autoload -U +X $fpath[1]/*(.:t)
  #autoload -U +X bashcompinit && bashcompinit
  for f in aliases zinit widget; . "${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh";
}

zshrc::completion() {
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*' cache-path ${ZSH_CACHE_DIR:-${XDG_CACHE_DIR:-$HOME/.cache}}/zsh/
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' special-dirs false
  zstyle ':completion:*:cd:*' ignore-parents parent pwd
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
}

zshrc::history(){
  # history file configuration
  HISTFILE=${ZSH_CACHE_DIR:-${XDG_CACHE_DIR:-$HOME/.cache}}/zsh/zsh_history
  [ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
  [ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
  # history command configuration
  setopt extended_history       # record timestamp of command in HISTFILE
  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt hist_ignore_dups       # ignore duplicated commands history list
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify            # show command with history expansion to user before running it
  setopt share_history          # share command history data DIRSTACKSIZE=20
}

zshrc::misc() {
  # if [[ $EDITOR = nvim || $((has nvim && nvim --headless --noplugin -c ':qall' )) ]]; then
  if [[ $EDITOR = nvim ]] || ( has nvim ); then
    export EDITOR='nvim'
  elif has vim; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
  for a in v vi vim; alias $a="$EDITOR"
  # set hard limits, smaller stack, and no core dumps
  unlimit; limit stack 8192; limit core 0; limit -s; umask 022
  setopt AUTOCD
}
# +──────+
# │ MAIN │
# +──────+
zshrc::history
zshrc::autoload
zshrc::completion
zshrc::misc

[[ ! -z $PROFILE_ZSH ]] && {
  unsetopt xtrace
  exec 2>&3 3>&-
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
