export FZF_DEFAULT_OPTS="
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
--bind 'ctrl-v:execute(code {+})'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--height=80%
--info=inline
--layout=reverse
--multi
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--preview-window=:hidden
--prompt='∼ ' --pointer='->' --marker='+'
"

brew-remove() { # delete (one or multiple) selected application(s)
    local uninst=$(brew leaves | fzf -m)

    if [ $uninst ]; then
        for prog in $(echo $uninst); do
            echo "--- removing $prog"
            brew uninstall $prog
        done
    fi
}

brew-install() { # install (one or multiple) selected application(s)
    local inst=$(brew search $1 | fzf)

    if [ $inst ]; then
        for prog in $(echo $inst); do
            echo "--- installing $prog"
            brew install $prog
        done
    fi
}

docker-stop() { # stop containers via fzf
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker stop "$cid"
}

docker-rm() { # remove containers via fzf multi-selection
    docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}

fd() { # cd to a child directory via FZF
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) \
        && cd "$dir"
}

ff() {                   # search file contents and open in $EDITOR
    [[ -n $1 ]] && cd $1 # go to provided folder or noop
    RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"

    selected=$(
        FZF_DEFAULT_COMMAND="rg --files" fzf \
            -m \
            -e \
            --ansi \
            --phony \
            --reverse \
            --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
            --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
    )

    [[ -n $selected ]] && $EDITOR $selected # open multiple files in editor
}
