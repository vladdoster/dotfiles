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
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZI_REPO="zdharma-continuum"
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
#=== PROMPT & THEME ====================================
zi light-mode for \
    "$ZI_REPO"/zinit-annex-{'submods','patch-dl','bin-gem-node'} \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure
#=== PLUGINS ==========================================
zi lucid wait for \
  atinit"zicompinit; zicdreplay" light-mode $ZI_REPO/fast-syntax-highlighting \
  atinit"VI_MODE_SET_CURSOR=true; bindkey -M vicmd '^e' edit-command-line" is-snippet \
		OMZ::plugins/vi-mode \
  atinit"bindkey '^_' autosuggest-execute; bindkey '^ ' autosuggest-accept" \
		zsh-users/zsh-autosuggestions \
  atinit"HISTFILE=$HOME/.zhistory" PZT::modules/history \
  as'completion' vladdoster/gitfast-zsh-plugin \
  atpull'zinit creinstall -q .' blockf svn submods'zsh-users/zsh-completions -> external' \
    PZT::modules/completion \
  svn submods'zsh-users/zsh-history-substring-search -> external' \
    OMZ::plugins/history-substring-search
#=== COMPLETION ==========================================
zi lucid wait is-snippet as'completion' for \
  OMZP::golang/_golang \
  OMZP::pip/_pip \
  OMZP::terraform/_terraform \
  https://raw.githubusercontent.com/Homebrew/brew/master/completions/zsh/_brew \
  https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker \
  https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/_cargo
  #  has'npm' OMZP::npm \
  #  has'rsync' PZTM::rsync \
#=== GITHUB BINARIES ==========================================
zi pip'black; isort; mdformat; mdformat-gfm; mdformat-tables; mdformat-toc; tldr; wheel' load for \
  "$ZI_REPO"/null
#  zi from'gh-r' lucid nocompile for \
  #  sbin'**/bat'  @sharkdp/bat          \
  #  sbin'**/d*a'  dandavison/delta      \
  #  sbin'**/fd'   @sharkdp/fd           \
  #  sbin'**/g*r'  idc101/git-mkver      \
  #  sbin'**/g*w'  charmbracelet/glow    \
  #  sbin'**/gh'   cli/cli               \
  #  sbin'**/h*e'  @sharkdp/hyperfine    \
  #  sbin'**/l*t'  jesseduffield/lazygit \
  #  sbin'**/nvim' atinit'alias v=nvim' ver'nightly' neovim/neovim \
  #  sbin'**/p*s'  dalance/procs \
  #  sbin'**/rg'   BurntSushi/ripgrep \
  #  sbin'**/t*i' XAMPPRocky/tokei  \
  #  sbin'fzf'    junegunn/fzf      \
  #  sbin'g*r'    @github/git-sizer \
  #  sbin'g*x'    pemistahl/grex    \
  #  sbin'**/sh* -> shfmt' @mvdan/sh             \
  #  sbin'**/exa'  atclone'cp -vf completions/exa.zsh _exa' atinit"
      #  alias l='exa -blF'; alias la='exa -abghilmu'
      #  alias ll='exa -al'; alias tree='exa --tree'
      #  alias ls='exa --git --group-directories-first'" \
    #  ogham/exa
#=== PIP COMPLETION
function _pip_completion {
  local words cword && read -Ac words && read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip3
#  eval "$(pip3 completion --zsh)" &
