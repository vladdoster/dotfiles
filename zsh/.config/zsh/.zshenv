# setopt local_options typeset_silent extended_glob prompt_subst
# emulate -LR zsh

setopt localoptions noglobalrcs norcs

# zmodload zsh/{datetime,langinfo,parameter,system,terminfo,zutil} || return
# zmodload -F zsh/files b:{zf_mkdir,zf_mv,zf_rm,zf_rmdir,zf_ln}    || return
# zmodload -F zsh/stat b:zstat                                     || return

# : ${PAGER:=less}
# export LESS='-FRX --use-color'
# export READNULLCMD=$PAGER
#
# export LESS='-R'
# export LESSOPEN='|pygmentize -g %s'

export -T MANPATH=${MANPATH:-:} manpath
export -T INFOPATH=${INFOPATH:-:} infopath
typeset -gaU cdpath fpath infopath mailpath manpath

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


local -a dirpath=(
    /{'opt','usr/local'}/Homebrew(/N)
    {'/home/linuxbrew',$HOME}/.linuxbrew(/N)
)

# hb=(/{'opt','usr/local'}/homebrew(/N) {/Users/linuxbrew,$HOME}/.linuxbrew(N))     
print -- "homebrew path: ${dirpath[1]:-not found}"
if (( !${+commands[brew]} )); then
    eval $(${dirpath[1]}/bin/brew shellenv)
fi

fpath=(${ZDOTDIR}/{completions,functions}(/N) $fpath)
for func in $^fpath/*(N-.:t); builtin autoload +X -Uz -- $func

manpath=($manpath '')

unsetopt norcs

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=4 sw=4 ts=4 tw=100:
