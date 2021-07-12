#!/usr/bin/env bash
#
# Collection of aliases to reduce key presses for common tasks

#- SYSTEM SPECIFIC -------------------------------
if [[ $OSTYPE =~ "darwin" ]]; then
    alias readlink="greadlink"
    alias get-public-ssh-key='pbcopy -pboard general < $HOME/.ssh/id_rsa.pub \
                           && echo "--- Copied SSH key to clipboard"'
else
    alias get-public-ssh-key='clip $HOME/.ssh/id_rsa.pub \
                           && echo "Copied SSH key to clipboard"'
fi
#- NAVIGATION ------------------------------------
if command -v exa &> /dev/null; then
    alias ls='exa \
    --colour-scale \
    --group-directories-first \
    --header \
    --long \
    --no-permissions \
    --octal-permissions \
    --time-style iso'
fi
alias .....='_go_to ../../../..'
alias ....='_go_to ../../..'
alias ...='_go_to ../..'
alias ..='_go_to ..'
#- FILE LOCATIONS --------------------------------
alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"
alias rmr="rm -rf"
alias b="cd -"
alias copy="pbcopy -pboard general <"
#- EDITOR ----------------------------------------
if command -v nvim &> /dev/null; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi
alias v.='$EDITOR .'
alias v='$EDITOR'
alias vi='$EDITOR'
alias vim='$EDITOR'
#- CONFIG SHORTCUTS ------------------------------
alias e-aliases='_edit $ZDOTDIR/zshrc.d/aliases.sh'
alias e-cli-commands='_edit $ZDOTDIR/zshrc.d/cli-commands.sh'
alias e-git='_edit $XDG_CONFIG_HOME/git/config'
alias e-hspoon='_edit $HOME/.hammerspoon/init.lua'
alias e-hspoon='_edit $HOME/.hammerspoon/init.lua'
alias e-mc-utils='_edit $ZDOTDIR/zshrc.d/mc-utils.sh'
alias e-kitty='_edit $XDG_CONFIG_HOME/kitty/kitty.conf'
alias e-tmux='_edit $XDG_CONFIG_HOME/tmux/tmux.conf'
alias e-vimrc='_edit $XDG_CONFIG_HOME/nvim/init.lua'
alias e-zshenv='_edit $HOME/.zshenv'
alias e-zshrc='_edit $ZDOTDIR/.zshrc'
#- DIRECTORY SHORTCUTS ---------------------------
CODE_DIR="${HOME:-~}"/code
if [[ ! -e $CODE_DIR ]] || [[ ! -d $CODE_DIR ]]; then
    mkdir "$CODE_DIR"
fi
alias c='_go_to $CODE_DIR'
alias cfg='_go_to $XDG_CONFIG_HOME'
alias dfiles='_go_to $XDG_CONFIG_HOME/dotfiles'
alias downloads='_go_to $HOME/Downloads'
alias h='_go_to $HOME'
alias hammerspoon-cfg='_go_to $HOME/.hammerspoon'
alias installers='_go_to $HOME/.local/bin/installers'
alias git-cfg='_go_to $XDG_CONFIG_HOME/git/config'
alias nvim-cfg='_go_to $XDG_CONFIG_HOME/nvim'
alias nvim-plugins='_go_to $XDG_CONFIG_HOME/nvim/lua/configs'
alias scripts='_go_to $HOME/.local/bin'
alias tmux-cfg='_go_to $XDG_CONFIG_HOME/tmux'
alias zsh-cfg='_go_to $ZDOTDIR'
#- GIT -------------------------------------------
alias g="git" # GIT ALIASES ARE IN ~/.GITCONFIG.
alias git-submodule-update='git submodule update --merge --remote'
alias git-submodules='_go_to $HOME/.local/share'
#- COMMAND SHORTCUTS -----------------------------
alias r-shfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias rr='_go_to $(git rev-parse --show-toplevel)'
alias rm-ds-store='find $PWD -type f -name *.DS_Store -print -delete'
#- MISC. -----------------------------------------
alias scratchpad='$EDITOR $(mktemp -t scratch.XXX.md)'
alias generate-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias reload-sh='exec $SHELL'
alias ssh='kitty +kitten ssh'
#- PYTHON ----------------------------------------
alias start-http_server='python2 -m SimpleHTTPServer'
alias venv-activate='source ./.venv/bin/activate'
alias venv-create='python3 -m venv ./.venv'
alias pip-safe='pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org'
alias pip-requirements='pip-safe -r requirements.txt'
#- WEBSERVER DEBUGGING ---------------------------
alias get-open-ports='netstat -tulanp' # list open ports
alias get-site-headers='curl -I'       # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate
alias ping='ping -c 10'                # ping 10 times
#- DISPLAYS --------------------------------------
alias fix-dual-displays='display-fixer \
				id:A49C2C45-F295-3FAE-B81F-247EB03CA52B res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0 \
				id:D614B2F2-B098-8A35-508D-7CEA39295FC9 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(2560,0) degree:0'
#- DOCKER ----------------------------------------
if command -v docker &> /dev/null; then
    alias dc='docker compose'
    alias dcb='dc build'
    alias dcl='dc logs'
    alias dclf='dc logs -f'
    alias dcps='dc ps'
    alias dcre='dc restart'
    alias dcreh='dc stop && dc up'
    alias dcu='dc up'
    alias dcud='dc up -d'
    alias dstats='docker stats $(docker ps --format={{.Names}})'
else
    echo "--- Docker unavailable"
fi
#- FILE CREATION ---------------------------------
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mksh='_mkfile sh "bash"'
alias mkpy='_mkfile py "python3"'
#- FILE FORMATTING -------------------------------
alias fmt-lua='_fmt lua "stylua -i"'
alias fmt-md="_fmt md mdformat"
alias fmt-py="_fmt py black"
alias fmt-sh='_fmt sh "shfmt -bn -ci -i 4 -ln=bash -s -sr -w"'
#- SYS -------------------------------------------
alias apt-sysupdate="sudo apt update && sudo apt upgrade -y"
alias brew-sysupdate="brew update && brew upgrade"
alias yum-sysupdate="sudo yum update && sudo yum upgrade -y"
#- UTIL FUNCTIONS --------------------------------
_edit() {
    "$EDITOR" "$1"
}
_fmt() {
    echo "--- Formatting ${1} files via ${2}"
    find . -maxdepth 1 -name "*.${1}" -print -exec bash -c "$2 {}" \;
}
_go_to() {
    cd "${1}" && ls 
}
_mkfile() {
    F_NAME="${3}.${1}"
    echo "/usr/bin/env ${2}" > "${F_NAME}"
    chmod +x "$F_NAME"
    echo "--- Created ${F_NAME}"
}
