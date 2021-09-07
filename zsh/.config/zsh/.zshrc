#!/usr/bin/env zsh

_cmd_exists() {
    if command -v $1 &> /dev/null; then
        return 0
    fi
    _error "$1 not installed"
    return 1
}

_error() { echo "--- ERROR: $1" }

_info() { echo "--- INFO: $1" }

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
    gh
    git
    gnu-utils
    pip
    python
    vi-mode
    yum
)
#- OH-MY-ZSH ------------------------------------------
OHMYZSH="$HOME"/.local/share/ohmyzsh
if [[ ! -d $OHMYZSH ]] && [[ ! -e $OHMYZSH ]]; then
    git clone https://github.com/vladdoster/ohmyzsh $OHMYZSH
    _info "oh-my-zsh installed"
elif [[ -e "$OHMYZSH"/oh-my-zsh.sh ]]; then
    source "$OHMYZSH"/oh-my-zsh.sh
else
    _error "oh-my-zsh not installed"
fi
setopt mark_dirs # denote direectories with a trailing '/'
bindkey "^P" history-search-backward
bindkey "^R" history-incremental-search-backward
bindkey '^e' edit-command-line # edit command in vim
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
#- KITTY ----------------------------------------------
if _cmd_exists kitty && [[ $TERM =~ "kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
    alias ssh='kitty +kitten ssh'
    _info "kitty terminal configured"
fi
#- PERSONAL SCRIPTS -----------------------------------
sourced=()
for file in $(find $ZDOTDIR/zshrc.d -maxdepth 1 -name '*.sh'); do
    . "$file"
    sourced+="$(basename $file)"
done

_info "sourced: $sourced"
