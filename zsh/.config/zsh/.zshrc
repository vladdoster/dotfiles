#!/usr/bin/env zsh
#- GENERAL ------------------------------------------
if [[ ! -d $XDG_DATA_HOME/ohmyzsh ]] && [[ ! -e $XDG_DATA_HOME/ohmyzsh ]]; then
    git clone https://github.com/vladdoster/ohmyzsh "$XDG_DATA_HOME"
fi
#- KITTY ---------------------------------------------
if [[ $TERM =~ "kitty" ]] && [[ $OSTYPE =~ "darwin" ]]; then
	kitty + complete setup zsh | source /dev/stdin
fi
#- HISTORY --------------------------------------------
HISTFILE="$ZDOTDIR"/zsh_history
HISTSIZE=10000
SAVEHIST="$HISTSIZE"
setopt extended_history       # add timestamps and other info to history
setopt hist_expire_dups_first # expire duplicates first
setopt hist_find_no_dups      # ignore duplicates when searching
setopt hist_ignore_all_dups   # remove older duplicate entries from history
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt hist_verify            # show substituted history command before executing
setopt inc_append_history     # add to history after every command
setopt share_history          # share history between zsh instances
#- OH-MY-ZSH -------------------------------------------
CASE_SENSITIVE="true"
ZSH_THEME="ys"
plugins=( \
  brew \
  docker \
  git gnu-utils \
  pip profiles python \
  sudo \
  vi-mode \
  zsh_reload
)
source "$OHMYZSH/oh-my-zsh.sh"
source <(find "$ZDOTDIR"/zshrc.d/* -maxdepth 1 -type f -exec cat {} \;)
if source $HOME/.cargo/env; then
  echo "--- Rust env activated"
fi

#- AUTO-START GPG --------------------------------------
# on OS X with GPGTools, comment out the next line:
# eval $(gpg-agent --daemon)
# GPG_TTY=$(tty)
# export GPG_TTY
# if [ -f "${HOME}/.gpg-agent-info" ]; then
#     . "${HOME}/.gpg-agent-info"
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
# fi
# export GPG_TTY="$(tty)"
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# gpgconf --launch gpg-agent

#- AUTO-START TMUX -------------------------------------
ssh_tmux(){
    echo "--- SSH detected, starting TMUX"        
    [ -z "$TMUX"  ] && { tmux attach || tmux new-session;}
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  ssh_tmux
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) ssh_tmux;;
  esac
fi
