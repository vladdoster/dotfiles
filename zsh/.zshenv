skip_global_compinit=1

ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh

ulimit -c unlimited
ulimit -d unlimited
ulimit -f unlimited
ulimit -l unlimited
ulimit -n unlimited
ulimit -s unlimited
ulimit -t unlimited

if [[ -o rcs && ! -o LOGIN && $SHLVL -eq 1 && -s ${ZDOTDIR:-$HOME}/.zprofile ]]; then
  print -- 'sourcing .zprofile'
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# [[ -e $HOME/.zprofile ]] && source $HOME/.zprofile

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
