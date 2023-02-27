# #!/usr/bin/env zsh
if builtin echo "$-" | grep i > /dev/null; then export IS_TTY='1'; fi
_error() { [[ -v $IS_TTY ]] && print -P "%F{red}[ERROR]%f %F{white}${1}%f" >&2; }
_info() { [[ -v $IS_TTY ]] && print -P "%F{green}==>%f %F{white}${1}%f"; }
# +────────────────+
# │ UTIL FUNCTIONS │
# +────────────────+
_clone_if_absent() { [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"; }
_edit() { $EDITOR $1; }
_mkfile() { builtin echo "#!/usr/bin/env ${2}" > "$3.$1" && chmod +x "$3.$1"; rehash; $EDITOR "$3.$1"; }
_sys_update() { "$1" update && "$1" upgrade; }
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
function rmp() { _info "$(command rm -vf $(which $1))"; }
alias tailf="less +F -R"
# +──────────────────+
# │ CONFIG SHORTCUTS │
# +──────────────────+
typeset -A pairs=(
  ealiases 'zsh/aliases.zsh'  gignore 'git/ignore'           gcfg   'git/config'  \
  kittyrc  'kitty/kitty.conf' nvplg   "nvim/lua/plugins.lua" skhdrc 'skhd/skhdrc' \
  tmuxrc   'tmux/tmux.conf'   zic     'zsh/zinit.zsh'        zrc    'zsh/.zshrc'
  zsc      'zsh/.zshrc'
)
for k v in ${(kv)pairs[@]}; do
  builtin alias $k="_edit $XDG_CONFIG_HOME/$v" || true
done
alias zinstall='_edit $ZINIT[BIN_DIR]/zinit-install.zsh'
# +────────────────+
# │ HOME SHORTCUTS │
# +────────────────+
for k v in hscfg '.hammerspoon/init.lua' sshrc '.ssh/config' zec '.zshenv' zpc '.zprofile'; do
  builtin alias $k="_edit $HOME/$v" || true
done
# +─────────────────+
# │ RELOAD COMMANDS │
# +─────────────────+
alias nvcln='command rm -rf $HOME/.{local/share/nvim,config/nvim/plugin/packer_compiled.lua}'
alias zicln='command rm -rf ${HOME}/.{local/share/{zinit,zsh},cache,config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}'
alias ziprune='zi delete --all --yes; ( exec zsh -il );'
alias zrld='builtin exec zsh -l'
alias zireset='builtin cd ${HOME}; unset _comp{_{assocs,dumpfile,options,setup},{auto,}s}; ziprune; zrld; cd -'
# +────────────+
# │ NAVIGATION │
# +────────────+
typeset -A pairs=(
  ..   '..'                               ...   '../..'                 \
  .... '../../..'                         ..... '../../../..'           \
  bin  '$HOME/.local/bin'                 \
  dl   '$HOME/Downloads'                  hs    '$HOME/.hammerspoon'    \
  rr   '$(git rev-parse --show-toplevel)' vd    '$XDG_CONFIG_HOME/nvim' \
  xch  '$XDG_CONFIG_HOME'                 xdh   '$XDG_DATA_HOME'        \
  zdd  '$ZDOTDIR'                         zfd   '$ZDOTDIR/functions'    \
)
for k v in ${(kv)pairs[@]}; do
  builtin alias -- "$k"="_goto $v" || true
done
# +─────+
# │ GIT │
# +─────+
for k v in g 'git' gd 'git diff' gs 'git status' gsu 'git submodule update --merge --remote'; do
  builtin alias -- $k="$v" || true
done
# +───────────────────+
# │ COMMAND SHORTCUTS │
# +───────────────────+
alias me='builtin print -P "%F{blue}$(whoami)%f @ %F{cyan}$(uname -a)%f"'
alias rshfmt="shfmt -i 4 -s -ln bash -sr -bn -ci -w"
alias zc='zinit compile'
alias zht='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
# +───────+
# │ MISC. │
# +───────+
alias -- +x='chmod +x'
alias -- \?='which'
alias gen-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias get-env='print -lio $(env)'
alias get-path='print -l ${(@s[:])PATH}'
alias ps-grep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias rm-docker='docker system prune --all --force'
alias tmp-md='$EDITOR $(mktemp -t scratch.XXX.md)'
# +────────+
# │ PYTHON │
# +────────+
alias http-serve='python3 -m http.server'
alias pip3='python3 -m pip'
alias py3='python3'
alias pip-requirements='python3 -m pip3 install -r requirements.txt || _error "no requirements.txt found"'
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
alias fmtbtysh='python3 -m beautysh --indent-size=2 --force-function-style=paronly'
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
alias cp-dotfiles='rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles'
alias cp-hammerspoon='rsync -azP $HOME/.hammerspoon/ devcloud:~/hammerspoon'
alias cp-nvim='rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim'

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
