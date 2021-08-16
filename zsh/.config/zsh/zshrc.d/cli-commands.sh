#!/usr/bin/env bash

brew-remove() { # Delete (one or multiple) selected application(s)
    local uninst=$(brew leaves | fzf -m)

    if [ $uninst ]; then
        for prog in $(echo $uninst); do
            brew uninstall $prog
        done
    fi
}

brew-install() { # Install (one or multiple) selected application(s)
    local inst=$(brew search $1 | fzf)

    if [ $inst ]; then
        for prog in $(echo $inst); do
            echo "--- Installing $prog"
            brew install $prog
        done
    fi
}

# SSH -------------------------------------------
add-ssh-host() { # Adds entry to ~/.ssh/config
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
docker-cleanup() { # Delete all Docker volumes, images, and containers
    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
    docker volume rm $(docker volume ls -qf dangling=true)
}

docker-container-shell() { # Get interactive shell to a container
    docker-compose exec -it "$1" /bin/bash
}

# GIT --------------------------------------------
# MISC. ------------------------------------------
fd() { # cd to a child directory via FZF
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m) \
        && cd "$dir"
}

set-zsh-as-default-sh() { # Attempts to set ZSH as default shell
    sudo sh --command "echo $(which zsh) >> /etc/shells"
    chsh -s "$(which zsh)"
    echo "--- Set zsh as default shell"
}
