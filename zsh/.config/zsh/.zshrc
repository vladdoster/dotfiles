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
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/fzf.zsh
source $HOME/.config/zsh/util.sh
source $HOME/.config/zsh/zinit.zsh || true
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
typeset -g DIRSTACKSIZE=9
setopt ALWAYS_TO_END     # Move cursor to the end of a completed word.
setopt AUTO_LIST         # Automatically list choices on ambiguous completion.
setopt AUTO_MENU         # Show completion menu on a successive tab press.
setopt AUTO_PARAM_SLASH  # If completed parameter is a directory, add a trailing slash.
setopt AUTO_PUSHD        # Make cd push the old directory onto the directory stack
setopt COMPLETE_IN_WORD  # Complete from both ends of a word.
setopt EXTENDED_GLOB     # Needed for file modification glob modifiers with compinit.
setopt MENU_COMPLETE     # Do not autoselect the first completion entry.
setopt NO_CHASE_DOTS     # Don't resolve symbolic links upon path segments
setopt NO_CHASE_LINKS    # Don't resolve symbolic links upon changing directories
setopt NO_POSIX_CD       # Make cd command POSIX incompatible
setopt PATH_DIRS         # Perform path search even on command names with slashes.
setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory onto the stack
setopt PUSHD_MINUS       # Exchanges  the  meanings of `+` and `-` for pushd
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd
setopt PUSHD_TO_HOME     # Have pushd with no arguments act like `pushd $HOME`
# +──────────────────────+
# │ Expansion & Globbing │
# +──────────────────────+
setopt BRACE_CCL # Expand expressions in braces which would not otherwise undergo brace expansion.
setopt EXTENDED_GLOB # Treat the `#`, `~` and `^` characters as part of patterns for globbing.
setopt GLOB_DOTS # Don't require a leading '.' in a filename to be matched explicitly.
setopt MAGIC_EQUAL_SUBST # Unquoted arguments of the form `key=value` have filename expansion performed.
setopt MARK_DIRS # Append a trailing `/` to all directory names resulting from globbing.
setopt NO_NOMATCH # If a pattern has no matches, don't print an error, leave it unchanged.
# +────────────+
# │ Completion │
# +────────────+
#
PROMPT_EOL_MARK='%K{red} %k'   # mark the missing \n at the end of a comand output with a red block
WORDCHARS=''                   # only alphanums make up words in word-based zle widgets
ZLE_REMOVE_SUFFIX_CHARS=''     # don't eat space when typing '|' after a tab completion
KEYTIMEOUT=20                  # wait for 200ms for the continuation of a key sequence
zle_highlight=('paste:none')   # disable highlighting of text pasted into the command line

zstyle ':completion:*' matcher-list     "m:{a-z}={A-Z}"
zstyle ':completion:*' menu             "false"
zstyle ':completion:*' single-ignored   "show"
zstyle ':completion:*' squeeze-slashes  "true"
zstyle ':completion:*' verbose          "true"
zstyle ':completion:*' complete-options true
zstyle ':completion:*' list-colors      ${(s#:#)LS_COLORS} # Match dircolors with completion schema.
zstyle ':completion:*' matcher-list     'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu             select # Use completion menu for completion when available.
zstyle ':completion:*' rehash           true # When new programs is installed, auto update without reloading.

zstyle ':completion:*:-subscript-:*' tag-order         "indexes parameters"
zstyle ':completion:*:-tilde-:*'     tag-order         "directory-stack" "named-directories" "users"
zstyle ':completion:*:diff:*'        ignore-line       "other"
zstyle ':completion:*:functions'     ignored-patterns  "-*|_*"
zstyle ':completion:*:kill:*'        ignore-line       "other"
zstyle ':completion:*:paths'         accept-exact-dirs "true"
zstyle ':completion:*:rm:*'          file-patterns     "*:all-files"
zstyle ':completion:*:rm:*'          ignore-line       "other"
zstyle ':completion:::::'            insert-tab        "pending"
zstyle ':completion:*:parameters'    ignored-patterns  \
  "_(gitstatus|GITSTATUS|zsh_highlight|zsh_autosuggest|ZSH_HIGHLIGHT|ZSH_AUTOSUGGEST)*"

zstyle ':completion:*:ssh:argument-1:*'                    sort             'true'
zstyle ':completion:*:scp:argument-rest:*'                 sort             'true'

zstyle ':completion:*:git-*:argument-rest:heads'           ignored-patterns '(FETCH_|ORIG_|*/|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-local'     ignored-patterns '(FETCH_|ORIG_|)HEAD'
zstyle ':completion:*:git-*:argument-rest:heads-remote'    ignored-patterns '*/HEAD'
zstyle ':completion:*:git-*:argument-rest:commits'         ignored-patterns '*'
zstyle ':completion:*:git-*:argument-rest:commit-objects'  ignored-patterns '*'
zstyle ':completion:*:git-*:argument-rest:recent-branches' ignored-patterns '*'
# Make
zstyle ':completion:*:*:make:*' tag-order 'targets'
# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _list _ignored _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
