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
function info() { echo '[INFO] '; }
function error() { echo '[ERROR] '; }
case "$OSTYPE" in
  linux-gnu) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
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
    && command git clone --depth 1 --branch main https://github.com/vladdoster/zinit-1 "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" \
  && info 'installed zinit' \
  || error 'git not found' >&2
fi
autoload -U +X bashcompinit && bashcompinit
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    zdharma-continuum/zinit-annex-submods \
    zdharma-continuum/zinit-annex-patch-dl
#=== GIT ===============================================
zi ice svn; zi snippet OMZ::plugins/git
zi snippet OMZ::plugins/git/git.plugin.zsh
#=== PIP ===============================================
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip
#=== MISC. =============================================
zturbo 0a light-mode for \
  ver'develop' atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  is-snippet atload'zstyle ":completion:*" special-dirs false' \
    PZTM::completion \
  atload"zicompinit; zicdreplay" blockf \
    zsh-users/zsh-completions \
  blockf atpull'zinit creinstall -q .' \
    zdharma-continuum/fast-syntax-highlighting \
  atload'
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down' \
    zsh-users/zsh-history-substring-search
#=== FZF ==============================================
zturbo 0b light-mode for \
  pack dircolors-material  \
  pack'binary+keys'  fzf
#=== BINARIES ==========================================
zturbo 0c from"gh-r" as'program' for \
  mv"ripgrep* -> ripgrep"         pick"ripgrep/rg"   @BurntSushi/ripgrep     \
  mv"tree-sitter* -> tree-sitter" pick"tree-sitter"  tree-sitter/tree-sitter \
  pick"delta*/delta"              dandavison/delta   \
  pick'fd*/fd'                    @sharkdp/fd        \
  pick'git-sizer'                 @github/git-sizer  \
  pick'grex'                      pemistahl/grex     \
  pick'hyperfine* /hyperfine'     @sharkdp/hyperfine \
  pick'shfmt'                     bpick"${bpick}"    @mvdan/sh               \
  atload"
      alias ls='exa --git --group-directories-first'
      alias l='ls -blF'
      alias la='ls -abghilmu'
      alias ll='ls -al'
      alias tree='exa --tree'" \
  mv'bin/exa* -> exa' \
    ogham/exa \
  atload"alias v='nvim'; export EDITOR='nvim'" bpick"${bpick}" \
  mv'nvim* -> nvim' pick'nvim/bin/nvim' ver'nightly' \
    neovim/neovim
