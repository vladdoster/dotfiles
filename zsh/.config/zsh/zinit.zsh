#!/usr/bin/env zsh
#Author: Vladislav D.
# GitHub: vladdoster
# Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#=== HELPER METHODS ===================================
function error() { print -P "%F{160}[ERROR] ---%f%b $1" >&2 && exit 1; }
function info() { print -P "%F{34}[INFO] ---%f%b $1"; }
#=== ZINIT ============================================
#    --branch 'refactor/zunit-tests' \
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZI_FORK='vladdoster'; ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'downloading zinit' \
  && command git clone \
    --branch 'refactor/zunit-tests' \
    https://github.com/$ZI_REPO/zinit.git \
    $ZINIT[BIN_DIR] \
  || error 'unable to clone zinit repository' \
  && info 'installing zinit' \
  && command chmod g-rwX $ZINIT[HOME_DIR] \
  && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
  && info 'successfully installed zinit' \
  || error 'unable to install zinit'
fi
source $ZINIT[BIN_DIR]/zinit.zsh \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
#=== ZSH BINARY =======================================
zi for \
    as"null" \
    atclone"./install -e no -d ~/.local" \
    atinit'export PATH="/Users/anonymous/.local/bin:$PATH"' \
    atpull"%atclone" \
    depth"1" lucid nocompile nocompletions \
  @romkatv/zsh-bin
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi for \
  OMZL::{'clipboard','compfix','completion','git','grep','key-bindings','termsupport'}.zsh \
  OMZP::{'brew','yarn'} \
  PZT::modules/{'history','rsync'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
zi is-snippet as'completion' for \
  OMZP::{'golang/_golang','pip/_pip','terraform/_terraform','yarn/_yarn'} \
  $GH_RAW_URL/{'Homebrew/brew/master/completions/zsh/_brew','docker/cli/master/contrib/completion/zsh/_docker','rust-lang/cargo/master/src/etc/_cargo'}
#=== PROMPT ===================================
zi light-mode for \
  compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
    PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'blue'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'cyan'
    zstyle ':prompt:pure:prompt:success' color 'green'" \
  sindresorhus/pure \
  "$ZI_REPO"/zinit-annex-{'bin-gem-node','patch-dl','submods','binary-symlink'}


# cursor configurations for zsh-vim-mode
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_CURSOR_SEARCH="#ff00ff blinking underline"

# mode configuration for zsh-vim-mode, shown on the right (RPS1 stuff)
MODE_INDICATOR_VIINS='%F{15}%F{8}INSERT%f'
MODE_INDICATOR_VICMD='%F{10}%F{2}NORMAL%f'
MODE_INDICATOR_REPLACE='%F{9}%F{1}REPLACE%f'
MODE_INDICATOR_VISUAL='%F{12}%F{4}VISUAL%f'
MODE_INDICATOR_VLINE='%F{12}%F{4}V-LINE%f'

# Make it work with your existing RPS1 if it is set. Note the single quotes
setopt PROMPT_SUBST
RPS1='${MODE_INDICATOR_PROMPT} ${vcs_info_msg_0_}'
export LESS='-RMs'
export PAGER=less
export VISUAL=vi
export LC_COLLATE='C'
export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8
export KEYTIMEOUT=1

#=== GITHUB BINARIES ==================================
zi ice pip'pip;wheel;setuptools;speedtest-cli;'
# mdformat'{'','-config','-gfm','-shfmt','-toc','-web'}';isort;pylint;black'
zi load "$ZI_REPO"/null
zi from'gh-r' lbin nocompile for \
  @git-chglog/git-chglog \
  JohnnyMorganz/StyLua \
  dandavison/delta \
  koalaman/shellcheck \
  lbin'* -> shfmt' @mvdan/sh \
  pemistahl/grex \
  r-darwish/topgrade \
  sbin'**/nvim' ver'nightly' neovim/neovim \
  sbin'**/stylua' JohnnyMorganz/StyLua \
  ver'nightly' neovim/neovim \
    atclone'mv completions/exa.zsh _exa' \
    atinit"alias l='exa -blF';alias la='exa -abghilmu;alias ll='exa -al;alias ls='exa --git --group-directories-first'" \
  ogham/exa \
  from'gh-r' nocompile junegunn/fzf \
  is-snippet https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh
#=== TESTING ============================================
zi as'program' for \
  pick"revolver" mv'revolver.zsh-completion -> _revolver' molovo/revolver \
  atclone'./build.zsh' mv'zunit.zsh-completion -> _zunit' pick"zunit" zunit-zsh/zunit
#=== MISC. ============================================
zi light-mode compile'zsh-vim-mode*.zsh' for softmoth/zsh-vim-mode
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

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip3
# pip zsh completion end
