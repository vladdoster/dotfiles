#!/usr/bin/env zsh
# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:

setopt local_options typeset_silent extended_glob prompt_subst no_global_rcs

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
typeset -gUa {'cd','f','info','mail','man'}path

# function -init-homebrew() {
#   (( ARGC )) || return 0
#   local dir=${1:h:h}
#   export HOMEBREW_PREFIX=$dir
#   export HOMEBREW_CELLAR=$dir/Cellar
#   if [[ -e $dir/Homebrew/Library ]]; then
#     export HOMEBREW_REPOSITORY=$dir/Homebrew
#   else
#     export HOMEBREW_REPOSITORY=$dir
#   fi
# }

local -a dirpath=(
    /{'opt','usr/local'}/[Hh]omebrew(/N)
    {'/home/linuxbrew',$HOME}/.linuxbrew(/N)
)

if (( !${+commands[brew]} )) && [[ -f ${dirpath[1]}/bin/brew ]] then
    print -ru2 -- "homebrew path: ${dirpath[1]:-not found}"
    eval $(${dirpath[1]}/bin/brew shellenv)
fi

fpath=(${ZDOTDIR}/{completions,functions}(/N) $fpath)
for func in $^ZDOTDIR/functions/*~*zwc(N-.:t); do
    autoload -Uz +X -- "$func"
done

manpath=($manpath '')

unsetopt norcs
