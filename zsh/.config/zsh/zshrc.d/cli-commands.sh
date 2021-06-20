#!/usr/bin/env zsh
get-container-shell() {
    docker-compose exec -it "$1" /bin/bash
}
parse_ssh_hosts() {
    shopt -s nocasematch
    for word in "$(grep -i "^Host" ~/.ssh/config | paste -s -)"; do
        echo "$word\n"
    done
}
set_zsh_as_default_sh() {
    sudo sh --command "echo $(which zsh) >> /etc/shells"
    chsh -s "$(which zsh)"
    echo "Set zsh as default sh"
}
remove_ds() {
    find "$PWD" -type f -name "*.DS_Store" -print -delete
}
add_ssh_host() {
    if [ $# -gt 0 ]; then
        echo "ERROR: add-ssh-host takes no arguments" && return
    else
        echo -n "Enter host nickname: " \
            && read HOST
        echo -n "Enter hostname: " \
            && read HOSTNAME
        echo -n "Enter user: " \
            && read USER
        echo -n "Enter port: " \
            && read PORT
    fi
    cat >> "$HOME"/.ssh/config <<- END
    Host ${HOST}
      HostName ${HOSTNAME}
      User ${USER}
      Port ${PORT}
END
}
docker-cleanup() {
        docker rm $(docker ps -qa --no-trunc --filter "status=exited")
        docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
        docker volume rm $(docker volume ls -qf dangling=true)  # careful!
}
