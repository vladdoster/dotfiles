#!/usr/bin/env zsh

ulimit -c unlimited
zmodload zsh/complist
# +─────────────────────+
# │ LOAD CONFIGURATIONS │
# +─────────────────────+
# local files=(aliases fzf zinit)
# for f in "$files[@]"; do
#   . "${ZDOTDIR:-$HOME/.config/zsh}/${f}".zsh
# done
source $HOME/.config/zsh/fzf.zsh
source $HOME/.config/zsh/util.sh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/zinit.zsh
# +───────────────────────+
# │ Zsh Line Editor (ZLE) │
# +───────────────────────+
typeset -g zle_highlight=(region:bg=black) # Highlight the background of the text when selecting.
typeset -g WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # List of characters considered part of a word.
setopt NO_BEEP # Don't beep on errors.
setopt VI      # Use vi emulation mode.
bindkey -M menuselect 'h' vi-backward-char; bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char;  bindkey -M menuselect 'j' vi-down-line-or-history;
# +──────────────────────+
# │ Changing Directories │
# +──────────────────────+
# typeset -g DIRSTACKSIZE=9
#setopt ALWAYS_TO_END     # Move cursor to the end of a completed word.
#setopt AUTO_LIST         # Automatically list choices on ambiguous completion.
#setopt AUTO_MENU         # Show completion menu on a successive tab press.
#setopt AUTO_PARAM_SLASH  # If completed parameter is a directory, add a trailing slash.
#setopt AUTO_PUSHD        # Make cd push the old directory onto the directory stack
#setopt COMPLETE_IN_WORD  # Complete from both ends of a word.
#setopt EXTENDED_GLOB     # Needed for file modification glob modifiers with compinit.
#setopt MENU_COMPLETE     # Do not autoselect the first completion entry.
#setopt NO_CHASE_DOTS     # Don't resolve symbolic links upon path segments
#setopt NO_CHASE_LINKS    # Don't resolve symbolic links upon changing directories
#setopt NO_POSIX_CD       # Make cd command POSIX incompatible
#setopt PATH_DIRS         # Perform path search even on command names with slashes.
#setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory onto the stack
#setopt PUSHD_MINUS       # Exchanges  the  meanings of `+` and `-` for pushd
#setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd
#setopt PUSHD_TO_HOME     # Have pushd with no arguments act like `pushd $HOME`
## +──────────────────────+
## │ Expansion & Globbing │
## +──────────────────────+
#setopt BRACE_CCL # Expand expressions in braces which would not otherwise undergo brace expansion.
#setopt EXTENDED_GLOB # Treat the `#`, `~` and `^` characters as part of patterns for globbing.
#setopt GLOB_DOTS # Don't require a leading '.' in a filename to be matched explicitly.
#setopt MAGIC_EQUAL_SUBST # Unquoted arguments of the form `key=value` have filename expansion performed.
#setopt MARK_DIRS # Append a trailing `/` to all directory names resulting from globbing.
#setopt NO_NOMATCH # If a pattern has no matches, don't print an error, leave it unchanged.
## +────────────+
## │ Completion │
## +────────────+
##
zstyle ':completion:*:*:make:*' tag-order 'targets'
#PROMPT_EOL_MARK='%K{red} %k'   # mark the missing \n at the end of a comand output with a red block
#WORDCHARS=''                   # only alphanums make up words in word-based zle widgets
#ZLE_REMOVE_SUFFIX_CHARS=''     # don't eat space when typing '|' after a tab completion
#KEYTIMEOUT=20                  # wait for 200ms for the continuation of a key sequence
#zle_highlight=('paste:none')   # disable highlighting of text pasted into the command line


#bindkey ' ' magic-space    # also do history expansion on space
#bindkey '^I' complete-word # complete on tab, leave expansion to _expand

## Setup new style completion system. To see examples of the old style (compctl
## based) programmable completion, check Misc/compctl-examples in the zsh
## distribution.
## Completion Styles

## list of completers to use
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

## allow one error for every three characters typed in approximate completer
#zstyle -e ':completion:*:approximate:*' max-errors \
#    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
## insert all expansions for expand completer
#zstyle ':completion:*:expand:*' tag-order all-expansions

## formatting and messages
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#zstyle ':completion:*' group-name ''

## match uppercase from lowercase
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## offer indexes before parameters in subscripts
#zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## command for process lists, the local web server details and host completion
##zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
##zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#zstyle '*' hosts $hosts

## Filename suffixes to ignore during completion (except after rm command)
#zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
#    '*?.old' '*?.pro'
## the same for old style completion
##fignore=(.o .c~ .old .pro)

## ignore completion functions (until the _ignored completer)
#zstyle ':completion:*:functions' ignored-patterns '_*'
