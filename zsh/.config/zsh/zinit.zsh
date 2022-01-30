#!/bin/zsh
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
function info() { print -P "%F{34}[INFO]%f%b $1"; }
function error() { print -P "%F{160}[ERROR]%f%b $1"; }
#=== ZINIT =============================================
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git     ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1           ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump;
ZPFX=$ZINIT[HOME_DIR]/polaris
ZI_REPO="zdharma-continuum"
        #  --branch 'bugfix/improve-ghr-system-logic' \
        #  https://github.com/vladdoster/zinit.git \
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'installing zinit' \
    && command git clone \
        --branch 'bugfix/system-gh-r-selection' \
        https://github.com/$ZI_REPO/zinit $ZINIT[BIN_DIR] \
    && command chmod g-rwX $ZINIT[HOME_DIR] \
    && info 'installed zinit' \
    && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
  || { error 'unable to clone zinit' >&2 && exit 1 }
fi
source $ZINIT[BIN_DIR]/zinit.zsh \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
#=== PROMPT & THEME ====================================
  #  as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e no -d ~/.local' \
    #  @romkatv/zsh-bin \
zi light-mode for \
    "$ZI_REPO"/zinit-annex-{'submods','patch-dl','bin-gem-node'} \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure
zturbo load for \
  as'completion' vladdoster/gitfast-zsh-plugin \
  pack'bgn-binary+keys' id-as'package/fzf' fzf \
  has'brew'  as'completion' https://raw.githubusercontent.com/Homebrew/brew/master/completions/zsh/_brew \
  has'cargo' as'completion' https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/_cargo      \
  has'docker'         as'completion' OMZP::docker/_docker                 \
  has'docker-compose' as'completion' OMZP::docker-compose/_docker-compose \
  has'go'  OMZP::golang as'completion' OMZP::golang/_golang \
  has'npm' OMZP::npm \
  has'pip' OMZP::pip as'completion' OMZP::pip/_pip \
  has'rsync' PZTM::rsync \
  has'terraform' OMZP::terraform as'completion' OMZP::terraform/_terraform \
  OMZL::{'completion','key-bindings','termsupport'}.zsh \
  OMZP::{'colored-man-pages','history'} \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' \
  svn submods'zsh-users/zsh-completions -> external' \
    PZTM::completion \
  svn submods'zsh-users/zsh-history-substring-search -> external' \
    OMZ::plugins/history-substring-search \
  svn submods'zsh-users/zsh-autosuggestions -> external' \
  atinit'bindkey "^ " autosuggest-accept' \
    PZTM::autosuggestions \
  atinit"VI_MODE_SET_CURSOR=true; bindkey -M vicmd '^e' edit-command-line" is-snippet \
    OMZP::vi-mode
#=== GITHUB BINARIES ==========================================
zturbo as'command' from'gh-r' for \
  sbin'* -> shfmt' @mvdan/sh \
  sbin'**/bat' @sharkdp/bat \
  sbin'**/delta' dandavison/delta   \
  sbin'**/fd' @sharkdp/fd  \
  sbin'**/gh' cli/cli \
  sbin'**/glow'  charmbracelet/glow \
  sbin'**/hyperfine' @sharkdp/hyperfine \
  sbin'**/nvim -> nvim' atinit"alias v=${EDITOR}" ver'nightly' neovim/neovim \
  sbin'**/tmux -> tmux' @tmux/tmux \
  sbin'**/rg' BurntSushi/ripgrep \
  sbin'**/exa' atclone'cp -vf completions/exa.zsh _exa' \
  atload"alias l='ls -blF'; alias la='ls -abghilmu'
         alias ll='ls -al'; alias tree='exa --tree'
         alias ls='exa --git --group-directories-first'" \
  ogham/exa \

function _pip_completion {
  local words cword && read -Ac words && read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip3
