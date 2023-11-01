#!/usr/bin/env zsh

setopt typeset_silent extended_glob prompt_subst

export ZDOTDIR="$HOME/.config/zsh"

zmodload zsh/{datetime,langinfo,parameter,system,terminfo,zutil} || return
zmodload -F zsh/files b:{zf_mkdir,zf_mv,zf_rm,zf_rmdir,zf_ln}    || return
zmodload -F zsh/stat b:zstat                                     || return

: ${PAGER:=less}
export LESS='-FRX --use-color'
export READNULLCMD=$PAGER

export LESS='-R'
export LESSOPEN='|pygmentize -g %s'

export -T MANPATH=${MANPATH:-:} manpath
export -T INFOPATH=${INFOPATH:-:} infopath
typeset -gaU cdpath fpath mailpath path manpath infopath

function -init-homebrew() {
  (( ARGC )) || return 0
  local dir=${1:h:h}
  export HOMEBREW_PREFIX=$dir
  export HOMEBREW_CELLAR=$dir/Cellar
  if [[ -e $dir/Homebrew/Library ]]; then
    export HOMEBREW_REPOSITORY=$dir/Homebrew
  else
    export HOMEBREW_REPOSITORY=$dir
  fi
}

if [[ $OSTYPE == darwin* ]]; then
  [[ -z $HOMEBREW_PREFIX ]] && -init-homebrew {/opt/homebrew,/usr/local}/bin/brew(N)
elif [[ $OSTYPE == linux* && -z $HOMEBREW_PREFIX ]]; then
  -init-homebrew {/home/linuxbrew/.linuxbrew,~/.linuxbrew}/bin/brew(N)
fi

fpath=(
  ${ZDOTDIR}/*tions(-/N)
  ${^${(M)fpath:#*/$ZSH_VERSION/functions}/%$ZSH_VERSION\/functions/site-functions}(-/N)
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions}(-/N)
  /opt/homebrew/share/zsh/site-functions(-/N)
  /usr{/local,}/share/zsh/{site-functions,vendor-completions}(-/N)
  $fpath
)


for func in $^fpath/*(N-.:t); autoload -Uz -- $func
# autoload -TUz -- ~/.config/zsh/functions/*(.:A) || return

manpath=($manpath '')

() {
  path=(${@:|path} $path)
} {~/.local/{,share/python/}bin,${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin},${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin},/opt/local/sbin,/opt/local/bin,/usr/local/sbin,/usr/local/bin}(-/N)

() {
  manpath=(${@:|manpath} $manpath '')
} {${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/man},/opt/local/share/man}(-/N)

() {
  infopath=(${@:|infopath} $infopath '')
} {${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/info},/opt/local/share/info}(-/N)

# setopt no_rcs

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
