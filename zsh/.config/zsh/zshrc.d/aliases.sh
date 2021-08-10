#!/usr/bin/env zsh
#
# Collection of aliases to reduce key presses for common tasks
_cmd_exists() {
    if command -v "${1}" &> /dev/null; then
        return
    fi
    echo "--- ${1} is unavailable"
    false
}
#- SYSTEM SPECIFIC -------------------------------
if [[ $OSTYPE =~ "darwin" ]]; then
    _copy_cmd='pbcopy -pboard general'
    alias readlink="greadlink"
    alias copy="$_copy_cmd <"
fi
alias get-public-ssh-key= \
    '$_copy_cmd < "$HOME"/.ssh/id_rsa.pub \
	&& echo "--- Copied SSH key to clipboard"'
#- NAVIGATION ------------------------------------
if _cmd_exists exa; then
    alias ls='exa \
                --colour-scale \
                --group-directories-first \
                --header \
                --long \
                --no-permissions \
                --octal-permissions \
                --time-style iso'
elif _cmd_exists gls; then
    alias ls='gls'
fi
alias l='ls'
alias la='ls -all'
alias lt='ls --tree'
alias .....='_go_to ../../../..'
alias ....='_go_to ../../..'
alias ...='_go_to ../..'
alias ..='_go_to ..'
#- FILE LOCATIONS --------------------------------
alias cpv="rsync -ah --info=progress2"
alias mkdir="mkdir -pv"
alias tailf="less +F -R"
alias rmr="rm -rf"
alias b="cd -"
if _cmd_exists bat; then
    alias bat='bat --theme=ansi'
    alias cat='bat --pager=never'
    alias less='bat --pager=less'
fi

#- EDITOR ----------------------------------------
if _cmd_exists nvim; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi
alias v.='$EDITOR .'
alias v='$EDITOR'
alias vi='$EDITOR'
alias vim='$EDITOR'
#- CONFIG SHORTCUTS ------------------------------
_edit() {
    $EDITOR $1
}
# alias e-hspoon='_edit $HOME/.hammerspoon/init.lua'
# alias e-profile='_edit $HOME/.profile'
alias e-aliases='_edit $ZDOTDIR/zshrc.d/aliases.sh'
alias e-bashrc='_edit $HOME/.bashrc'
alias e-cli-commands='_edit $ZDOTDIR/zshrc.d/cli-commands.sh'
alias e-git='_edit $XDG_CONFIG_HOME/git/config'
alias e-gitignore='_edit $XDG_CONFIG_HOME/git/ignore'
alias e-kitty='_edit $XDG_CONFIG_HOME/kitty/kitty.conf'
alias e-lsd='_edit $XDG_CONFIG_HOME/lsd/config.yaml'
alias e-makefile='_edit $XDG_CONFIG_HOME/dotfiles/Makefile'
alias e-mc-utils='_edit $ZDOTDIR/zshrc.d/mc-utils.sh'
alias e-nvim='_edit $XDG_CONFIG_HOME/nvim/init.lua'
alias c-nvim='rm -rf $HOME/.config/nvim/plugin $HOME/.local/share/nvim'
alias e-skhdrc='_edit $XDG_CONFIG_HOME/skhd/skhdrc'
alias e-tmux='_edit $XDG_CONFIG_HOME/tmux/tmux.conf'
alias e-yabairc='_edit $XDG_CONFIG_HOME/yabai/yabairc'
alias e-zshenv='_edit $HOME/.zshenv'
alias e-zshrc='_edit $ZDOTDIR/.zshrc'
#- DIRECTORY SHORTCUTS ---------------------------
_go_to() {
    cd "${1}" && ls
}

CODE_DIR="${HOME:-~}"/code
if [[ ! -e $CODE_DIR ]] || [[ ! -d $CODE_DIR ]]; then
    mkdir "$CODE_DIR"
