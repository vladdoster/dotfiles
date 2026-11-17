#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:

setopt typeset_silent extended_glob no_global_rcs
# no_global_rcs skips /etc/zshrc in login shells. Keep the two settings it makes on macOS.
disable log
setopt combining_chars

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
  # ~/.bun goes last: a stale _bun from a standalone install must not shadow Homebrew's
  fpath=(${ZDOTDIR}/{functions,completions}(N/) ${HOME}/.docker/completions(N/) $fpath ${HOME}/.bun(N/))
  autoload -Uz -- ${ZDOTDIR}/functions/*~*.(md|zwc)(N-.:t)
}
