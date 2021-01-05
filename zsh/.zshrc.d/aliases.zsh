# -- general
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

if [[ $OSTYPE =~ "darwin"   ]]; then
  alias du="gdu"
  alias ll="gls"
  alias ls='gls -AlhF --color=auto'
  alias readlink="greadlink"
  alias sshkey="cat $HOME/.ssh/id_rsa.pub | pbcopy -pboard general && echo 'Copied SSH key to clipboard.'"
else
  alias ll="ls"
  alias ls='ls -AlhF --color=auto'
  alias sshkey="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi

if [[ $TERM =~ "kitty"   ]]; then
  alias ssh="kitty +kitten ssh"
fi

alias cpv='rsync -ah --info=progress2'
alias lt='du -sh * | sort -h'
alias mkdir='mkdir -pv'
alias tailf="less +F -R"

# -- misc.
alias fmtsh="shfmt -i 2 -s -bn -sr -ln bash "
alias genpass="openssl rand -base64 24"
alias myip='curl ifconfig.co'
alias sz="source $HOME/.zshrc"

# -- webserver debugging
alias ping='ping -c 10'
alias ports='netstat -tulanp'       # list open ports
alias header='curl -I'              # get web server headers
alias headerc='curl -I --compress'  # does remote server supports gzip / mod_deflate

# -- editor
alias scratch="vim $(mktemp -t scratch.XXX.md)"
alias v.="nvim ."
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# -- python
alias serve="python -m SimpleHTTPServer"
alias va='source ./venv/bin/activate'
alias ve='python3 -m venv ./venv'

# -- git aliases are in ~/.gitconfig.
alias gcd='cd $(git rev-parse --show-toplevel)'
alias g='git'
