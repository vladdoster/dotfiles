#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# A zinit-continuum configuration for macOS and Linux.
#
#=== HELPER METHODS ===================================
function error() { print -P "%F{160}[ERROR] ---%f%b $1" >&2 && exit 1; }
function info() { print -P "%F{34}[INFO] ---%f%b $1"; }
#=== ZINIT ============================================
GH_RAW_URL='https://raw.githubusercontent.com'
ZSH_CFG="$HOME/.config/zsh"; ZI_REPO='zdharma-continuum';
typeset -gAH ZINIT; ZINIT[HOME_DIR]=${XDG_DATA_HOME:-$HOME/.local/share/zsh/zinit};
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git;     ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions
ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins;   ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1;
ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets; ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump;
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'Downloading Zinit' \
    && command git clone \
        --branch 'bugfix/system-gh-r-selection' \
        https://github.com/$ZI_REPO/zinit \
        $ZINIT[BIN_DIR] \
    || error 'Unable to download zinit' \
    && info 'Installing Zinit' \
    && command chmod g-rwX $ZINIT[HOME_DIR] \
    && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
    && info 'Successfully installed Zinit' \
    || error 'Unable to install Zinit'
fi
source $ZINIT[BIN_DIR]/zinit.zsh \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
#=== PROMPT & THEME ===================================
zi is-snippet for OMZL::{'functions','history','git','theme-and-appearance'}.zsh
zi light-mode for \
    "$ZI_REPO"/zinit-annex-{'bin-gem-node','patch-dl','rust','submods'}
    # compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
    #     PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    #     PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
    #     zstyle ':prompt:pure:git:action' color 'yellow'
    #     zstyle ':prompt:pure:git:branch' color 'blue'
    #     zstyle ':prompt:pure:git:dirty' color 'red'
    #     zstyle ':prompt:pure:path' color 'cyan'
    #     zstyle ':prompt:pure:prompt:success' color 'green'" \
    # sindresorhus/pure \
    # as'completion' vladdoster/gitfast-zsh-plugin
#=== GITHUB BINARIES ==================================
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship
zi from'gh-r' nocompile for \
    sbin'**/d*a'   dandavison/delta \
    sbin'**/d*h'   Phantas0s/devdash \
    sbin'**/fd'    @sharkdp/fd \
    sbin'**/h*e'   @sharkdp/hyperfine \
    sbin'**/rg'    BurntSushi/ripgrep \
    sbin'**/s*a'   JohnnyMorganz/StyLua \
    sbin'**/volta' volta-cli/volta \
    sbin'fzf'      junegunn/fzf \
    sbin'g*x'      pemistahl/grex \
    sbin'**/nvim' atload'alias v=nvim' ver'nightly' neovim/neovim \
    sbin'**/sh* -> shfmt' @mvdan/sh  \
    sbin'**/exa'  atclone'cp -vf completions/exa.zsh _exa' atinit"
        alias l='exa -blF'; alias la='exa -abghilmu'
        alias ll='exa -al'; alias tree='exa --tree'
        alias ls='exa --git --group-directories-first'" \
    ogham/exa
 #. "$ZSH_CFG"/zi-programs.zsh
#=== COMPLETION =======================================
zinit for \
    OMZL::{'clipboard','compfix','completion','directories','git','grep','key-bindings','termsupport'}.zsh \
    PZT::modules/{'history','rsync'}
zi as'completion' is-snippet for \
    OMZP::{'git','golang/_golang','pip/_pip','terraform/_terraform','npm'} \
    $GH_RAW_URL/Homebrew/brew/master/completions/zsh/_brew \
    $GH_RAW_URL/docker/cli/master/contrib/completion/zsh/_docker \
    $GH_RAW_URL/rust-lang/cargo/master/src/etc/_cargo \
	OMZP::docker-compose as"completion" OMZP::docker/_docker
#=== PLUGINS ==========================================
#zi node'ansible <- !ansible -> ansible; ansible-lint' for $ZI_REPO/null
#zi as'null' for node'react' pip'black' gem'rubyfmt' $ZI_REPO/null
# zi for \
#     id-as'node' node'react; semantic-release; vue' \
#     id-as'pip' pip'black; isort; mdformat; mdformat-gfm; mdformat-tables; mdformat-toc; tldr; wheel' \
#     id-as'gem' gem'rake; ruby-fmt'
#   $ZI_REPO/null
 # zstyle ":completion:*:descriptions" format "$fg[yellow]%B--- %d%b"
zi light-mode for \
    if'[[ ${ZSH_VERSION:0:3} -ge 5.8 ]]' has'fzf' Aloxaf/fzf-tab \
    atinit"VI_MODE_SET_CURSOR=true; bindkey -M vicmd '^e' edit-command-line" is-snippet OMZ::plugins/vi-mode \
    svn submods'zsh-users/zsh-history-substring-search -> external' OMZ::plugins/history-substring-search \
    blockf atpull'zinit creinstall -q .' \
    atinit'
            zstyle ":completion:*" group-name ""
            zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
            zstyle ":completion:*" menu select
            zstyle ":completion:*" verbose yes
            zstyle ":completion:*:corrections" format "%B%d (errors: %e)%b"
            zstyle ":completion:*:descriptions" format "[%d]"
            zstyle ":completion:*:messages" format "[%d]"
            zstyle ":completion:*:warnings" format "$fg[red]No matches for:$reset_color %d"
            zstyle -d ":completion:*" format' \
        zsh-users/zsh-completions \
    atinit"bindkey '^_' autosuggest-execute; bindkey '^ ' autosuggest-accept; ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20" \
        zsh-users/zsh-autosuggestions \
    atinit" typeset -gA FAST_HIGHLIGHT; FAST_HIGHLIGHT[git-cmsg-len]=100; zpcompinit; zpcdreplay;" $ZI_REPO/fast-syntax-highlighting
#=== PIP COMPLETION ===================================
# function _pip_completion {
#   local words cword && read -Ac words && read -cn cword
#   reply=(
#     $(
#       COMP_WORDS="$words[*]" \
#       COMP_CWORD=$(( cword-1 )) \
#       PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null
#     )
#   )
# }
# compctl -K _pip_completion pip3
