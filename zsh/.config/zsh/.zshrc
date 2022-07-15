#!/usr/bin/env zsh

ulimit -c unlimited
zmodload zsh/complist
# +─────────────────────+
# │ LOAD CONFIGURATIONS │
# +─────────────────────+
local files=(aliases fzf zinit)
for f in "$files[@]"; do
  . "${ZDOTDIR:-$HOME/.config/zsh}/${f}".zsh
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
zle_highlight=('paste:none')
zstyle ':completion:*' complete-options true
zstyle ':completion:*' list-colors ${(s#:#)LS_COLORS} # Match dircolors with completion schema.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select # Use completion menu for completion when available.
zstyle ':completion:*' rehash true # When new programs is installed, auto update without reloading.
# PIDs
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
# Make
zstyle ':completion:*:*:make:*' tag-order 'targets'
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
