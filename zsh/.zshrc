# vim: ft=zsh

# -- BASIC

export LANG=en_US.UTF-8  # set language locale

autoload -Uz bashcompinit && bashcompinit
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz vcs_info

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

setopt always_to_end # move cursor to end if word had one match
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt autocd             # change dir without cd
setopt correct            # help with mistyped commands
setopt correct_all # autocorrect commands
setopt extended_history   # add timestamps and other info to history
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt hist_verify        # show substituted history command before executing
setopt histignorealldups  # filter dupes from history
setopt inc_append_history # add to history after every command
setopt no_case_glob       # case insensitive globbing
setopt printexitvalue     # for non-zero exits
setopt prompt_subst
setopt share_history # share history between different instances of the shell
setopt sharehistory       # share history across all shells

# -- HISTORY

HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"


# -- COMPLETION 

zmodload zsh/complist               
_comp_options+=(globdots)          
zstyle ':completion:*' list-colors ''
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
LISTMAX=1000

# -- PROMPT

precmd() { vcs_info }                    # call vcs info
zstyle ':vcs_info:git:*' formats '(%b)'  # only want current branch

PROMPT='%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%~%{$fg[blue]%}${vcs_info_msg_0_}%{$fg[red]%}]%{$reset_color%}$ %b'

# -- MAPPINGS

bindkey ' ' magic-space                                   
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search  
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search 

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# vi mode
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {       # cursor shape for vi modes
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

echo -ne '\e[5 q'                 # beam cursor on startup
preexec() { echo -ne '\e[5 q' ;}  # beam cursor for each new prompt
zle -N zle-keymap-select
zle-line-init() {                 # key binding to enter insert mode 
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init

bindkey '^e' edit-command-line 

# -- SOURCES

source "$HOME/.zshrc.d/fzf.zsh"
source "$HOME/.zshrc.d/aliases.zsh"
source "$HOME/.zshrc.d/functions.zsh"


