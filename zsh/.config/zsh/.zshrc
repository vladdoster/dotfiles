#!/usr/bin/env zsh

[[ -n $PROFILE_ZSH ]] && {
  PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
  exec 3>&2 2>"${HOME}/zshstart.$$.log"
  setopt xtrace prompt_subst
}

zshrc::autoload() {
  fpath=(${ZDOTDIR:-~/.config/zsh}/functions $fpath)
  builtin autoload -Uz $fpath[1]/*(.:t)
  for f in aliases zinit widget; do
    . "${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh"
  done
}

zshrc::completion() {
  zstyle ':completion:*' cache-path ${ZSH_CACHE_DIR:-${ZDOTDIR:-$HOME/.config/zsh}}/.zcompdump
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' special-dirs false
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*:cd:*' ignore-parents parent pwd
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
  # zstyle ':completion:*:functions' ignored-patterns '_*'
}

zshrc::history() {
  export HISTFILE="$HOME/.local/share/zsh/zsh_history"
  [ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
  [ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
  setopt extended_history       # record timestamp of command in HISTFILE
  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt hist_ignore_dups       # ignore duplicated commands history list
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify            # show command with history expansion to user before running it
  setopt share_history          # share command history data
}

zshrc::misc() {
  # if [[ $EDITOR = nvim || $((has nvim && nvim --headless --noplugin -c ':qall' )) ]]; then
  if [[ $EDITOR == nvim ]] || (has nvim); then
    export EDITOR='nvim'
  elif has vim; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
  # for a in v vi vim; alias $a="$EDITOR"
  # set hard limits, smaller stack, and no core dumps
  unlimit
  limit stack 8192
  limit core 0
  limit -s
  umask 022
  setopt AUTOCD
}

zshrc::update-path() {
  typeset -gU PATH path
  path=($(print -r $HOME/.local/bin/{,python/bin}) "${path[@]}")
}
# +──────+
# │ MAIN │
# +──────+
[[ -n $PROFILE_ZSH ]] && {
  unsetopt xtrace
  exec 2>&3 3>&-
}
zshrc::autoload
zshrc::completion
zshrc::misc
zshrc::history
zshrc::update-path

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
