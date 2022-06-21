# #!/usr/bin/env zsh
if echo "$-" | grep i >/dev/null; then export IS_TTY="${IS_TTY:=false}"; fi
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
# +────────────────+
# │ UTIL FUNCTIONS │
# +────────────────+
_clone_if_absent() { [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"; }
_edit() { ${EDITOR:-nvim} "$1"; }
_export() { [[ -d $1 ]] && export PATH="${1}${PATH+:$PATH}"; return $?; }
_goto() { [[ -e "$1" ]] && cd "$1" && $(which exa) --all --long || ls -lGo; }
_mkfile() { echo "#!/usr/bin/env ${2}" >"${3}.${1}" && chmod +x "${3}.${1}"; }
_sys_update() { "$1" update && "$1" upgrade; }
has() { command -v "$1" 1>/dev/null 2>&1; }
# +────────────────+
# │ CODE DIRECTORY │
# +────────────────+
CODE_DIR="${HOME:-~}/code"
! [[ -d "$CODE_DIR" ]] && mkdir -p "${CODE_DIR}"
# +─────────────────+
# │ SYSTEM SPECIFIC │
# +─────────────────+
if [[ $OSTYPE =~ darwin* ]]; then
  _copy_cmd='pbcopy -pboard general'
  alias readlink="greadlink"
  alias copy="$_copy_cmd <"
fi
# +───────+
# │ FILES │
# +───────+
alias b="cd -"
alias cpv="rsync -ah --info=progress2"
alias d='dirs -v --'
alias m='make'
alias mkdir="mkdir -pv --"
alias rld="source"
alias rmr="rm -rf --"
alias tailf="less +F -R"
if has nvim; then
  export EDITOR='nvim'
elif has vim; then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi
alias v=$EDITOR
if has python3; then
  alias python='python3'
fi
# +──────────────────+
# │ CONFIG SHORTCUTS │
# +──────────────────+
cfg_alias() { alias ${1}="_edit ${XDG_CONFIG_HOME}/${2}"; }
cfg_alias 'ealiases' 'zsh/aliases.zsh'
cfg_alias 'gignore'  'git/ignore'
cfg_alias 'gcfg'     'git/config'
cfg_alias 'kittyrc'  'kitty/kitty.conf'
cfg_alias 'nvplg'    "nvim/lua/plugins.lua"
cfg_alias 'skhdrc'   'skhd/skhdrc'
cfg_alias 'tmuxrc'   'tmux/tmux.conf'
cfg_alias 'zic'      'zsh/zinit.zsh'
cfg_alias 'zsc'      'zsh/.zshrc'
# +────────────────+
# │ HOME SHORTCUTS │
# +────────────────+
home_alias() { alias ${1}="_edit ${HOME}/${2}"; }
home_alias 'hscfg' '.hammerspoon/init.lua'
home_alias 'sshrc' '.ssh/config'
home_alias 'zec'   '.zshenv'
# +─────────────────+
# │ RELOAD COMMANDS │
# +─────────────────+
alias nvcln="rm -frv $HOME/.{local/share/nvim,config/nvim/plugin}"
alias zcln="rm -fr ${HOME}/.{local/share/{zinit,zsh},cache,config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}"
alias zreset="pushd ${HOME} && zcln && zrld"
alias zrld="exec zsh"
# +────────────+
# │ NAVIGATION │
# +────────────+
cd_alias() { alias ${1}="_goto ${2}"; }
cd_alias '..' '..'
cd_alias '...' '../..'
cd_alias '....' '../../..'
cd_alias '.....' '../../../..'
cd_alias 'bin' $HOME/.local/bin
cd_alias 'c' $CODE_DIR
cd_alias 'cfg' $XDG_CONFIG_HOME
cd_alias 'df' $XDG_CONFIG_HOME/dotfiles
cd_alias 'dl' $HOME/Downloads
cd_alias 'h' $HOME
cd_alias 'hs' $HOME/.hammerspoon
cd_alias 'rr' '$(git rev-parse --show-toplevel)'
cd_alias 'vd' $XDG_CONFIG_HOME/nvim
cd_alias 'zd' '$ZDOTDIR'
cd_alias 'zid' '$ZINIT[HOME_DIR]'
cd_alias 'zigd' '$ZINIT[BIN_DIR]'
alias zinstall='_edit $ZINIT[BIN_DIR]/zinit-install.zsh'
# +─────+
# │ GIT │
# +─────+
alias g-submodule-update='git submodule update --merge --remote'
alias g="git" # GIT ALIASES DEFINED IN $HOME/.config/git/config
# +───────────────────+
# │ COMMAND SHORTCUTS │
# +───────────────────+
alias rm-ds-store='find "$PWD" -type f -name "*.DS[_-]Store" -print -delete'
alias rshfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias zc='zinit compile'
alias zp='zinit times'
alias zt='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
alias zclnplg="$(rm -rf $ZINIT[PLUGINS_DIR])"
# +───────+
# │ MISC. │
# +───────+
alias gen-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias tmp-md='$EDITOR $(mktemp -t scratch.XXX.md)'
alias ps-grep="ps aux | grep -v grep | grep -i -e VSZ -e"
# +────────+
# │ PYTHON │
# +────────+
alias http-serve='python3 -m http.server'
alias p='python3'
alias pip-requirements='pip3 install -r requirements.txt || _error "no requirements.txt found"'
alias ppip='python3 -m pip'
alias venv-activate='source ./.venv/bin/activate'
alias venv-create='python3 -m venv ./.venv'
alias venv-setup='venv-create && venv-activate && pip-requirements'
# +──────────────+
# │ NETWORK INFO │
# +──────────────+
alias get-open-ports='sudo lsof -i -n -P | grep TCP'
alias ping='ping -c 10'
# +───────────────+
# │ FILE CREATION │
# +───────────────+
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkpy='_mkfile py "python3"'
alias mksh='_mkfile sh "bash"'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkzsh='_mkfile zsh "zsh"'
mkcd() { mkdir -p -- "$1" && cd -P -- "$1" ;}
# +─────────────────+
# │ FILE FORMATTING │
# +─────────────────+
alias fmtlua='stylua -i'
alias fmtmd="mdformat"
alias fmtpy="python3 -m black"
alias fmtsh="shfmt -bn -ci -i 4 -ln=bash -s -sr -w"
# +─────+
# │ SYS │
# +─────+
alias apt-sys-update="_sys_update 'sudo apt --yes'"
alias brew-clean="brew cleanup --prune=all"
alias brew-reset="brew update-reset"
alias brew-sys-update="brew upgrade --greedy --force"
alias what-system='echo OSTYPE=${OSTYPE} MACHTYPE=${MACHTYPE} CPUTYPE=${CPUTYPE} hardware=$(uname -m) processor=$(uname -p)'
alias yum-sys-update="_sys_update 'sudo yum -y'"
# +────────+
# │ REMOTE │
# +────────+
alias cp-dotfiles="rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles"
alias cp-hammerspoon="rsync -azP $HOME/.hammerspoon/ devcloud:~/hammerspoon"
alias cp-nvim="rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim"
# +────────+
# │ EMOJIS │
# +────────+
disappointed() { echo -n " ಠ_ಠ " | tee /dev/tty | xclip -selection clipboard; }
flip() { echo -n "（╯°□°）╯ ┻━┻" | tee /dev/tty | xclip -selection clipboard; }
shrug() { echo -n "¯\_(ツ)_/¯" | tee /dev/tty | xclip -selection clipboard; }
