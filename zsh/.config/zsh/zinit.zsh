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
ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
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
#=== ZSH BINARY =======================================
zi for \
    as"null" atclone"./install -e no -d ~/.local" atinit'export PATH="/Users/anonymous/.local/bin:$PATH"' atpull"%atclone" \
    depth"1" \
    lucid \
    nocompile nocompletions \
  @romkatv/zsh-bin
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
zinit for \
    OMZL::{'clipboard','compfix','completion','git','grep','key-bindings','termsupport'}.zsh \
    PZT::modules/{'history','rsync'}
#=== PROMPT & THEME ===================================
zi light-mode silent for \
    compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
        PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
        PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
        zstyle ':prompt:pure:git:action' color 'yellow'
        zstyle ':prompt:pure:git:branch' color 'blue'
        zstyle ':prompt:pure:git:dirty' color 'red'
        zstyle ':prompt:pure:path' color 'cyan'
        zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    "$ZI_REPO"/zinit-annex-{'bin-gem-node','patch-dl','submods'} \
    OMZP::brew
#=== FZF  =============================================
zi for \
  from'gh-r' nocompile sbin \
    junegunn/fzf \
  is-snippet \
    https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh
#=== GITHUB BINARIES ==================================
zi from'gh-r' nocompile for \
  sbin'**/d*a' dandavison/delta \
  sbin'**/exa' ogham/exa \
  sbin'**/g*g' @git-chglog/git-chglog \
  sbin'**/n*m' neovim/neovim \
  sbin'**/s*c' @shellspec/shellspec \
  sbin'**/sh* -> shfmt' @mvdan/sh \
  sbin'g*x'    pemistahl/grex
 # atinit"alias l='exa -blF';alias la='exa -abghilmu;alias ll='exa -al;alias ls='exa --git --group-directories-first'" \
  # sbin'**/exa' atclone'mv completions/exa.zsh _exa' \
zi as'program' for \
  pick"revolver" molovo/revolver \
  atclone'./build.zsh' pick"zunit" zunit-zsh/zunit
#=== COMPLETIONS ======================================
GH_RAW_URL='https://raw.githubusercontent.com'
zi is-snippet as'completion' for \
  OMZP::{'golang/_golang','pip/_pip','terraform/_terraform'} \
  $GH_RAW_URL/{'Homebrew/brew/master/completions/zsh/_brew','docker/cli/master/contrib/completion/zsh/_docker','rust-lang/cargo/master/src/etc/_cargo'}
#=== MISC. ============================================
zi light-mode for \
  thewtex/tmux-mem-cpu-load \
    is-snippet atinit"
      VI_MODE_SET_CURSOR=true
      bindkey -M vicmd '^e' edit-command-line" \
  OMZ::plugins/vi-mode \
    svn submods'zsh-users/zsh-history-substring-search -> external' \
  OMZ::plugins/history-substring-search \
    blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions \
    atinit"
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      bindkey '^_' autosuggest-execute
      bindkey '^ ' autosuggest-accept" \
  zsh-users/zsh-autosuggestions \
    atinit'
      typeset -gA FAST_HIGHLIGHT
      FAST_HIGHLIGHT[git-cmsg-len]=100
      zpcompinit; zpcdreplay' \
  $ZI_REPO/fast-syntax-highlighting
