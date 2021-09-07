#!/usr/bin/env zsh
#
# Collection of aliases for common tasks

#- SYSTEM SPECIFIC -------------------------------
if [[ $OSTYPE =~ darwin* ]]; then
    _copy_cmd='pbcopy -pboard general'
    alias readlink="greadlink"
    alias copy="$_copy_cmd <"
fi
# alias get-public-ssh-key='$_copy_cmd < "$HOME"/.ssh/id_rsa.pub && _info "Copied SSH key to clipboard"'
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
else
    alias l='ls --color=auto -1tA'
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lthN --color=auto --group-directories-first'
    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
fi
alias .....='_go_to ../../../..'
alias ....='_go_to ../../..'
alias ...='_go_to ../..'
alias ..='_go_to ..'
#- FILE LOCATIONS --------------------------------
alias b="cd -"
alias cpv="rsync -ah --info=progress2"
alias mkdir="mkdir -pv"
alias rmr="rm -rf"
alias tailf="less +F -R"
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
alias v='$EDITOR'
alias v.='$EDITOR .'
alias vi='$EDITOR'
alias vim='$EDITOR'
#- CONFIG SHORTCUTS ------------------------------
_edit() {
    $EDITOR $1
}
alias e-aliases='_edit $ZDOTDIR/zshrc.d/aliases.sh'
alias e-bashrc='_edit $HOME/.bashrc'
alias e-fzf='_edit $ZDOTDIR/zshrc.d/fzf.sh'
alias e-cli-commands='_edit $ZDOTDIR/zshrc.d/cli-commands.sh'
alias e-git='_edit $XDG_CONFIG_HOME/git/config'
alias e-gitignore='_edit $XDG_CONFIG_HOME/git/ignore'
alias e-kitty='_edit $XDG_CONFIG_HOME/kitty/kitty.conf'
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
    if [ -e $1 ]; then
        cd $1 && ls
    else
        _error "$1 doesn't exist"
    fi
}

CODE_DIR="${HOME:-~}"/code
if [[ ! -e $CODE_DIR ]] || [[ ! -d $CODE_DIR ]]; then
    mkdir "$CODE_DIR"
fi
alias c='_go_to $CODE_DIR'
alias cfg='_go_to $XDG_CONFIG_HOME'
alias df='_go_to $XDG_CONFIG_HOME/dotfiles'
alias dl='_go_to $HOME/Downloads'
alias g-cfg='_go_to $XDG_CONFIG_HOME/git/config'
alias h='_go_to $HOME'
alias l-bin='_go_to $HOME/.local/bin'
alias l-installers='_go_to $HOME/.local/bin/installers'
alias l-share='_go_to $HOME/.local/share/'
alias v-cfg='_go_to $XDG_CONFIG_HOME/nvim'
alias tmux-cfg='_go_to $XDG_CONFIG_HOME/tmux'
alias zsh-cfg='_go_to $ZDOTDIR'
#- GIT -------------------------------------------
alias g="git" # GIT ALIASES ARE IN ~/.GITCONFIG.
alias git-submodule-update='git submodule update --merge --remote'
#- COMMAND SHORTCUTS -----------------------------
alias r-shfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias rr='_go_to $(git rev-parse --show-toplevel)'
alias rm-ds-store='find "$PWD" -type f -name "*.DS[_-]Store" -print -delete'
#- MISC. -----------------------------------------
alias scratchpad='$EDITOR $(mktemp -t scratch.XXX.md)'
alias generate-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
#- RELOAD COMMANDS -------------------------------
_restart_brew_service() {
    if _cmd_exists "${1}"; then
        _info "Reloading ${1}" \
            && (
                brew services restart "${1}"
                _info "Restarted ${1}"
            ) \
            || _error "Failed to restart ${1}"
    else
        echo "--- ERROR: ${1} not installed"
    fi
}
alias .sh='source $HOME/.zshenv $ZDOTDIR/.zshrc'
alias r-skhd='_restart_brew_service skhd'
alias r-yabai='_restart_brew_service yabai'
alias r-wm='r-yabai && r-skhd'
#- PYTHON ----------------------------------------
if _cmd_exists python3; then
    alias http-serve='python3 -m http.server'
else
    alias http-serve='python -m SimpleHTTPServer'
fi
alias pip-requirements='pip-safe -r requirements.txt || _error "no requirements.txt found"'
alias pip-safe='python3 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org'
alias venv-activate='source ./.venv/bin/activate'
alias venv-create='python3 -m venv ./.venv'
alias venv-setup='venv-create && venv-activate && pip-requirements'
#- NETWORK INFO ----------------------------------
ip-internal() {
    echo "Wireless :: IP => $(ip -4 -o a show wlo1 | awk '{ print $4 }')"
}
ip-external() {
    echo "External :: IP => $(curl --silent https://ifconfig.me)"
}
ip-info() {
    ip-internal && ip-external
}
alias get-open-ports='netstat -tulanp' # list open ports
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
    echo "#!/usr/bin/env ${2}" > "${F_NAME}"
    chmod +x "${F_NAME}"
    echo "--- Created ${F_NAME}"
}
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mksh='_mkfile sh "bash"'
alias mkpy='_mkfile py "python3"'
#- FILE FORMATTING -------------------------------
_fmt() {
    if _cmd exists $2; then
        _info "formatting ${1} files via ${2}"
        find . -name "*.${1}" -print -exec bash -c "${2} {}" \;
    else
        _error "$2 not installed"
    fi
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
alias brew-clean="brew cleanup --prune=all"
alias brew-reset="brew update-reset"
alias brew-sysupdate="brew upgrade --greedy --force"
alias yum-sysupdate="_sys_update 'sudo yum -y'"
#- MEME -------------------------------------------
alias shrug='¯\_(ツ)_/¯' # only alias that matters
#- RANDOM -----------------------------------------
alias cp-dotfiles='rsync -azP ~/.config/dotfiles/ devcloud:~/dotfiles'
alias cp-dotfiles-2='rsync -azP --info=progress2 ~/.config/dotfiles devcloud:~/dotfiles'
