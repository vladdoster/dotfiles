#!/usr/bin/env zsh

zmodload -i zsh/parameter
autoload -Uz zkbd

function _accept-line-with-url {
  setopt localoptions extended_glob
  if [[ $BUFFER =~ ^https.*git ]]; then
    BUFFER="${BUFFER//\/tree\/*/.git}"
    echo $BUFFER >> $HISTFILE
    fc -R
    BUFFERz="git clone $BUFFER && cd $(basename $BUFFER .git)"
    zle .kill-whole-line
    BUFFER=$BUFFERz
    zle .accept-line
  elif [[ $BUFFER =~ ^[[:space:]]?\$[[:space:]] ]]; then
    echo $BUFFER >> $HISTFILE
    fc -R
    BUFFERz="$(echo ${BUFFER/\$/} | xargs)"
    BUFFER=$BUFFERz
    zle .accept-line
  else
    zle .accept-line
  fi
}
zle -N accept-line _accept-line-with-url

# Bind <alt>+s to `git status`
function _git-status {
  zle .kill-whole-line
  BUFFER="git status"
  zle .accept-line
}
zle -N _git-status && bindkey '\es' _git-status

insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output && bindkey -M vicmd '\ew' insert-last-command-output

function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo && bindkey -M vicmd s prepend-sudo

function reset_broken_terminal() {
  printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd reset_broken_terminal

local cmd_alias=""

# ---------------------
# Reveal Executed Alias
# ---------------------
# Note: disable by removing it from the hook.
# add-zsh-hook -d preexec pre_validation
alias_for() {
  [[ $1 =~ '[[:punct:]]' ]] && return
  local search=${1}
  local found="$( alias $search )"
  if [[ -n $found ]]; then
    found=${found//\\//}          # replace backslash with slash
    found=${found%\'}             # remove end single quote
    found=${found#"$search="}     # remove alias name
    found=${found#"'"}            # remove first single quote
    echo "${found} ${2}" | xargs  # return found value (with parameters)
  else
    echo ""
  fi
}

expand_command_line() {
  first=$(echo "$1" | awk '{print $1;}')
  rest=$(echo ${${1}/"${first}"/})

  if [[ -n "${first//-//}" ]]; then
    cmd_alias="$(alias_for "${first}" "${rest:1}")"                   # check if there's an alias for the command
    if [[ -n $cmd_alias ]] && [[ "${cmd_alias:0:1}" != "." ]]; then   # if there was and not start with dot
      echo "${T_GREEN}ᐳ ${T_YELLOW}${cmd_alias}${F_RESET}"            # otherwise print it
    fi
  fi
}

pre_validation() {
  [[ $# -eq 0 ]] && return
  expand_command_line "$@"
}

function enable_print_alias () {
    autoload -U add-zsh-hook    # Load the zsh hook module. 
    add-zsh-hook preexec pre_validation
}


function disable_print_alias () {
  add-zsh-hook -d preexec pre_validation
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
