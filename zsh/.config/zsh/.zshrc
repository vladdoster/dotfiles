#!/usr/bin/env zsh


# [[ -n $PROFILE_ZSH ]] && {
#   PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
#   exec 3>&2 2>"${HOME}/zshstart.$$.log"
#   setopt xtrace prompt_subst
# }

zshrc::autoload() {
  autoload -U compinit
  fpath=(${ZDOTDIR:-~/.config/zsh}/*tions $fpath)
  for func in ~/.config/zsh/functions/*(:t); autoload -U $func
  builtin autoload -U $fpath[1]/*(.:t)
  compinit
  for f in aliases zinit widget; do
    source "${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh"
  done
}

zshrc::completion() {
  zstyle ':completion:*' use-cache on
  # zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
  zstyle ':completion:*' cache-path ${ZSH_CACHE_DIR:-${ZDOTDIR:-$HOME/.config/zsh}}/.zcompdump
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' special-dirs false
  zstyle ':completion::complete:make::' tag-order targets variable
  # zstyle ':completion:*' use-cache yes
  zstyle ':completion:*:cd:*' ignore-parents parent pwd
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
  # zstyle ':completion:*:functions' ignored-patterns '_*'
}

zshrc::history() {
  export HISTFILE="$HOME/.local/share/zsh/zsh_history"
  HISTSIZE=50000
  SAVEHIST=10000
  setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history
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
  setopt AUTOCD
}

zshrc::update-path() {
  typeset -gU PATH path
  path=($(print -r $HOME/.local/bin/{,python/bin}) "${path[@]}")
}
# +──────+
# │ MAIN │
# +──────+
# [[ -n $PROFILE_ZSH ]] && {
#   unsetopt xtrace
#   exec 2>&3 3>&-
# }
source ~/you-the-champ.zsh || return 0#
zshrc::autoload
zshrc::completion
zshrc::misc
zshrc::history
zshrc::update-path

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
