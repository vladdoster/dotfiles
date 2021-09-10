#!/usr/bin/env bash
timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
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
# MISC. ------------------------------------------
# get-passwd() { # search 1password cli via fzf
#     lpass show -c --password $(lpass ls | fzf | awk '{print $(NF)}' | sed 's/\]//g')
# }

set-zsh-as-default-sh() { # attempts to set zsh as default shell
    sudo sh --command "echo $(which zsh) >> /etc/shells"
    chsh -s "$(which zsh)"
    echo "--- Set zsh as default shell"
}
