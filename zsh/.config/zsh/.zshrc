#!/usr/bin/env zsh

# Search path for the cd command
cdpath=(..)

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit -s

# umask 022

# Set up aliases
# alias mv='nocorrect mv'       # no spelling correction on mv
# alias cp='nocorrect cp'       # no spelling correction on cp
# alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
# alias j=jobs
# alias pu=pushd
# alias po=popd
# alias d='dirs -v'
# alias grep=egrep

# List only directories and symbolic
# links that point to directories
#

# Fix common locale issues (e.g. less, tmux).
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export LC_LANG="${LC_LANG:-en_US.UTF-8}"
export LESSCHARSET="${LESSCHARSET:-utf-8}"
[[ $(uname) =~ 'Linux' ]] && export LC_TIME="${LC_TIME:-C.UTF-8}"

# Enable colorized otput (e.g. for `ls`).
export CLICOLOR="${CLICOLOR:-yes}"


alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
fpath=($fpath)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash
# +─────────────────────+
# │ LOAD CONFIGURATIONS │
# +─────────────────────+
for f in fzf aliases zinit rld widget; do
  source ${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh
done
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
setopt GLOB_DOTS # Don't require a leading '.' in a filename to be matched explicitly.
setopt MARK_DIRS # Append a trailing `/` to all directory names resulting from globbing.
setopt NO_NOMATCH # If a pattern has no matches, don't print an error, leave it unchanged.
## +────────────+
## │ Completion │
## +────────────+
zstyle ':completion:*:*:make:*' tag-order 'targets'
PROMPT_EOL_MARK='%K{red} %k'   # mark the missing \n at the end of a comand output with a red block
WORDCHARS=''                   # only alphanums make up words in word-based zle widgets
ZLE_REMOVE_SUFFIX_CHARS=''     # don't eat space when typing '|' after a tab completion
zle_highlight=('paste:none')   # disable highlighting of text pasted into the command line

# vim:ft=zsh:sw=2:sts=2
