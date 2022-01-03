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
typeset -gAH ZINIT
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'installing zinit' \
    && command git clone https://github.com/vladdoster/zinit-1 $ZINIT[BIN_DIR] \
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
#  zi snippet OMZL::git.zsh
#  zi snippet OMZP::git
zi light-mode for \
    zdharma-continuum/zinit-annex-{submods,patch-dl,bin-gem-node} \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
  atload"zstyle ':prezto:module:editor' key-bindings 'vi'" \
  as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e no -d ~/.local' \
    @romkatv/zsh-bin

zturbo for \
    vladdoster/gitfast-zsh-plugin \
    PZTM::{'homebrew','rsync'} \
  atload"zstyle ':prezto:module:editor' key-bindings 'vi'" \
    PZTM::editor

zturbo is-snippet for \
    OMZP::golang    as'completion' OMZP::golang/_golang       \
    OMZP::pip       as'completion' OMZP::pip/_pip             \
    OMZP::terraform as'completion' OMZP::terraform/_terraform \
  svn submods'zsh-users/zsh-history-substring-search -> external' \
    PZTM::history-substring-search \
  svn submods'zsh-users/zsh-autosuggestions -> external' \
    PZT::modules/autosuggestions \
  svn submods'zsh-users/zsh-completions -> external' \
    PZT::modules/completion
zturbo light-mode for atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting

zturbo for \
  vladdoster/gitfast-zsh-plugin \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  id-as'junegunn/fzf' nocompile pick'/dev/null' sbin'fzf' src'key-bindings.zsh' \
  from'gh-r' atclone'mkdir -p $ZPFX/{bin,man/man1}' atpull'%atclone' \
  dl'
      https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -> _fzf_completion;
      https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -> key-bindings.zsh;
      https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/man/man1/fzf-tmux.1;
      https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/man/man1/fzf.1' \
  @junegunn/fzf \
  OMZP::fzf

#=== BINARIES ==========================================
zturbo 2a from'gh-r' as'program' for \
  sbin'bat*/bat'             @sharkdp/bat       \
  sbin'delta*/delta'         dandavison/delta   \
  sbin'ripgrep*/rg'          BurntSushi/ripgrep \
  sbin'shfmt* -> shfmt'      bpick"${bpick}"    @mvdan/sh \
  sbin'hub-*/bin/hub'  cp'hub-*/etc/hub.zsh_completion -> _hub' @github/hub \
  sbin'nvim*/bin/nvim' bpick"${bpick}" atload"export EDITOR='nvim'; alias v=$EDITOR" neovim/neovim \
  sbin'**/exa' atclone'cp -vf completions/exa.zsh _exa'  \
  atload"
      alias l='ls -blF'; alias la='ls -abghilmu'
      alias ll='ls -al'; alias tree='exa --tree'
      alias ls='exa --git --group-directories-first'" \
    ogham/exa
  #  sbin'hyperfine*/hyperfine' @sharkdp/hyperfine \
#  zturbo 2b as"program" bpick"*.tar.gz" nocompile'!' atpull'%atclone' for \
   #  make'-j bin/stow' pick"bin/stow" atclone"
      #  autoreconf -iv \
      #  && ./configure --prefix=$ZPRFX" \
    #  @aspiers/stow
  #  pick"tmux" make'-j' atclone"
      #  autoreconf -iv \
      #  && ./configure --disable-utf8proc --prefix=$ZPRFX" \
    #  @tmux/tmux
