#!/usr/bin/env zsh

if (( $+commands[fzf] )); then
    local -A theme=(
        background '#0f1117' bblack '#575860' bg3 '#29394f'
        bg4 '#39605d' black '#000000' blue '#719cd6'
        cyan '#63cdcf' foreground '#cdcecf' green '#81b29a'
        magenta '#9d79d6' red '#ff0000' white '#fdfefe'
        yellow '#f9e79f'
    )
    local -a fzf_default_opts=(
        "--color fg:${theme[bblack]} --color bg+:${theme[bg3]} --color bg:${theme[background]}"
        "--color border:${theme[bg4]} --color fg+:${theme[yellow]} --color gutter:${theme[background]}"
        "--color header:${theme[white]} --color hl+:${theme[magenta]} --color hl:${theme[magenta]}"
        "--color info:${theme[yellow]} --color marker:${theme[blue]} --color pointer:${theme[white]}"
        "--color prompt:${theme[white]} --color spinner:${theme[green]}"
        "--info inline --layout reverse"
        "--marker '+ ' --padding 2,5 --pointer '>' --prompt '>'"
    )
    export FZF_DEFAULT_OPTS=${^fzf_default_opts}
fi
