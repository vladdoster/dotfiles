#!/bin/sh

# __ general
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

if [[ $OSTYPE =~ "darwin" ]]; then
 alias  ll="gls"
 alias  ls='gls -AlhF --color=auto'
 alias  readlink="greadlink"
 alias  get_public_ssh_key="cat $HOME/.ssh/id_rsa.pub | pbcopy -pboard general && echo 'Copied SSH key to clipboard.'"

 if  [[ $TERM =~ "kitty" ]]; then
  alias   ssh="kitty +kitten ssh"
 fi

else
 alias  ll="ls"
 alias  ls="ls -AlhF --color=auto"
 alias  sshkey="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi

alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"

# __ misc.
alias generate_passwd="openssl rand -base64 24"
alias get_my_ip="curl ifconfig.co"
alias reload_zsh="source ${HOME}/.zshrc"
alias reload_bash="source ${HOME}/.bashrc"

shell_fmt() {
 SHFMT_OPTS="-i 1 -ci -sr -kp -s -w"
 sudo  docker run \
  --rm \
  -v     $PWD:/work \
  tmknom/shfmt \
  -i     1 -ci -sr -kp -s -w \
  $@
}

# --- webserver debugging
alias ping='ping -c 10'                # ping 10 times
alias get_open_ports='netstat -tulanp' # list open ports
alias get_website_header='curl -I'     # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate

# __ editor
alias get_scratchpad="vim $(mktemp -t scratch.XXX.md)"
alias v.="nvim ."
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# __ python
alias start_http_server="python -m SimpleHTTPServer"
alias venv_activate="source ./venv/bin/activate"
alias venv_create="python3 -m venv ./venv"

# __ git aliases are in ~/.gitconfig.
alias gcd="cd $(git rev-parse -show-toplevel)"
alias g='git'
