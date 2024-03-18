#!/usr/bin/env zsh

if (( $+commands[fzf] )); then
  () {
    local \
      background='#0f1117' bblack='#575860'  bg3='#29394f'  bg4='#39605d'        \
      black='#000000'      blue='#719cd6'    cyan='#63cdcf' foreground='#cdcecf' \
      green='#81b29a'      magenta='#9d79d6' red='#ff0000'  white='#fdfefe'      yellow='#f9e79f'
    export FZF_DEFAULT_OPTS="
      --color bg+:$bg3 --color bg:$background
      --color border:$bg4
      --color fg+:$yellow --color fg:$bblack
      --color gutter:$background
      --color header:$white
      --color hl+:$magenta --color hl:$magenta
      --color info:$yellow
      --color marker:$blue
      --color pointer:$white
      --color prompt:$white
      --color spinner:$green
      --info inline
      --layout reverse
      --marker '+ '
      --padding 2,5
      --pointer '>'
      --prompt '> '" 
  }
fi