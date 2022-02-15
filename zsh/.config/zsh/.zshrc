#
# sources various parts of zsh configuration
#
#module_path+=("$HOME/.local/share/zsh/zinit/module/Src") || true
#zmodload zdharma_continuum/zinit || true

HISTFILE="$HOME/zsh_history"
HISTSIZE=50000
SAVEHIST=50000

zstyle ':completion:*' rehash true
WORDCHARS='*?_-.[]~&;!#$%^(){}<>|'

FILES=(aliases fzf git-fzf zinit)
for FILE in $FILES[@]; do
    . "${ZDOTDIR:-$HOME/.config/zsh}/$FILE".zsh
done
