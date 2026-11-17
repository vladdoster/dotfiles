#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:

(( $+commands[fzf] )) && () {
  local -A theme=(
    background '#0f1117' bblack '#575860' bg3 '#29394f' bg4 '#39605d'
    blue '#719cd6' green '#81b29a' magenta '#9d79d6' white '#fdfefe' yellow '#f9e79f'
  )
  local -a fzf_default_opts=(
    "--color bg+:${theme[bg3]} --color bg:${theme[background]} --color border:${theme[bg4]}"
    "--color fg+:${theme[yellow]} --color fg:${theme[bblack]}"
    "--color gutter:${theme[background]} --color header:${theme[white]}"
    "--color hl+:${theme[magenta]} --color hl:${theme[magenta]}"
    "--color info:${theme[yellow]} --color marker:${theme[blue]} --color pointer:${theme[white]}"
    "--color prompt:${theme[white]} --color spinner:${theme[green]}"
    "--info inline --layout reverse"
    "--marker '+ ' --padding 2,5 --pointer '>' --prompt '>'"
  )
  export FZF_DEFAULT_OPTS="${(j: :)fzf_default_opts}"
}
