#!/usr/bin/env zsh
# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s
umask 022

HISTSIZE=2000
DIRSTACKSIZE=20
# +─────────────+
# │ COMPLETIONS │
# +─────────────+
# case insensitive
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
# complete . and .. special directories
zstyle ':completion:*' special-dirs false
# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
# +──────────+
# │ AUTOLOAD │
# +──────────+
# zsh modules
for module in 'stat' 'zpty' 'zprof'; do
  zmodload -a zsh/$module $module
done
zmodload -a -p zsh/mapfile mapfile
# personal functions
fpath=( ${ZDOTDIR:-~/.config/zsh}/functions $fpath )
autoload -U $fpath[1]/*(.:t)
# bash completion functions
autoload -U +X bashcompinit && bashcompinit
# +───────+
# │ MISC. │
# +───────+
for f in aliases zinit widget; do
  source ${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh
done

if has nvim && { nvim --headless --noplugin -c ':qall' }; then
  EDITOR='nvim'
elif has vim; then
  EDITOR='vim'
else
  EDITOR='vi'
fi
export EDITOR=$EDITOR
for i (v vi vim); do alias $i="$EDITOR"; done

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
