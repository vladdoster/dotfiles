(( ! $+commands[fzf] )) && {
    _gen_fzf_default_opts() {
      local background='#0f1117'
      local bblack='#575860'
      local bg3='#29394f'
      local bg4='#39605d'
      local black='#000000'
      local blue='#719cd6'
      local cyan='#63cdcf'
      local foreground='#cdcecf'
      local green='#81b29a'
      local magenta='#9d79d6'
      local red='#ff0000'
      local white='#fdfefe'
      local yellow='#f9e79f'

      export FZF_DEFAULT_OPTS="
        --color bg+:$bg3
        --color bg:$background
        --color border:$bg4
        --color fg+:$yellow
        --color fg:$bblack
        --color gutter:$background
        --color header:$white
        --color hl+:$magenta
        --color hl:$magenta
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
        --prompt '> '
      "
    }

    _gen_fzf_default_opts

    (( ! $+commands[rg] )) && {
        export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
    }

    if (( ! $+commands[brew] )) && [[ $- == *i* ]] {
        source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    }
}
