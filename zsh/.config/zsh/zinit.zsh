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
function info() { print -P "%F{34}[INFO]%f%b $1"; }
function error() { print -P "%F{160}[ERROR]%f%b $1"; }
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
    && command git clone --depth 1 --branch main https://github.com/${ZINIT_REPO:-vladdoster}/zinit-1 "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" \
  && info 'installed zinit' \
  || error 'git not found' >&2
fi
#  autoload -U +X bashcompinit && bashcompinit
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
ZINIT_REPO="zdharma-continuum"
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    ${ZINIT_REPO}/zinit-annex-submods \
    ${ZINIT_REPO}/zinit-annex-patch-dl \
    ${ZINIT_REPO}/zinit-annex-bin-gem-node
#=== GIT ===============================================
zi ice svn; zi snippet OMZ::plugins/git
zi snippet OMZ::plugins/git/git.plugin.zsh
#=== OSX ===============================================
zi ice if'[[ $OSTYPE = darwin* ]]' svn; zi snippet PZTM::gnu-utility
#=== PIP ===============================================
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip
#=== MISC. =============================================
zturbo for \
  is-snippet svn submods'zsh-users/zsh-autosuggestions -> external' \
    PZTM::autosuggestions \
  is-snippet svn submods'zsh-users/zsh-completions -> external' \
    PZTM::completion \
  light-mode \
    zdharma-continuum/fast-syntax-highlighting \
  is-snippet svn atload'
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down' \
  submods'zsh-users/zsh-history-substring-search -> external' \
    OMZP::history-substring-search \
    OMZP::vi-mode
    #  PZTM::history-substring-search \
#=== FZF ==============================================
zturbo for \
  as'program' pick"$ZPFX/bin/(fzf|fzf-tmux)" make"PREFIX=$ZPFX install" \
  atclone'cp shell/completion.zsh _fzf_completion; cp bin/(fzf|fzf-tmux) $ZPFX/bin' \
    junegunn/fzf \
  from"gh-r" bpick"${bpick}" as"null" sbin"fzf" \
    junegunn/fzf-bin \
    Aloxaf/fzf-tab
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|v):*' fzf-preview 'exa -1 --color=always ${realpath}'
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|v):*' popup-pad 30 0

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'|
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line enter

export FZF_DEFAULT_COMMAND="
        fd --type f --hidden --follow --exclude .git \
          || git ls-tree -r --name-only HEAD \
          || rg --files --hidden --follow --glob '!.git' \
          || find ."
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="--preview '(kitty icat --transfer-mode file {} || bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"
#=== BINARIES ==========================================
zturbo 1b from"gh-r" as'program' for \
    pick"delta*/delta" dandavison/delta \
    pick'git-sizer'    bpick"${bpick}"  @github/git-sizer \
    pick'grex'         pemistahl/grex   \
    pick'shfmt'        bpick"${bpick}"  @mvdan/sh
zturbo 1c from'gh-r' as"command" for \
    mv'bat* bat'             sbin'**/bat -> bat'             @sharkdp/bat       \
    mv'fd* fd'               sbin'**/fd -> fd'               @sharkdp/fd        \
    mv'hyperfine* hyperfine' sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
    mv'rip* ripgrep'         sbin'**/rg -> rg'               BurntSushi/ripgrep \
    mv'nvim* nvim'           sbin"**/bin/nvim -> nvim"       bpick"${bpick}"    \
    atload'
        export EDITOR="nvim" && alias v="${EDITOR}"' \
      neovim/neovim \
    sbin'**/exa -> exa' atclone'cp -vf completions/exa.zsh _exa' \
    atload"
        alias ls='exa --git --group-directories-first'
        alias l='ls -blF' && alias la='ls -abghilmu'
        alias ll='ls -al' && alias tree='exa --tree'" \
      ogham/exa
