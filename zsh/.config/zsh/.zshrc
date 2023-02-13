#!/usr/bin/env zsh

zshrc::autoload() {
  fpath=( ${ZDOTDIR:-~/.config/zsh}/functions $fpath )
  autoload -U +X $fpath[1]/*(.:t)
  autoload -U +X bashcompinit && bashcompinit
  for f in aliases zinit widget; . "${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh";
}

zshrc::completion() {
  # cache command completions (i.e., apt, dpkg)
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*' cache-path ${XDG_CACHE_DIR:-$HOME/.cache}
  # case insensitive
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
  # disable . and .. special directories completion
  zstyle ':completion:*' special-dirs false
  # disable named-directories autocompletion
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:cd:*' ignore-parents parent pwd
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
  # history
  HISTSIZE=2000
  DIRSTACKSIZE=20
}
# +──────+
# │ MAIN │
# +──────+
zshrc::autoload
zshrc::completion
zshrc::misc

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
