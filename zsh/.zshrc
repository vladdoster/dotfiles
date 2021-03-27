# vim: ft=zsh
#--- basic
export HOMEBREW_BUNDLE_FILE="$HOME/.local/share/homebrew/Brewfile"
export LANG=en_US.UTF-8 # set language locale
export MANPATH="/usr/local/man:$MANPATH"
export OHMYZSH="$HOME/.local/share/ohmyzsh"
export PATH="$HOME/.local/bin:$PATH"

export HOMEBREW_FORCE_BREWED_CURL=1
export CURL_SSL_BACKEND=secure-transport

if [[ "$TERM" =~ "kitty" ]] && [[ "$OSTYPE" == "darwin" ]]; then
	kitty + complete setup zsh | source /dev/stdin
fi
#--- HISTORY
HISTFILE="$HOME/.zsh_history"
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
         git \
         pip \
         python \
         tmux )
source "$OHMYZSH/oh-my-zsh.sh"
#--- sources
source <(find "$HOME"/.zshrc.d/* -type f -maxdepth 1 -exec cat {} \;)
