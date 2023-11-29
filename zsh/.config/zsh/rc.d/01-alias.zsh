alias -- -='cd -q -'
alias -- b='-'
alias %= \$=
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'
alias -g B='brew'
alias -g C='cat'
alias -g G='grep -R '
alias -g L='less'
alias -g S='sort --unique'
alias -g W='| wc -l'

for i in nvim vim vi; do
    (( $+commands[$i] )) && {
        export EDITOR="$i" 
        alias v="${i}"
        break
    }
done

_clone_if_absent () {
    [[ ! -d $1 ]] && git clone "$1" "$2/$(basename "$1" .git)"
}

_edit () {
    $EDITOR $@
}

_mkfile () {
    builtin echo "#!/usr/bin/env ${2}" > "$3.$1" && chmod +x "$3.$1"
    rehash
    $EDITOR "$3.$1"
}

_sys_update () {
    "$1" update && "$1" upgrade
}

_goto () {
    [[ -e $1 ]] && builtin cd "$1" && {
        exa --all --long 2> /dev/null || command ls -lGo || _error "${1} not found"
    }
}

_info () {
    builtin print -P -- "%F{green}==>%f %F{white}${1}%f"
}

if [[ ! -d "$HOME/code" ]]; then
    command mkdir -p "$HOME/code"
fi

if [[ $OSTYPE =~ darwin* ]]; then
    _copy_cmd='pbcopy' 
    alias readlink="greadlink"
    alias copy="$_copy_cmd <"
fi

alias bashly_edge='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly:edge'
alias rmr="rm -rf --"
alias tailf="less +F -R"
alias l='ls -a'
alias la='ls -a'
alias ll='ls -al'

emulate -L zsh
setopt extendedglob

typeset -A pairs=(ealiases 'zsh/rc.d/[0-9]*-alias.zsh' gignore 'git/ignore' gcfg 'git/config' nvplg "nvim/lua/plugins.lua" rcenv 'zsh/rc.d/[0-9]*-env.zsh' wezrc 'wezterm/wezterm.lua' tmuxrc 'tmux/tmux.conf' zic 'zsh/rc.d/[0-9]*-zinit.zsh' zrc 'zsh/.zshrc' brewrc "$DOTFILES/Brewfile") 
for k v in ${(kv)pairs[@]}; do
    builtin alias $k="_edit ${XDG_CONFIG_HOME:-${HOME}/.config}/${v}" || true
done

alias zinstall='_edit $ZINIT[BIN_DIR]/zinit-install.zsh'

for k v in hscfg '.hammerspoon/init.lua' sshrc '.ssh/config' zec '.zshenv' zpc '.zprofile'; do
    builtin alias -- $k="_edit ${HOME}/${v}" || true
done

alias nvcln='command rm -rf $HOME/.{local/share/nvim,config/nvim/plugin/packer_compiled.lua}'
alias zicln='command rm -rf ${HOME}/.{local/share/{zinit,zsh},cache,config/{zinit,zsh/.{zcomp{cache,dump},zsh_sessions}}}'
alias ziprune='zi delete --all --yes; ( exec zsh -il );'
alias zrld='builtin exec zsh -i'
alias zireset='builtin cd ${HOME}; unset _comp{_{assocs,dumpfile,options,setup},{auto,}s}; ziprune; zrld; cd -'

typeset -A pairs=(.. '../' ... '../../' .... '../../../' bin '~/.local/bin' dl '~/Downloads' hsd '~/.hammerspoon' xch '~/.config' xdh '~/.local/share' zcf '$ZDOTDIR/rc.d' df '${DOTFILES:-~/.config/dotfiles}') 
for k v in ${(kv)pairs[@]}; do
    builtin alias -- "$k"="_goto $v" || true
done

for k v in g '\git' gd '\git diff' gs '\git status' gsu '\git submodule update --merge --remote'; do
    builtin alias -- $k="$v" || true
done

alias auld='builtin autoload'
alias me='builtin print -P "%F{blue}$(whoami)%f @ %F{cyan}$(uname -a)%f"'
alias mk='make'

alias zc='zinit compile'
alias zgd='cd $ZINIT[BIN_DIR]; ls'
alias zhd='cd $ZINIT[HOME_DIR]; ls'
alias zht='hyperfine --warmup 100 --runs 10000 "/bin/ls"'
alias zmld="builtin zmodload"

alias -- +x='chmod +x'
alias -- \?='which'
alias gen-passwd='openssl rand -base64 24'

alias get-my-ip='curl ifconfig.co'
alias get-env='print -lio $(env)'
alias get-path='print -l ${(@s[:])PATH}'

alias tmp-md='$EDITOR $(mktemp -t scratch.XXX.md)'
alias git-repo-website='open $(git remote get-url origin)'
alias http-serve='python3 -m http.server'
alias get-localnet-hosts='sudo arp-scan --format="\${Name;-30}\${ip}" --localnet --ignoredups --plain --resolve | sort --human-numeric-sort'
alias get-open-ports='sudo lsof -i -n -P | grep TCP'
alias ping='ping -c 10'

alias mkcd='{ local DIR_NAME="$(cat -)"; command mkdir -p -- "$DIR_NAME" && builtin cd -P -- $DIR_NAME }<<<'
alias mkcmd='{ F_NAME="$(cat -)"; touch "$F_NAME"; chmod +x $F_NAME; rehash; nvim $F_NAME }<<<'
alias mkmd='{ F_NAME="$(cat -).md"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkpy='_mkfile py "python3"'
alias mksh='_mkfile sh "bash"'
alias mktxt='{ F_NAME="$(cat -).txt"; touch "$F_NAME"; _info "created: $F_NAME"; }<<<'
alias mkzsh='_mkfile zsh "zsh"'

alias fmtbtysh='python3 -m beautysh --indent-size=2 --force-function-style=paronly'
alias fmtlua='stylua -i'
alias fmtmd='mdformat --number --wrap 100'
alias fmtpy='python3 -m black'
alias fmtsh='shfmt -bn -ci -i 2 -ln=bash -s -sr -w'
alias wsys='echo OSTYPE=${OSTYPE} MACHTYPE=${MACHTYPE} CPUTYPE=${CPUTYPE} hardware=$(uname -m) processor=$(uname -p)'

alias cp-dotfiles='rsync -azP $XDG_CONFIG_HOME/dotfiles/ devcloud:~/dotfiles'
alias cp-hammerspoon='rsync -azP $HOME/.hammerspoon/ devcloud:~/hammerspoon'
alias cp-nvim='rsync -azP $XDG_CONFIG_HOME/nvim/ devcloud:~/nvim'
