# #!/usr/bin/env zsh
if builtin echo "$-" | grep i > /dev/null; then export IS_TTY='1'; fi
_error() { [[ -v $IS_TTY ]] && print -P "%F{red}[ERROR]%f %F{white}${1}%f" >&2; }
_info() { [[ -v $IS_TTY ]] && print -P "%F{white}[INFO]%f %F{cyan}${1}%f"; }
# +────────────────+
# │ UTIL FUNCTIONS │
# +────────────────+
_clone_if_absent() { [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"; }
_edit() { $EDITOR $1; }
_export() { [[ -d $1 ]] && export PATH="${1}${PATH+:$PATH}"; return $?; }
_mkfile() { builtin echo "#!/usr/bin/env ${2}" > "$3.$1" && chmod +x "$3.$1"; rehash; nvim "$3.$1"; }
_sys_update() { "$1" update && "$1" upgrade; }
has() { command -v "$1" 1> /dev/null 2>&1; }
_goto() { [[ -e $1 ]] && { cd "$1" && has exa && exa --all --long || ls -lGo } || _error "${1} not found"; }
# +────────────────+
# │ CODE DIRECTORY │
# +────────────────+
CODE_DIR="${HOME:-~}/code"
! [[ -d $CODE_DIR ]] && command mkdir -p -- "${CODE_DIR}"
# +─────────────────+
# │ SYSTEM SPECIFIC │
# +─────────────────+
if [[ $OSTYPE =~ darwin* ]]; then
  _copy_cmd='pbcopy'
  alias readlink="greadlink"
  alias copy="$_copy_cmd <"
fi
# +───────+
# │ FILES │
# +───────+
alias bashly_edge='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly:edge'
alias b="cd -"
alias rmr="rm -rf --"
alias tailf="less +F -R"
has python3 && alias python='python3'
# +──────────────────+
# │ CONFIG SHORTCUTS │
# +──────────────────+
cfg_alias() { builtin alias ${1}="_edit ${XDG_CONFIG_HOME}/${2}"; }
cfg_alias 'ealiases' 'zsh/aliases.zsh'
cfg_alias 'gignore' 'git/ignore'
cfg_alias 'gcfg' 'git/config'
cfg_alias 'kittyrc' 'kitty/kitty.conf'
cfg_alias 'nvplg' "nvim/lua/plugins.lua"
cfg_alias 'skhdrc' 'skhd/skhdrc'
cfg_alias 'tmuxrc' 'tmux/tmux.conf'
cfg_alias 'zic' 'zsh/zinit.zsh'
cfg_alias 'zsc' 'zsh/.zshrc'
alias zinstall='_edit $ZINIT[BIN_DIR]/zinit-install.zsh'
# +────────────────+
# │ HOME SHORTCUTS │
# +────────────────+
home_alias() { builtin alias ${1}="_edit ${HOME}/${2}"; }
home_alias 'hscfg' '.hammerspoon/init.lua'
home_alias 'sshrc' '.ssh/config'
home_alias 'zec' '.zshenv'
home_alias 'zpc' '.zprofile'
# +─────────────────+
# │ RELOAD COMMANDS │
# +─────────────────+
alias nvcln='command rm -rf $HOME/.{local/share/nvim,config/nvim/plugin/packer_compiled.lua}'
alias zcln='command rm -rf ${HOME}/.{local/share/{zinit,zsh},cache,config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}'
alias zreset='builtin cd ${HOME} && unset _comp{_{assocs,dumpfile,options,setup},{auto,}s} && ( zcln && zrld ) && cd -'
alias zicln='zi delete --all --yes; ( exec zsh -il );'
alias zrld='builtin exec zsh -l'
# +────────────+
# │ NAVIGATION │
# +────────────+
cd_alias() { builtin alias ${1}="_goto ${2}"; }
cd_alias '..' '..'
cd_alias '...' '../..'
cd_alias '....' '../../..'
cd_alias '.....' '../../../..'
cd_alias 'bin' '$HOME/.local/bin'
cd_alias 'c' '$CODE_DIR'
cd_alias 'xch' '$XDG_CONFIG_HOME'
cd_alias 'xdh' '$XDG_DATA_HOME'
cd_alias 'df' '$XDG_CONFIG_HOME/dotfiles'
cd_alias 'dl' '$HOME/Downloads'
cd_alias 'h' '$HOME'
cd_alias 'hs' '$HOME/.hammerspoon'
cd_alias 'rr' '$(git rev-parse --show-toplevel)'
cd_alias 'vd' '$XDG_CONFIG_HOME/nvim'
cd_alias 'zd' '$ZDOTDIR'
cd_alias 'zid' '$ZINIT[HOME_DIR]'
cd_alias 'zigd' '$ZINIT[BIN_DIR]'
# +─────+
# │ GIT │
# +─────+
alias g-submodule-update='git submodule update --merge --remote'
alias g="git" # GIT ALIASES DEFINED IN $HOME/.config/git/config
# +───────────────────+
# │ COMMAND SHORTCUTS │
# +───────────────────+
alias -- +x="chmod +x"
alias rm-ds-store='find "$PWD" -type f -name "*.DS[_-]Store" -print -delete'
alias rshfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias zc='zinit compile'
alias zp='zinit times'
alias zt='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
alias ziclnplg="$(command rm -rf $ZINIT[PLUGINS_DIR])"
# +───────+
# │ MISC. │
# +───────+
alias pretty-env='print -C 1 $(env | sort | xargs)'
alias gen-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias tmp-md='$EDITOR $(mktemp -t scratch.XXX.md)'
alias ps-grep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias -- +x='chmod +x'
path-info() { printf "%s\n" $path | sort; printf "\n--- \$PATH contains %s items" $(print -l $path | sort  | wc -l); }
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
alias mkcmd='{ F_NAME="$(cat -)"; touch "$F_NAME"; chmod +x $F_NAME; rehash; nvim $F_NAME }<<<'
mkcd() { command mkdir -p -- "$1" && cd -P -- "$1"; }
# +─────────────────+
# │ FILE FORMATTING │
# +─────────────────+
alias fmtbtysh='beautysh --indent-size=2 --force-function-style=paronly'
alias fmtlua='stylua -i'
alias fmtmd='mdformat --number --wrap 100'
alias fmtpy='python3 -m black'
alias fmtsh='shfmt -bn -ci -i 2 -ln=bash -s -sr -w'
# +─────+
# │ SYS │
# +─────+
alias apt-sys-update="_sys_update 'sudo apt --yes'"
alias brew-clean="brew cleanup --prune=all"
alias brew-reset="brew update-reset"
alias brew-sys-update="brew upgrade --greedy --force"
alias wsys='echo OSTYPE=${OSTYPE} MACHTYPE=${MACHTYPE} CPUTYPE=${CPUTYPE} hardware=$(uname -m) processor=$(uname -p)'
alias cldf='command mkdir -p -- $HOME/.config; git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles; cd dotfiles'
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
disappointed() { command echo -n " ಠ_ಠ " | tee /dev/tty | $_copy_cmd; }
flip() { command echo -n "（╯°□°）╯ ┻━┻" | tee /dev/tty | $_copy_cmd; }
shrug() { command echo -n "¯\_(ツ)_/¯" | tee /dev/tty | $_copy_cmd; }

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
