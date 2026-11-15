#!/usr/bin/env zsh
# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:

setopt local_options typeset_silent extended_glob prompt_subst no_global_rcs

export -T INFOPATH=${INFOPATH:-:} infopath
export -T MANPATH=${MANPATH:-:} manpath
typeset -gUa path {'cd','f','info','mail','man'}path

(){ # brew env; .zshrc sources this file when the shell is not a login shell
  local -a brew_cmd=(
    /{'opt','usr/local'}/[Hh]omebrew/bin/brew(N-.)
    {'/home/linuxbrew',$HOME}/.linuxbrew/bin/brew(N-.)
  )
  (( $#brew_cmd )) && eval "$(${brew_cmd[1]} shellenv zsh)"
}

(){
  # install dirs brew shellenv does not cover, one per Brewfile package manager
  local -a toolpath=(
    $HOME/.local/bin                          # uv
    $HOME/.cargo/bin                          # cargo
    ${GOBIN:-${GOPATH:-$HOME/go}/bin}         # go
  )
  path=(${^toolpath}(N/) $path)
  fpath=(${ZDOTDIR}/{functions,completions}(N/) $fpath)
  autoload -Uz -- ${ZDOTDIR}/functions/*~*.(md|zwc)(N-.:t)
}