fi
# alias nvim-plugins='_go_to $XDG_CONFIG_HOME/nvim/lua/configs'
alias .f='_go_to $XDG_CONFIG_HOME/dotfiles'
alias c='_go_to $CODE_DIR'
alias cfg='_go_to $XDG_CONFIG_HOME'
alias df='_go_to $XDG_CONFIG_HOME/dotfiles'
alias downloads='_go_to $HOME/Downloads'
alias git-cfg='_go_to $XDG_CONFIG_HOME/git/config'
alias h='_go_to $HOME'
alias hammerspoon-cfg='_go_to $HOME/.hammerspoon'
alias l-bin='_go_to $HOME/.local/bin'
alias l-installers='_go_to $HOME/.local/bin/installers'
alias nvim-cfg='_go_to $XDG_CONFIG_HOME/nvim'
alias tmux-cfg='_go_to $XDG_CONFIG_HOME/tmux'
alias zsh-cfg='_go_to $ZDOTDIR'
#- GIT -------------------------------------------
alias g="git" # GIT ALIASES ARE IN ~/.GITCONFIG.
alias git-submodule-update='git submodule update --merge --remote'
alias git-submodules='_go_to $HOME/.local/share'
#- COMMAND SHORTCUTS -----------------------------
alias r-shfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias rr='_go_to $(git rev-parse --show-toplevel)'
alias rm-ds-store='find "$PWD" -type f -name "*.DS[_-]Store" -print -delete'
#- MISC. -----------------------------------------
alias scratchpad='$EDITOR $(mktemp -t scratch.XXX.md)'
alias generate-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'

if _cmd_exists kitty; then
    alias ssh='kitty +kitten ssh'
fi
#- RELOAD COMMANDS -------------------------------
_restart_brew_service() {
    if _cmd_exists "${1}"; then
        echo "--- Reloading ${1}" \
            && (
                brew services restart "${1}"
                echo "--- Restarted ${1}"
            ) \
            || echo "--- Failed to restart ${1}"
    else
        echo "--- ERROR: ${1} not installed"
    fi
}
alias .bash='exec $(which bash)'
alias .sh='exec $SHELL'
alias .zsh='exec $(which zsh)'
alias r-skhd='_restart_brew_service skhd'
alias r-wm='reload-yabai && reload-skhd'
alias r-yabai='_restart_brew_service yabai'
#- PYTHON ----------------------------------------
alias start-http_server='python2 -m SimpleHTTPServer'
alias pip-requirements='pip-safe -r requirements.txt || echo "--- No requirements.txt found"'
alias pip-safe='python3 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org'
alias venv-activate='source ./.venv/bin/activate'
alias venv-create='python3 -m venv ./.venv'
alias venv-setup='venv-create && venv-activate && pip-requirements'
#- NETWORK INFO ----------------------------------
alias get-open-ports='netstat -tulanp' # list open ports
alias get-site-headers='curl -I'       # get web server headers
alias headerc='curl -I --compress'     # does remote server supports gzip / mod_deflate
alias ping='ping -c 10'                # ping 10 times
#- DISPLAYS --------------------------------------
alias fix-dual-displays='display-fixer \
				id:A49C2C45-F295-3FAE-B81F-247EB03CA52B res:2560x1440 hz:75 color_depth:8 scaling:off origin:(0,0) degree:0 \
				id:D614B2F2-B098-8A35-508D-7CEA39295FC9 res:2560x1440 hz:75 color_depth:8 scaling:off origin:(2560,0) degree:0'
#- DOCKER ----------------------------------------
if _cmd_exists docker; then
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
fi
#- FILE CREATION ---------------------------------
_mkfile() {
    F_NAME="${3}.${1}"
    echo "/usr/bin/env ${2}" > "${F_NAME}"
    chmod +x "${F_NAME}"
    echo "--- Created ${F_NAME}"
}
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; echo "--- Created: $F_NAME"; }<<<'
alias mksh='_mkfile sh "bash"'
alias mkpy='_mkfile py "python3"'
#- FILE FORMATTING -------------------------------
_fmt() {
    echo "--- Formatting ${1} files via ${2}"
    find . -name "*.${1}" -print -exec bash -c "${2} {}" \;
}
alias fmt-lua='_fmt lua "stylua -i"'
alias fmt-md="_fmt md mdformat"
alias fmt-py="_fmt py black"
alias fmt-sh='_fmt sh "shfmt -bn -ci -i 4 -ln=bash -s -sr -w"'
#- SYS -------------------------------------------
_sys_update() {
    "$1" update
    "$1" upgrade
}
alias apt-sysupdate="_sys_update 'sudo apt --yes'"
alias brew-sysupdate="_sys_update brew"
alias yum-sysupdate="_sys_update 'sudo yum -y'"
