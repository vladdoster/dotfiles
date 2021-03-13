# fixes terminfo 
if [[ ${TERM} =~ "kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi
# system specific
if [[ "$OSTYPE" =~ "darwin" ]]; then
    alias ll="gls"
    alias ls='gls -AlhF --color=auto'
    alias readlink="greadlink"
    alias get_public_ssh_key="cat ${HOME}/.ssh/id_rsa.pub | pbcopy -pboard general && echo 'Copied SSH key to clipboard.'"

else
    alias ll="ls"
    alias ls="ls -AlhF --color=auto"
    alias get_public_ssh_key="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# file locations 
alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"
# editor
alias get_scratchpad="vim $(mktemp -t scratch.XXX.md)"
alias v.="nvim ."
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
# git aliases are in ~/.gitconfig.
alias g='git'
# misc.
alias generate_passwd="openssl rand -base64 24"
alias get_my_ip="curl ifconfig.co"
alias reload_zsh="source ${HOME}/.zshrc"
alias reload_bash="source ${HOME}/.bashrc"
# python
alias start_http_server="python -m SimpleHTTPServer"
alias venv_activate="source ./venv/bin/activate"
alias venv_create="python3 -m venv ./venv"
# webserver debugging
alias ping='ping -c 10'                # ping 10 times
alias get_open_ports='netstat -tulanp' # list open ports
alias get_site_headers='curl -I'     # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate
