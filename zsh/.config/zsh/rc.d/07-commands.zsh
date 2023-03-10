#!/usr/bin/env zsh
##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't get used in function definitions.
#
# This lets you change to any dir without having to type `cd`, that is, by just
# typing its name. Be warned, though: This can misfire if there exists an alias,
# function, builtin or command with the same name.
# In general, I would recommend you use only the following without `cd`:
#   ..  to go one dir up
#   ~   to go to your home dir
#   ~-2 to go to the 2nd mostly recently visited dir
#   /   to go to the root dir
setopt AUTO_CD
# Type '-' to return to your previous dir.
alias -- -='cd -'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.
# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=
# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'
# Note that, unlike with Bash, you do not need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.
# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing. We use it here to stop Zsh from
# evaluating the value of our $expansion as a command.
: ${PAGER:=less}
# Associate file name .extensions with programs to open them.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit; `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'
# Use `< file` to quickly view the contents of any text file.
READNULLCMD=$PAGER  # Set the program to use for this.
if builtin echo "$-" | command grep i > /dev/null; then export IS_TTY='1'; fi
_error() { [[ -v $IS_TTY ]] && builtin print -P "%F{red}[ERROR]%f %F{white}${1}%f" >&2; }
_info() { [[ -v $IS_TTY ]] && builtin print -P "%F{green}==>%f %F{white}${1}%f"; }
# +────────────────+
# │ UTIL FUNCTIONS │
# +────────────────+
_clone_if_absent() { [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"; }
_edit() { ${EDITOR:-nvim} $1 }
_mkfile() { builtin echo "#!/usr/bin/env ${2}" > "$3.$1" && chmod +x "$3.$1"; rehash; $EDITOR "$3.$1"; }
_sys_update() { "$1" update && "$1" upgrade; }
_goto() { [[ -e $1 ]] && { builtin cd "$1" && { has exa && exa --all --long } || command ls -lGo } || _error "${1} not found"; }
# +────────────────+
# │ CODE DIRECTORY │
# +────────────────+
# ! [[ -d $CODEDIR ]] && command mkdir -p -- "${CODEDIR}"
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
alias rmr="rm -rf --"
function rmp() { _info "$(command rm -vf $(which $1))"; }
alias tailf="less +F -R"
# +──────────────────+
# │ CONFIG SHORTCUTS │
# +──────────────────+
typeset -A pairs=(
  ealiases 'zsh/rc.d/07-commands.zsh' gignore 'git/ignore' gcfg 'git/config' \
  kittyrc 'kitty/kitty.conf' nvplg "nvim/lua/plugins.lua" skhdrc 'skhd/skhdrc' \
  tmuxrc 'tmux/tmux.conf' zic 'zsh/rc.d/03-zinit.zsh' zrc 'zsh/.zshrc'
)
for k v in ${(kv)pairs[@]}; do
  builtin alias $k="_edit ${XDG_CONFIG_HOME:-${HOME}/.config}/${v}" || true
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
alias zrld='builtin exec zsh -il'
alias zireset='builtin cd ${HOME}; unset _comp{_{assocs,dumpfile,options,setup},{auto,}s}; ziprune; zrld; cd -'
# +────────────+
# │ NAVIGATION │
# +────────────+
typeset -A pairs=(
  ..   '..'               ...   '../..'                            \
  .... '../../..'         ..... '../../../..'                      \
  bin  '$HOME/.local/bin' rr    '$(git rev-parse --show-toplevel)' \
  dl   '$HOME/Downloads'  hs    '$HOME/.hammerspoon'               \
  xch  '$XDG_CONFIG_HOME' xdh   '$XDG_DATA_HOME'                   \
  zdd  '$ZDOTDIR'         zfd   '$ZDOTDIR/functions'               \
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
alias pip-requirements='python3 -m pip install -r requirements.txt || _error "no requirements.txt found"'
alias venv-activate='source ./venv/bin/activate'
alias venv-create='python3 -m venv ./venv'
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
# alias mkcd='{ local DIR_NAME="$(cat -)"; command mkdir -p -- "$DIR_NAME" && builtin cd -P -- $DIR_NAME }<<<'
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
# alias cldf='command mkdir -p -- $HOME/.config; git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles; cd dotfiles'
alias yum-sys-update="_sys_update 'sudo yum -y'"
# +────────+
# │ REMOTE │
# +────────+
alias cp-dotfiles='rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles'
alias cp-hammerspoon='rsync -azP $HOME/.hammerspoon/ devcloud:~/hammerspoon'
alias cp-nvim='rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim'
