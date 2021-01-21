# -- general
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

if [[ $OSTYPE =~ "darwin" ]]; then
	alias ll="gls"
	alias ls='gls -AlhF --color=auto'
	alias readlink="greadlink"
	alias get-public-ssh-key="cat $HOME/.ssh/id_rsa.pub | pbcopy -pboard general && echo 'Copied SSH key to clipboard.'"

	if [[ $TERM =~ "kitty" ]]; then
		alias ssh="kitty +kitten ssh"
	fi

else
	alias ll="ls"
	alias ls="ls -AlhF --color=auto"
	alias sshkey="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi

alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"

# -- misc.
alias generate-passwd="openssl rand -base64 24"
alias get-my-ip="curl ifconfig.co"
alias reload-zsh="source "${HOME}/.zshrc"
alias reload-bash="source "${HOME}/.bashrc"


function shfmt(){
    alias SHFMT_OPTS="-i 1 -ci -sr -kp -s -w"
    shfmt "${SHFMT_OPTS}" 
    || sudo docker run --rm -v $PWD:/work tmknom/shfmt "${SHFMT_OPTS}" 
    || echo "Unable to run shfmt" && exit 1
}

# -- webserver debugging
alias ping='ping -c 10'               # ping 10 times
alias get-open-ports='netstat -tulanp' # list open ports
alias get-website-header='curl -I'    # get web server headers
alias headerc='curl -I --compress'    # does remote server supports gzip / mod_deflate

# -- editor
alias get-scratchpad="vim $(mktemp -t scratch.XXX.md)"
alias v.="nvim ."
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# -- python
alias start-http-server="python -m SimpleHTTPServer"
alias venv-activate="source ./venv/bin/activate"
alias venv-create="python3 -m venv ./venv"

# -- git aliases are in ~/.gitconfig.
alias gcd="cd $(git rev-parse --show-toplevel)"
alias g='git'
