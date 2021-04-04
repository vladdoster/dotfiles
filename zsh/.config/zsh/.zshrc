# vim: ft=zsh
#--- basic
export CURL_SSL_BACKEND=secure-transport
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
if [[ ! -d $XDG_DATA_HOME/ohmyzsh && ! -e $XDG_DATA_HOME/ohmyzsh ]]; then
    git clone https://github.com/vladdoster/ohmyzsh $XDG_DATA_HOME
fi
export OHMYZSH="$XDG_DATA_HOME"/ohmyzsh
export PATH="$HOME/.local/bin:$PATH"

export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_BUNDLE_FILE="$XDG_DATA_HOME"/homebrew/Brewfile

if [[ $TERM =~ "kitty" ]] && [[ $OSTYPE == "darwin" ]]; then
	kitty + complete setup zsh | source /dev/stdin
fi
#--- HISTORY
HISTFILE="$ZDOTDIR"/.zsh_history
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
#--- ohmyzsh
CASE_SENSITIVE="false"
ZSH_THEME="ys"
plugins=(brew \
         docker \
         git \
         pip \
         python \
         tmux \
         vi-mode)
source "$OHMYZSH/oh-my-zsh.sh"
#--- sources
source <(find "$ZDOTDIR"/.zshrc.d/* -maxdepth 1 -type f -exec cat {} \;)
