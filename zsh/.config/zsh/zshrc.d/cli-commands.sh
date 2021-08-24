#!/usr/bin/env bash

brew-remove() { # delete (one or multiple) selected application(s)
    local uninst=$(brew leaves | fzf -m)

    if [ $uninst ]; then
        for prog in $(echo $uninst); do
            brew uninstall $prog
        done
    fi
}

brew-install() { # install (one or multiple) selected application(s)
    local inst=$(brew search $1 | fzf)

    if [ $inst ]; then
        for prog in $(echo $inst); do
            echo "--- Installing $prog"
            brew install $prog
        done
    fi
}

# SSH -------------------------------------------
add-ssh-host() { # adds entry to ~/.ssh/config
    echo -n "Enter host nickname: " && read HOST
    echo -n "Enter hostname: " && read HOSTNAME
    echo -n "Enter user: " && read USER
    echo -n "Enter port: " && read PORT
    cat <<- EOS >> "$HOME"/.ssh/config
Host ${HOST}
  HostName ${HOSTNAME}
  User ${USER}
  Port ${PORT}
EOS
}

parse-ssh-hosts() {
    shopt -s nocasematch
    for word in "$(grep -i "^Host" ~/.ssh/config | paste -s -)"; do
        echo "$word\n"
    done
}

# DOCKER -----------------------------------------
docker-cleanup() { # delete all docker volumes, images, and containers
    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
    docker volume rm $(docker volume ls -qf dangling=true)
}

docker-shell() { # get interactive shell to a container
    docker-compose exec -it "$1" /bin/bash
}

docker-stop() { # stop containers via fzf
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker stop "$cid"
}

docker-rm() { # remove containers via fzf multi-selection
    docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}
# MISC. ------------------------------------------
fd() { # cd to a child directory via FZF
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) \
        && cd "$dir"
}

get-passwd() { # search 1password cli via fzf
    lpass show -c --password $(lpass ls | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}

set-zsh-as-default-sh() { # attempts to set zsh as default shell
    sudo sh --command "echo $(which zsh) >> /etc/shells"
    chsh -s "$(which zsh)"
    echo "--- Set zsh as default shell"
}
