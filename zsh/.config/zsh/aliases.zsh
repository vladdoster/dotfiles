#!/usr/bin/env zsh
if echo "$-" | grep i > /dev/null; then
    export IS_TTY="${IS_TTY:=false}"
fi
LOG_LEVEL="error"
_log() {
    if $IS_TTY; then
        case $LOG_LEVEL in
            error*) echo "--- ERROR: $1" ;;
            info*) echo "--- INFO: $1" ;;
        esac
    fi
}
_error() { _log $1; }
_info() { _log $1; }
_clone_if_missing() {
    if [[ ! -d $1 ]]; then
        git clone "$1" "$2/$(basename "$1" .git)"
    else
        return 0
    fi
}
has() {
    command -v "$1" 1> /dev/null 2>&1
}
_edit() {
    ${EDITOR:-nvim} "$1"
}
_export() {
    if [[ -d $1 ]]; then
        export PATH="${1}${PATH+:$PATH}"
        return $?
    fi
}
_fmt() {
    if has "$2"; then
        _info "formatting ${1} files via ${2}"
        find . -name "*.${1}" -print -exec bash -c "${2} {}" \;
    else
        _error "$2 not installed"
    fi
}
_goto() {
    if [ -e "$1" ]; then
        cd "$1" && exa --all --long || gls || ls -Go
    else
        _error "$1 doesn't exist"
    fi
}
_mkfile() {
    F_NAME="${3}.${1}"
    echo "#!/usr/bin/env ${2}" > "$F_NAME"
    chmod +x "$F_NAME"
    _info " Created $F_NAME"
}
_sys_update() {
    "$1" update && "$1" upgrade
}
_archive() {
    local format="$1"
    local output="$2"
    local input=("${@:3}")
    case "$format" in
        tar)
            tar -czvf "${output}.tar.gz" "${input[@]}"
            ;;
        7z)
            7za a "${output}.7z" "${input[@]}"
            ;;
    esac
}
#= SYSTEM SPECIFIC ===============================
if [[ $OSTYPE =~ darwin* ]]; then
    _copy_cmd='pbcopy -pboard general'
    alias readlink="greadlink"
    alias copy="$_copy_cmd <"
fi
#= NAVIGATION ====================================
alias .....='_goto ../../../..'
alias ....='_goto ../../..'
alias ...='_goto ../..'
alias ..='_goto ..'
#= FILE LOCATIONS ================================
alias b="cd -"
alias cpv="rsync -ah --info=progress2"
alias d='dirs -v'
alias m='make'
alias mkdir="mkdir -pv"
alias rmr="rm -rf"
alias tailf="less +F -R"
export EDITOR='nvim'

if has nvim; then
    export EDITOR='nvim'
#  elif has vim; then
    #  export EDITOR='vim'
#  elif has vi; then
    #  export EDITOR='vi'
fi
#= CONFIG SHORTCUTS ==============================
alias ealiases="_edit $ZDOTDIR/aliases.zsh"
alias emcutils="_edit $ZDOTDIR/lib/azure.sh"
alias gitignore="_edit $XDG_CONFIG_HOME/git/ignore"
alias gitrc="_edit $XDG_CONFIG_HOME/git/config"
alias hs="_goto $HOME/.hammerspoon/"
alias kittyrc="_edit $XDG_CONFIG_HOME/kitty/kitty.conf"
alias nvcln="rm -fr $HOME/.{local/share/nvim,config/nvim/lua/packer_compiled}"
alias nvfmt="_edit $XDG_CONFIG_HOME/nvim/lua/plugins/format.lua"
alias nvopt="_edit $XDG_CONFIG_HOME/nvim/lua/core/options.lua"
alias nvplg="_edit $XDG_CONFIG_HOME/nvim/lua/plugins/init.lua"
alias sshrc="_edit $HOME/.ssh/config"
alias tmuxrc="_edit $XDG_CONFIG_HOME/tmux/tmux.conf"
alias zcln="rm -frv ${HOME}/{.local/share/{zinit,zsh},.cache,.config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}"
alias zenv="_edit $HOME/.zshenv"
alias zrc="_edit $ZDOTDIR/zinit.zsh"
alias zreset="zcln && zrld"
alias zrld="exec zsh"
#= DIRECTORY SHORTCUTS ===========================
CODE_DIR="${HOME:-~}"/code
mkdir -p $CODE_DIR || true
alias bin="_goto $HOME/.local/bin"
alias c="_goto $CODE_DIR"
alias cfg="_goto $XDG_CONFIG_HOME"
alias df="_goto $XDG_CONFIG_HOME/dotfiles"
alias dl="_goto $HOME/Downloads"
alias h="_goto $HOME"
alias installers="_goto $HOME/.local/bin/installers"
alias rr='_goto $(git rev-parse --show-toplevel)'
alias share="_goto $HOME/.local/share"
alias vd="_goto $XDG_CONFIG_HOME/nvim"
alias zd="_goto $ZDOTDIR"
alias zl="_goto $ZDOTDIR/lib"
#= RELOAD COMMANDS ===============================
alias .sh='source $ZDOTDIR/.zshrc'
#= GIT ===========================================
alias g-submodule-update='git submodule update --merge --remote'
alias g="git" # GIT ALIASES DEFINED IN $HOME/.config/git/config
#= COMMAND SHORTCUTS =============================
alias rm-ds-store='find "$PWD" -type f -name "*.DS[_-]Store" -print -delete'
alias rshfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias zc='zinit compile'
alias zp='zinit times'
alias zt='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
#= MISC. =========================================
alias genpasswd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias scratch='$EDITOR $(mktemp -t scratch.XXX.md)'
alias ps-grep="ps aux | grep -v grep | grep -i -e VSZ -e"
#= PYTHON ========================================
alias http-serve='python3 -m http.server'
alias pip-requirements='pip3 install -r requirements.txt || _error "no requirements.txt found"'
alias spip='--trusted-host pypi.org --trusted-host files.pythonhosted.org'
alias venv-activate='source ./.venv/bin/activate'
alias venv-create='python3 -m venv ./.venv'
alias venv-setup='venv-create && venv-activate && pip-requirements'
#= NETWORK INFO ==================================
alias get-open-ports='sudo lsof -i -n -P | grep TCP'
alias ping='ping -c 10'
#= FILE CREATION =================================
alias mk-md='{ F_NAME="$(cat -).md"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mk-py='_mkfile py "python3"'
alias mk-sh='_mkfile sh "bash"'
alias mk-txt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
#= FILE FORMATTING ===============================
alias fmt-lua='_fmt lua "stylua -i"'
alias fmt-md="_fmt md mdformat"
alias fmt-py="_fmt py python3 -m black"
alias fmt-sh='_fmt sh "shfmt -bn -ci -i 4 -ln=bash -s -sr -w"'
#= SYS ===========================================
alias apt-sys-update="_sys_update 'sudo apt --yes'"
alias brew-clean="brew cleanup --prune=all"
alias brew-reset="brew update-reset"
alias brew-sys-update="brew upgrade --greedy --force"
alias yum-sys-update="_sys_update 'sudo yum -y'"
#= REMOTE =========================================
cp-to-devcloud(){ rsync -a -z -P $(readlink "$1") devcloud:~/$(basename "$1"); }
alias cp-dotfiles="rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles"
alias cp-nvim="rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim"
alias cp-devcloud="cp-to-devcloud"
