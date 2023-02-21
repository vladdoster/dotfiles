#!/usr/bin/env zsh

[[ ! -z $PROFILE_ZSH ]] && {
  PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
  exec 3>&2 2> "${HOME}/zshstart.$$.log"
  setopt xtrace prompt_subst
}

zshrc::autoload() {
  fpath=( ${ZDOTDIR:-~/.config/zsh}/functions $fpath )
  builtin autoload -Uz $fpath[1]/*(.:t)
  for f in aliases zinit widget; . "${ZDOTDIR:-$HOME/.config/zsh}/${f}.zsh";
}

zshrc::completion() {
  zstyle ':completion:*' cache-path ${ZSH_CACHE_DIR:-${ZDOTDIR:-$HOME/.config/zsh}}/.zcompdump
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' special-dirs false
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*:cd:*' ignore-parents parent pwd
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
  # zstyle ':completion:*:functions' ignored-patterns '_*'
}

zshrc::history(){
  export HISTFILE="$HOME/.local/share/zsh/zsh_history"
  [ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
  [ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
  setopt extended_history       # record timestamp of command in HISTFILE
  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt hist_ignore_dups       # ignore duplicated commands history list
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify            # show command with history expansion to user before running it
  setopt share_history          # share command history data
}

zshrc::misc() {
  # if [[ $EDITOR = nvim || $((has nvim && nvim --headless --noplugin -c ':qall' )) ]]; then
  if [[ $EDITOR = nvim ]] || ( has nvim ); then
    export EDITOR='nvim'
  elif has vim; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
  for a in v vi vim; alias $a="$EDITOR"
  # set hard limits, smaller stack, and no core dumps
  unlimit; limit stack 8192; limit core 0; limit -s; umask 022
  setopt AUTOCD
}
# +──────+
# │ MAIN │
# +──────+
# zshrc::compinit() {
#   () {
#     setopt local_options
#     setopt extendedglob

#     local zcd=${1}
#     local zcomp_hours=${2:-24} # how often to regenerate the file
#     local lock_timeout=${2:-1} # change this if compinit normally takes longer to run
#     local lockfile=${zcd}.lock

#     if [ -f ${lockfile} ]; then
#       if [[ -f ${lockfile}(#qN.mm+${lock_timeout}) ]]; then
#         (
#           echo "${lockfile} has been held by $(< ${lockfile}) for longer than ${lock_timeout} minute(s)."
#           echo "This may indicate a problem with compinit"
#         ) >&2
#       fi
#       # Exit if there's a lockfile; another process is handling things
#       return
#     else
#       # Create the lockfile with this shell's PID for debugging
#       echo $$ > ${lockfile}
#       # Ensure the lockfile is removed
#       trap "rm -f ${lockfile}" EXIT
#     fi

#     autoload -Uz compinit

#     if [[ -n ${zcd}(#qN.mh+${zcomp_hours}) ]]; then
#       # The file is old and needs to be regenerated
#       compinit
#     else
#       # The file is either new or does not exist. Either way, -C will handle it correctly
#       compinit -C
#     fi
#   } ${ZDOTDIR:-$HOME}/.zcompdump
# }

[[ ! -z $PROFILE_ZSH ]] && {
  unsetopt xtrace
  exec 2>&3 3>&-
}
zshrc::autoload
zshrc::completion
# zshrc::compinit
zshrc::misc
zshrc::history

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
