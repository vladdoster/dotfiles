#
# Sets completion options.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
#
# Options
#
builtin setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
builtin setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
builtin setopt AUTO_MENU           # Show completion menu on a successive tab press.
builtin setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
builtin setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
builtin setopt GLOB_DOTS           # Perform path search even on command names with slashes.
builtin setopt PATH_DIRS           # Perform path search even on command names with slashes.
builtin unsetopt CASE_GLOB
builtin unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
builtin unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.

builtin zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

builtin zstyle '*' single-ignored show

builtin zstyle ':completion:*' completer _expand_alias _complete _match _approximate _ignored
builtin zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
builtin zstyle ':completion:*' group-name ''
builtin zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
builtin zstyle ':completion:*' rehash true
builtin zstyle ':completion:*' squeeze-slashes true
builtin zstyle ':completion:*' verbose yes

builtin zstyle ':completion:*:*:*:*:*' ignore-line 'yes'
builtin zstyle ':completion:*:*:*:*:*' menu select

builtin zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
builtin zstyle ':completion:*:*:-command-:*:*' group-order functions builtins commands
builtin zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

builtin zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
builtin zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

builtin zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
builtin zstyle ':completion:*:approximate:*' max-errors 1 numeric
builtin zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
builtin zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
builtin zstyle ':completion:*:default' list-prompt '%S%M matches%s'
builtin zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
builtin zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

builtin zstyle ':completion:*:history-words' list false
builtin zstyle ':completion:*:history-words' menu yes
builtin zstyle ':completion:*:history-words' remove-all-dups yes
builtin zstyle ':completion:*:history-words' stop yes

builtin zstyle ':completion:*:manuals' separate-sections true
builtin zstyle ':completion:*:manuals.(^1*)' insert-sections true

builtin zstyle ':completion:*:match:*' original only
builtin zstyle ':completion:*:matches' group 'yes'
builtin zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'

builtin zstyle ':completion:*:options' auto-description '%d'
builtin zstyle ':completion:*:options' description 'yes'

builtin zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

builtin zstyle ':completion:*:rm:*' file-patterns '*:all-files'

builtin zstyle ':completion:*:*:kill:*' force-list always
builtin zstyle ':completion:*:*:kill:*' insert-ids single
builtin zstyle ':completion:*:*:kill:*' menu yes select
builtin zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'

builtin zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
builtin zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

builtin zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
builtin zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
builtin zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
builtin zstyle -e ':completion:*:hosts' hosts 'reply=(
${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
# Don't complete uninteresting users...
builtin zstyle ':completion:*:*:*:users' ignored-patterns \
adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
mailman mailnull mldonkey mysql nagios \
named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
operator pcap postfix postgres privoxy pulse pvm quagga radvd \
rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

builtin zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
builtin zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
builtin zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
builtin zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
builtin zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
