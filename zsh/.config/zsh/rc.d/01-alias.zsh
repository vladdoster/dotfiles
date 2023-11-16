# Commands, funtions and aliases
# Always set aliases _last,_ so they don't get used in function definitions.
##
# type '-' to return to your previous dir.
alias -- -='cd -q -'
alias -- b='-'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.
# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=
# +─────+
# │ ZMV │
# +─────+
# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'
# Note that, unlike with Bash, you do not need to inform Zsh's completion
# system of your aliases. It will figure them out automatically. Set $PAGER if
# it hasn't been set yet. We need it below. `:` is a builtin command that does
# nothing. We use it here to stop Zsh from evaluating the value of our
# $expansion as a command.

# Associate file name .extensions with programs to open them. Note that the dot
# is implicit; `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'
# Use `< file` to quickly view the contents of any text file.
# +────────────────+
# │ GLOBAL ALIASES │
# +────────────────+
alias -g B='brew' # pipe output to `wc` with option `-l`
alias -g C='cat'  # pipe output to grep
alias -g G='grep -R '  # pipe output to grep
alias -g L='less'  # pipe output to less
alias -g S='sort --unique' # pipe output to `wc` with option `-l`
alias -g W='| wc -l' # pipe output to `wc` with option `-l`
# +────────────────+
# │ UTIL FUNCTIONS │
# +────────────────+
for i (nvim vim vi); do
  (( $+commands[$i] )) && {
    export EDITOR="$i"
    alias v="${i}"
    break
  }
done
_clone_if_absent() { [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"; }
_edit() { $EDITOR $@; }
_mkfile() { builtin echo "#!/usr/bin/env ${2}" > "$3.$1" && chmod +x "$3.$1"; rehash; $EDITOR "$3.$1"; }
_sys_update() { "$1" update && "$1" upgrade; }
_goto() { [[ -e $1 ]] && builtin cd "$1" && { exa --all --long 2> /dev/null || command ls -lGo  || _error "${1} not found" } }
_info() { builtin print -P -- "%F{green}==>%f %F{white}${1}%f"; }
# +────────────────+
# │ CODE DIRECTORY │
# +────────────────+
if [[ ! -d "$HOME/code" ]]; then
  command mkdir -p "$HOME/code"
fi
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
alias tailf="less +F -R"
alias l='ls -a'
alias la='ls -a'
alias ll='ls -al'
# +──────────────────+
# │ CONFIG SHORTCUTS │
# +──────────────────+

emulate -L zsh
setopt extendedglob
typeset -A pairs=(
  ealiases 'zsh/rc.d/[0-9]*-alias.zsh' gignore 'git/ignore'                gcfg  'git/config'
  nvplg    "nvim/lua/plugins.lua"      rcenv   'zsh/rc.d/[0-9]*-env.zsh'   wezrc 'wezterm/wezterm.lua'
  tmuxrc   'tmux/tmux.conf'            zic     'zsh/rc.d/[0-9]*-zinit.zsh' zrc   'zsh/.zshrc'
  brewrc   "$DOTFILES/Brewfile"
)
for k v in ${(kv)pairs[@]}; do
  builtin alias $k="_edit ${XDG_CONFIG_HOME:-${HOME}/.config}/${v}" || true
done
alias zinstall='_edit $ZINIT[BIN_DIR]/zinit-install.zsh'
# +────────────────+
# │ HOME SHORTCUTS │
# +────────────────+
for k v in hscfg '.hammerspoon/init.lua' sshrc '.ssh/config' zec '.zshenv' zpc '.zprofile'; do
  builtin alias -- $k="_edit ${HOME}/${v}" || true
done
# +─────────────────+
# │ RELOAD COMMANDS │
# +─────────────────+
alias nvcln='command rm -rf $HOME/.{local/share/nvim,config/nvim/plugin/packer_compiled.lua}'
alias zicln='command rm -rf ${HOME}/.{local/share/{zinit,zsh},cache,config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}'
alias ziprune='zi delete --all --yes; ( exec zsh -il );'
alias zrld='builtin exec zsh -i'
alias zireset='builtin cd ${HOME}; unset _comp{_{assocs,dumpfile,options,setup},{auto,}s}; ziprune; zrld; cd -'
# +────────────+
# │ NAVIGATION │
# +────────────+
typeset -A pairs=(
  ..  '../'          ... '../../'         .... '../../../'
  bin '~/.local/bin' dl  '~/Downloads'    hsd  '~/.hammerspoon'
  xch '~/.config'    xdh '~/.local/share' zdd  '$ZDOTDIR'
  zcf '$ZDOTDIR/rc.d' df '${DOTFILES:-~/.config/dotfiles}'
)
# rr  '$(git rev-parse --show-toplevel)' zs  '   '
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
alias auld='builtin autoload'
alias me='builtin print -P "%F{blue}$(whoami)%f @ %F{cyan}$(uname -a)%f"'
alias mk='make'
alias zc='zinit compile'
alias zgd='cd $ZINIT[BIN_DIR]; ls'
alias zhd='cd $ZINIT[HOME_DIR]; ls'
alias zht='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
alias zmld="builtin zmodload"
# +───────+
# │ MISC. │
# +───────+
alias -- +x='chmod +x'
alias -- \?='which'
alias gen-passwd='openssl rand -base64 24'
alias get-my-ip='curl ifconfig.co'
alias get-env='print -lio $(env)'
alias get-path='print -l ${(@s[:])PATH}'
alias tmp-md='$EDITOR $(mktemp -t scratch.XXX.md)'
# +────────+
# │ PYTHON │
# +────────+
alias http-serve='python3 -m http.server'
# +──────────────+
# │ NETWORK INFO │
# +──────────────+
alias get-localnet-hosts='sudo arp-scan --format="\${Name;-30}\${ip}" --localnet --ignoredups --plain --resolve | sort --human-numeric-sort'
alias get-open-ports='sudo lsof -i -n -P | grep TCP'
alias ping='ping -c 10'
# +───────────────+
# │ FILE CREATION │
# +───────────────+
alias mkcd='{ local DIR_NAME="$(cat -)"; command mkdir -p -- "$DIR_NAME" && builtin cd -P -- $DIR_NAME }<<<'
alias mkcmd='{ F_NAME="$(cat -)"; touch "$F_NAME"; chmod +x $F_NAME; rehash; nvim $F_NAME }<<<'
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkpy='_mkfile py "python3"'
alias mksh='_mkfile sh "bash"'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkzsh='_mkfile zsh "zsh"'
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
alias wsys='echo OSTYPE=${OSTYPE} MACHTYPE=${MACHTYPE} CPUTYPE=${CPUTYPE} hardware=$(uname -m) processor=$(uname -p)'
# +────────+
# │ REMOTE │
# +────────+
alias cp-dotfiles='rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles'
alias cp-hammerspoon='rsync -azP $HOME/.hammerspoon/ devcloud:~/hammerspoon'
alias cp-nvim='rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim'