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
plugins=(
    brew
    docker
    git
    gh
    golang
    pip
    python
    vi-mode
    yum
    gnu-utils
)
#- OH-MY-ZSH ------------------------------------------
OHMYZSH="$HOME"/.local/share/ohmyzsh
if [[ ! -d $OHMYZSH ]] && [[ ! -e $OHMYZSH ]]; then
    git clone https://github.com/vladdoster/ohmyzsh $OHMYZSH
    echo "--- installed oh-my-zsh"
fi
if [[ -e "$OHMYZSH"/oh-my-zsh.sh ]]; then
    source "$OHMYZSH"/oh-my-zsh.sh
else
    echo "--- oh-my-zsh is unavailable"
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
    # echo "--- homebrew is unavailable"
fi
#- KITTY ----------------------------------------------
if [ -x "$(command -v kitty)" ] && [[ $TERM =~ "kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
    alias ssh='kitty +kitten ssh'
    echo "--- kitty terminal configured"
fi
#- RUST -----------------------------------------------
if [[ -e $HOME/.cargo/bin ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "--- rust env configured"
fi
#- PERSONAL SCRIPTS -----------------------------------
sourced=()
for file in $(find $ZDOTDIR/zshrc.d -maxdepth 1 -name '*.sh'); do
    . "$file"
    sourced+="$(basename $file)"
done
echo "--- sourced: ${sourced}"
