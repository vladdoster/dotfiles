#!/usr/bin/env bash
#
# Collection of aliases to reduce key presses for common tasks
#
#- UTIL FUNCTIONS --------------------------------
_go_to() {
    cd "$1" && ls -al
}
_edit() {
    "$EDITOR" "$1"
}
#- SYSTEM SPECIFIC -------------------------------
if [[ $OSTYPE =~ "darwin" ]]; then
    if command -v gls &> /dev/null; then
        alias ll="gls"
        alias ls='gls -AlhF --color=auto'
        alias readlink="greadlink"
    fi
    alias get-public-ssh-key="$(pbcopy -pboard general < "$HOME"/.ssh/id_rsa.pub && printf '--- Copied SSH key to clipboard')"
else
    alias ll="ls"
    alias ls="ls -AlhF --color=auto"
    alias get-public-ssh-key="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
fi
#- FILE LOCATIONS --------------------------------
alias cpv="rsync -ah --info=progress2"
alias lt="du -sh * | sort -h"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"
#- EDITOR ----------------------------------------
if ! command -v nvim &> /dev/null; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
fi
alias v.="$EDITOR ."
alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
#- NAVIGATION ------------------------------------
alias .....="_go_to ../../../.."
alias ....="_go_to ../../.."
alias ...="_go_to ../.."
alias ..="_go_to .."
#- CONFIG SHORTCUTS ------------------------------
alias e-aliases="_edit $ZDOTDIR/zshrc.d/aliases.sh"
alias e-cli-commands="_edit $ZDOTDIR/zshrc.d/cli-commands.sh"
alias e-git="_edit $XDG_CONFIG_HOME/git/config"
alias e-hspoon="_edit $HOME/.hammerspoon/init.lua"
alias e-hspoon="_edit $HOME/.hammerspoon/init.lua"
alias e-kitty="_edit $XDG_CONFIG_HOME/kitty/kitty.conf"
alias e-tmux="_edit $XDG_CONFIG_HOME/tmux/tmux.conf"
alias e-vimrc="_edit $XDG_CONFIG_HOME/nvim/init.lua"
alias e-zshenv="_edit $HOME/.zshenv"
alias e-zshrc="_edit $ZDOTDIR/.zshrc"
#- DIRECTORY SHORTCUTS ---------------------------
CODE_DIR="${HOME:-~}"/code
if [[ ! -e $CODE_DIR ]] || [[ ! -d $CODE_DIR ]]; then
    mkdir "$CODE_DIR"
fi
alias c="_go_to $CODE_DIR"
alias cfg="_go_to $XDG_CONFIG_HOME"
alias dfiles="_go_to $XDG_CONFIG_HOME/dotfiles"
alias downloads="_go_to $HOME/Downloads"
alias h="_go_to $HOME"
alias hammerspoon-cfg="_go_to $HOME/.hammerspoon"
alias nvim-cfg="_go_to $XDG_CONFIG_HOME/nvim"
alias scripts="_go_to $HOME/.local/bin"
alias setup-macos="_go_to $HOME/.local/share/macOS-setup"
alias tmux-cfg="_go_to $XDG_CONFIG_HOME/tmux"
#- COMMAND SHORTCUTS -----------------------------
alias g="git" # GIT ALIASES ARE IN ~/.GITCONFIG.
alias r-shfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias rr="_go_to $(git rev-parse --show-toplevel)"
alias rm-ds_store="find $PWD -type f -name *.DS_Store -print -delete"
#- MISC. -----------------------------------------
alias scratchpad="$EDITOR $(mktemp -t scratch.XXX.md)"
alias generate-passwd="openssl rand -base64 24"
alias get-my-ip="curl ifconfig.co"
alias reload-sh="exec $SHELL"
#- PYTHON ----------------------------------------
alias start-http_server="python2 -m SimpleHTTPServer"
alias venv-activate="source ./.venv/bin/activate"
alias venv-create="python3 -m venv ./.venv"
alias pip-safe="pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org"
alias pip-requirements="pip-safe -r requirements.txt"
#- WEBSERVER DEBUGGING ---------------------------
alias get-open-ports='netstat -tulanp' # list open ports
alias get-site-headers='curl -I'       # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate
alias ping='ping -c 10'                # ping 10 times
#- DISPLAYS --------------------------------------
alias fix-dual-displays="display-fixer \
				'id:A49C2C45-F295-3FAE-B81F-247EB03CA52B res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0'
				'id:D614B2F2-B098-8A35-508D-7CEA39295FC9 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(2560,0) degree:0'"
#- DOCKER ----------------------------------------
if command -v docker &> /dev/null; then
    alias dcup="docker compose up --build"
    alias dcdown="docker compose down"
    alias dcstop="docker compose stop"
    alias dclogs="docker compose logs --follow"
    alias dckill="docker container kill --signal=KILL $(docker container ls --all --quiet)"
    alias dclean="docker system prune --all --force --volumes"
fi
#- FILE CREATION ---------------------------------
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mksh='{ F_NAME="$(cat -).sh"; touch "$F_NAME" && chmod +x "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mkpy='{ F_NAME="$(cat -).py"; touch "$F_NAME" && chmod +x "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
