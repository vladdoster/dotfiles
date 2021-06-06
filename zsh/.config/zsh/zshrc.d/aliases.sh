#!/usr/bin/env zsh
#--- SYSTEM SPECIFIC
if [[ $OSTYPE =~ "darwin" ]]; then
    alias ll="gls"
    alias ls='gls -AlhF --color=auto'
    alias readlink="greadlink"
#    alias get-public-ssh-key="cat ${HOME}/.ssh/id_rsa.pub | pbcopy -pboard general && echo 'Copied SSH key to clipboard.'"
else
    alias ll="ls"
    alias ls="ls -AlhF --color=auto"
    alias get-public-ssh-key="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi
#--- NAVIGATION
alias .....="cd ../../../.."
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..="cd .."
alias h="cd $HOME && ls"
#--- FILE LOCATIONS
alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"
# EDITOR
if ! command -v nvim &> /dev/null; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
fi
alias v.="$EDITOR ."
alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
# CONFIG SHORTCUTS
alias cfg="cd ${XDG_CONFIG_HOME:-~/.config} && ls -al"
alias e-aliases="$EDITOR $ZDOTDIR/zshrc.d/aliases.sh"
alias e-cli-commands="$EDITOR $ZDOTDIR/zshrc.d/cli-commands.sh"
alias e-hspoon="$EDITOR $HOME/.hammerspoon/init.lua"
alias e-tmux="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"
alias e-vimrc="$EDITOR $XDG_CONFIG_HOME/nvim/init.lua"
alias e-zshrc="$EDITOR $ZDOTDIR/.zshrc"
CODE_DIR="${HOME:-~}"/code
if [[ ! -e $CODE_DIR ]] || [[ ! -d $CODE_DIR ]]; then
    mkdir "$CODE_DIR"
fi
alias c="cd $CODE_DIR && ls"
alias h="cd $HOME && ls"
alias dfiles="cd $XDG_CONFIG_HOME/dotfiles && ls"
alias downloads="cd $HOME/Downloads && ls"
alias r-black="find . -maxdepth 1 -type f -name  '*.py' -print -exec python3 -m black --line-length=120 --target-version py38 {} \;"
alias r-shellharden="find . -maxdepth 1 -type f -name '*.sh' -print -exec shellharden --replace {} \;"
alias r-shfix="r-shellharden && r-shfmt"
alias r-shfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
# GIT ALIASES ARE IN ~/.GITCONFIG.
alias g='git'
alias rr='cd "$(git rev-parse --show-toplevel)" && ls'
# MISC.
alias scratchpad="$EDITOR $(mktemp -t scratch.XXX.md)"
alias generate-passwd="openssl rand -base64 24"
alias get-my-ip="curl ifconfig.co"
alias reload-sh="exec $SHELL"
# PYTHON
alias start-http_server="python2 -m SimpleHTTPServer"
alias venv-activate="source ./.venv/bin/activate"
alias venv-create="python3 -m venv ./.venv"
# WEBSERVER DEBUGGING
alias get-open-ports='netstat -tulanp' # list open ports
alias get-site-headers='curl -I'       # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate
alias ping='ping -c 10'                # ping 10 times
# DISPLAYS
alias fix-dual-displays="display-fixer \
				'id:A49C2C45-F295-3FAE-B81F-247EB03CA52B res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0'
				'id:D614B2F2-B098-8A35-508D-7CEA39295FC9 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(2560,0) degree:0'"
#alias ssh="kitty +kitten ssh"
# DOCKER
#alias dcd='docker-compose -f local.yml down --remove-orphans --rmi all --volumes'
#alias dcu='docker-compose -f local.yml up'
