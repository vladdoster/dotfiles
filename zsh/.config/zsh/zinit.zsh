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
case "$OSTYPE" in
  linux*) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
    darwin*) bpick='*(macos|darwin)*' ;;
    *) error 'unsupported system -- some cli programs might not work' ;;
esac
#=== ZINIT =============================================
typeset -gAH ZINIT;                          
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git;     ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1;           ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets; ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump
ZPFX=$ZINIT[HOME_DIR]/polaris
ZI_REPO="zdharma-continuum"
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
#  "bugfix/cleanup-logic-for-gh-r"
  info 'installing zinit' \
    && command git clone --branch="bugfix/cleanup-logic-for-gh-r" \
                         --checkout \
                         https://github.com/vladdoster/zinit.git \
                         $ZINIT[BIN_DIR] \
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
zi light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  as'completion' \
    OMZL::{'completion','key-bindings','termsupport'}.zsh \
  is-snippet atinit' export VI_MODE_SET_CURSOR=true; export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true' \
    OMZP::vi-mode \
    "$ZI_REPO"/zinit-annex-{'submods','patch-dl','bin-gem-node','rust'} \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure
  #  as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e no -d ~/.local' \
    #  @romkatv/zsh-bin \
#  zturbo light-mode for \
  #  vladdoster/gitfast-zsh-plugin \
  #  pack'bgn-binary+keys' id-as'package/fzf' fzf \
  #  has'brew'           as'completion' https://raw.githubusercontent.com/Homebrew/brew/master/completions/zsh/_brew \
  #  has'docker'         as'completion' OMZP::docker/_docker                 \
  #  has'docker-compose' as'completion' OMZP::docker-compose/_docker-compose \
  #  has'go'        OMZP::golang    as'completion' OMZP::golang/_golang       \
  #  has'pip'       OMZP::pip       as'completion' OMZP::pip/_pip             \
  #  has'terraform' OMZP::terraform as'completion' OMZP::terraform/_terraform \
  #  has'npm'   OMZP::npm   \
  #  has'rsync' PZTM::rsync \
  #  svn submods'zsh-users/zsh-completions -> external' \
  #  blockf atpull'zinit creinstall -q .' \
    #  PZT::modules/completion OMZL::completion.zsh \
  #  svn submods'zsh-users/zsh-history-substring-search -> external' \
    #  PZT::modules/history-substring-search OMZL::history.zsh \
  #  atinit'bindkey "^ " autosuggest-accept' \
  #  svn submods'zsh-users/zsh-autosuggestions -> external' \
    #  PZT::modules/autosuggestions
#=== GITHUB BINARIES ==========================================
zturbo from'gh-r' as'program' for \
  sbin'bat*/bat'     @sharkdp/bat \
  sbin'delta*/delta' dandavison/delta \
  sbin'fd*/fd'       @sharkdp/fd      \
  sbin'ripgrep*/rg'  BurntSushi/ripgrep \
  sbin'hyperfine*/hyperfine' @sharkdp/hyperfine \
  sbin'shfmt* -> shfmt'      @mvdan/sh          \
  sbin'nvim*/**/nvim' atinit"alias v=$EDITOR" neovim/neovim \
  sbin'**/exa'         atclone'cp -vf completions/exa.zsh _exa' \
  atload"alias l='ls -blF'; alias la='ls -abghilmu'
         alias ll='ls -al'; alias tree='exa --tree'
         alias ls='exa --git --group-directories-first'" \
    ogham/exa
#=== RUST BINARIES ==========================================
#  zturbo as'null' sbin'bin/*' rustup \
  #  atload"[[ ! -f ${ZINIT[COMPLETIONS_DIR]}/_cargo ]] && zi creinstall rust \
         #  && export CARGO_HOME=$PWD RUSTUP_HOME=$PWD/rustup" \
  #  cargo'bat;fd-find;hyperfine;ripgrep;sd;skim;zenith;git-delta' for \
    #  zdharma-continuum/null
#  zturbo 1a as"program" bpick"*.tar.gz" nocompile'!' atpull'%atclone' for \
   #  make'-j bin/stow' pick"bin/stow" atclone"
      #  autoreconf -iv \
      #  && ./configure --prefix=$ZPRFX" \
    #  @aspiers/stow \
  #  pick"tmux" make'-j' atclone"
      #  autoreconf -iv \
      #  && ./configure --disable-utf8proc --prefix=$ZPRFX" \
    #  @tmux/tmux

# pip zsh completion start
#  function _pip_completion {
  #  local words cword
  #  read -Ac words
  #  read -cn cword
  #  reply=( $( COMP_WORDS="$words[*]" \
             #  COMP_CWORD=$(( cword-1 )) \
             #  PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
#  }
#  compctl -K _pip_completion pip3
