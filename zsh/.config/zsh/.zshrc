#!/usr/bin/env zsh

#- HISTORY --------------------------------------------
HISTFILE="$ZDOTDIR"/zsh_history
HISTSIZE=10000
SAVEHIST="$HISTSIZE"
setopt extended_history       # add timestamps and other info to history
setopt hist_expire_dups_first # expire duplicates first
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt hist_verify            # show substituted history command before executing
setopt inc_append_history     # add to history after every command
setopt share_history          # share history between zsh instances
#- OH-MY-ZSH ------------------------------------------
CASE_SENSITIVE="true"
ZSH_DISABLE_COMPFIX="true"
ZSH_THEME="ys"
plugins=(   \
    brew    \
    docker  \
    git     \
    pip     \
    python  \
    vi-mode \
)
#- OH-MY-ZSH ------------------------------------------
OHMYZSH="$HOME"/.local/share/ohmyzsh
if [[ ! -d $OHMYZSH ]] && [[ ! -e $OHMYZSH ]]; then
    git clone https://github.com/vladdoster/ohmyzsh $OHMYZSH
    echo "-- installed oh-my-zsh"
fi
if [[ -e "$OHMYZSH"/oh-my-zsh.sh ]]; then
  source "$OHMYZSH"/oh-my-zsh.sh
else
  echo "--- oh-my-zsh unavailable"
fi

setopt mark_dirs # denote direectories with a trailing '/'

bindkey "^P" history-search-backward
bindkey "^R" history-incremental-search-backward
bindkey '^e' edit-command-line # edit command in vim
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
#- HOMEBREW -----------------------------------------
if [[ -e /opt/homebrew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -e /home/linuxbrew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
   echo "--- No homebrew available"
fi
#- KITTY ----------------------------------------------
if [[ $TERM =~ "kitty" ]] && [[ $OSTYPE =~ "darwin" ]]; then
	kitty + complete setup zsh | source /dev/stdin
else
    echo "--- kitty unavailable"
fi

#- RUST -----------------------------------------------
if [[ -e $HOME/.cargo/bin ]]; then
        export PATH="$HOME/.cargo/bin:$PATH"
        echo "--- rust env activated"
fi

for file in "$(find $ZDOTDIR/zshrc.d -maxdepth 1 -name '*.sh' -print -quit)"; do
    . "$file"
done
#- AUTO-START TMUX IN SSH -----------------------------
# ssh_tmux(){
#     echo "--- ssh detected, starting tmux"
#     [ -z "$TMUX"  ] && { tmux attach || tmux new-session;}
# }
# 	if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
# 	  ssh_tmux
# 	else
# 	  case $(ps -o comm= -p $PPID) in
# 	    sshd|*/sshd) ssh_tmux;;
# 	  esac
# 	fi
# fi
