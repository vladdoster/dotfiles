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


zi lucid wait'!0' for \
  atinit"zicompinit; zicdreplay" light-mode \
    zdharma-continuum/fast-syntax-highlighting \
  atinit"VI_MODE_SET_CURSOR=true; bindkey -M vicmd '^e' edit-command-line" is-snippet \
    OMZ::plugins/vi-mode \
  atinit"bindkey '^_' autosuggest-execute; bindkey '^ ' autosuggest-accept" \
    zsh-users/zsh-autosuggestions

zi lucid wait'1' for \
  as'completion' vladdoster/gitfast-zsh-plugin \
  atpull'zinit creinstall -q .' blockf \
  svn submods'zsh-users/zsh-completions -> external' \
    PZT::modules/completion \
  svn submods'zsh-users/zsh-history-substring-search -> external' \
    OMZ::plugins/history-substring-search

zi lucid wait'1b' as'command' from'gh-r' light-mode for \
  sbin'**/nvim' atinit"alias v=${EDITOR}" ver'nightly' neovim/neovim \
  sbin'**/exa -> exa' atclone'cp -vf completions/exa.zsh _exa' \
  atload"alias l='ls -blF'; alias la='ls -abghilmu'
         alias ll='ls -al'; alias tree='exa --tree'
         alias ls='exa --git --group-directories-first'" \
    ogham/exa

zi lucid wait'2' for \
  has'brew'  as'completion' https://raw.githubusercontent.com/Homebrew/brew/master/completions/zsh/_brew \
  has'cargo' as'completion' https://raw.githubusercontent.com/rust-lang/cargo/master/src/etc/_cargo      \
  has'docker'         as'completion' OMZP::docker/_docker                 \
  has'docker-compose' as'completion' OMZP::docker-compose/_docker-compose \
  has'go'  OMZP::golang as'completion' OMZP::golang/_golang \
  has'npm' OMZP::npm \
  has'pip' OMZP::pip as'completion' OMZP::pip/_pip \
  has'rsync' PZTM::rsync \
  has'terraform' OMZP::terraform as'completion' OMZP::terraform/_terraform
#=== GITHUB BINARIES ==========================================
zi lucid wait'3' from'gh-r' for \
  sbin'**/bat'   @sharkdp/bat       \
  sbin'**/delta' dandavison/delta   \
  sbin'**/fd'    @sharkdp/fd        \
  sbin'**/glow'  charmbracelet/glow \
  sbin'fzf'      junegunn/fzf       \
  sbin'**/g*x -> grex'  @pemistahl/grex    \
  sbin'**/rg -> rg'    BurntSushi/ripgrep \
  sbin'**/sd* -> sd'    chmln/sd           \
  sbin'**/sh* -> shfmt' @mvdan/sh          \
  sbin'**/h*e -> hyperfine' @sharkdp/hyperfine
#  function _pip_completion {
  #  local words cword && read -Ac words && read -cn cword
  #  reply=( $( COMP_WORDS="$words[*]" \
             #  COMP_CWORD=$(( cword-1 )) \
             #  PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
#  }
#  compctl -K _pip_completion pip3
