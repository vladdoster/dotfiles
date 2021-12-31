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
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
function info() { print -P "%F{34}[INFO]%f%b $1"; }
function error() { print -P "%F{160}[ERROR]%f%b $1"; }
case "$OSTYPE" in
  linux*) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
    darwin*) bpick='*(macos|darwin)*' ;;
    *) error 'unsupported system -- some cli programs might not work' ;;
esac
#=== ZINIT =============================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME:-~/.local/share}}/zinit"
ZINIT_BIN_DIR_NAME="${ZINIT_BIN_DIR_NAME:-bin}"
if [[ ! -f "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" ]]; then
  info 'installing zinit' \
    && command mkdir -p "${ZINIT_HOME}" \
    && command chmod g-rwX "${ZINIT_HOME}" \
    && command git clone --depth 1 --branch main https://github.com/${ZINIT_REPO:-vladdoster}/zinit-1 "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" \
  && info 'installed zinit' \
  || { error 'unable to clone zinit' >&2 && exit 1 }
fi
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
#  autoload -U +X bashcompinit && bashcompinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    zdharma-continuum/zinit-annex-{submods,patch-dl,bin-gem-node}
#=== ZSH-STATIC =======================================
zturbo light-mode as'null' nocompile nocompletions atpull'%atclone' atclone'./install -e yes -d /usr/local' for \
    @romkatv/zsh-bin
#  zinit as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e no -d ~/.local' for \
    #  @romkatv/zsh-bin
#=== OH-MY-ZSH ===============================================
#  zi {'is-snippet svn','is-snippet'} for OMZ::plugins/{'git','/git/git.plugin.zsh'}
zturbo is-snippet for \
  svn \
    OMZ::plugins/git \
    OMZ::plugins/git/git.plugin.zsh \
    OMZP::pip \
  as'completion' \
    OMZP::pip/_pip \
  svn \
    OMZ::plugins/terraform \
  as'completion' atload'export RPROMPT=$(tf_prompt_info)' \
    OMZP::terraform/_terraform
#=== BINARIES ==========================================
zturbo for \
  sbin"fzf" from'gh-r' as'command' \
    junegunn/fzf-bin \
    OMZL::{'clipboard','completion','grep'}.zsh \
    OMZP::{'vi-mode','brew','fzf'} \
  is-snippet svn submods'zsh-users/zsh-autosuggestions -> external' \
      PZT::modules/autosuggestions \
  is-snippet svn submods'zsh-users/zsh-completions -> external' \
      PZT::modules/completion \
  is-snippet svn submods'zsh-users/zsh-history-substring-search -> external' \
  bindmap'^[[A -> history-substring-search-up' bindmap'^[[B -> history-substring-search-down' \
      PZTM::history-substring-search \
  light-mode \
      zdharma-continuum/fast-syntax-highlighting
#=== MISC. =============================================
zturbo from'gh-r' as"command" for \
  sbin'grex'              pemistahl/grex   \
  sbin'git-sizer'         bpick"${bpick}" @github/git-sizer \
  sbin'**/bat   -> bat'   @sharkdp/bat     \
  sbin'**/delta -> delta' dandavison/delta \
  sbin'**/fd    -> fd'    @sharkdp/fd      \
  sbin'**/rg    -> rg'    BurntSushi/ripgrep \
  sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
  sbin'shfmt*      -> shfmt'      bpick"${bpick}"    @mvdan/sh         \
  sbin"**/bin/nvim -> nvim"  bpick"${bpick}" \
  atload"export EDITOR='nvim' && alias v=$EDITOR" neovim/neovim \
  sbin'**/exa -> exa' atclone'cp -vf completions/exa.zsh _exa'  \
  atload"
      alias ls='exa --git --group-directories-first'
      alias l='ls -blF' && alias la='ls -abghilmu'
      alias ll='ls -al' && alias tree='exa --tree'" \
    ogham/exa
