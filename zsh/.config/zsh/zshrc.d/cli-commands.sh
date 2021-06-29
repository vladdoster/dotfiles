#!/usr/bin/env zsh
#
# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}

j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' |  fzf --height 40% --reverse --inline-info)" 
}

add_ssh_host() {
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

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

docker-cleanup() {
    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
    docker volume rm $(docker volume ls -qf dangling=true)
}

docker-container-shell() {
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



