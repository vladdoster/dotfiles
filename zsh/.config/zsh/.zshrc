#
# sources various parts of zsh configuration
#
[ -z "$HISTFILE" ] && HISTFILE="$HOME/zsh_history"
#  [ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
#  [ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
# History command configuration
#  setopt extended_history       # record timestamp of command in HISTFILE
#  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
#  setopt hist_ignore_dups       # ignore duplicated commands history list
#  setopt hist_ignore_space      # ignore commands that start with space
#  setopt hist_verify            # show command with history expansion to user before running it
#  setopt share_history          # share command history data
# persistent rehash
zstyle ':completion:*' rehash true
WORDCHARS='*?_-.[]~&;!#$%^(){}<>|'
# source parts of configuration
zsh_config=(aliases zinit fzf)
for FILE in ${zsh_config[@]}; do
    . "$HOME/.config/zsh/$FILE".zsh
done
