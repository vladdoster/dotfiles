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
autoload -U +X bashcompinit && bashcompinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
FZF_REPO="https://raw.githubusercontent.com/junegunn/fzf/master"
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    zdharma-continuum/zinit-annex-{submods,patch-dl,bin-gem-node}
#=== ZSH-STATIC =======================================
# root
zinit as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e yes -d /usr/local' for \
    @romkatv/zsh-bin
# root-less
#  zinit as'null' depth'1' nocompile nocompletions atpull'%atclone' atclone'./install -e no -d ~/.local' for \
    #  @romkatv/zsh-bin
#=== FZF ==============================================
zi as'command' atclone'mkdir -p $ZPFX/bin; cp -vf fzf $ZPFX/bin' atpull'%atclone' \
  from'gh-r' id-as'junegunn/fzf' nocompile pick"$ZPFX/bin/fzf" src'key-bindings.zsh' \
  dl"$FZF_REPO/shell/"{"completion.zsh -> _fzf_completion","key-bindings.zsh -> key-bindings.zsh"} \
  dl"$FZF_REPO/man/man1/"{"fzf-tmux.1 -> $ZPFX/man/man1/fzf-tmux.1","fzf.1 -> $ZPFX/man/man1/fzf.1"} for \
    @junegunn/fzf
export FZF_DEFAULT_COMMAND="
      fd --type f --hidden --follow --exclude .git \
      || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git'  || find ."
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
#=== OH-MY-ZSH ===============================================
zi {'is-snippet svn','is-snippet'} for OMZ::plugins/{'git','/git/git.plugin.zsh'}
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip

zi wait lucid for \
	OMZL::{'clipboard','completion','grep'}.zsh \
  OMZP::{'vi-mode','brew','fzf'}
#  zi loafor OMZP::brew
#=== BINARIES ==========================================
zturbo for \
  bindmap='!" " -> magic-space; !"^ " -> globalias' nocompletions pick'plugins/globalias/globalias.plugin.zsh' \
    ohmyzsh/ohmyzsh \
  atload'zstyle '"':completion:*:default'"' list-colors "${(s.:.)LS_COLORS}"' atpull'%atclone' atclone'
      [[ -z ${commands[dircolors]} ]] && local P=${${(M)OSTYPE##darwin}:+g};
      ${P}sed -i '"'/DIR/c\DIR 38;5;63;1'"' LS_COLORS; ${P}dircolors -b LS_COLORS >! clrs.zsh' \
  pick'clrs.zsh' reset nocompile'!' \
    @trapd00r/LS_COLORS \
  light-mode \
    zdharma-continuum/fast-syntax-highlighting \
  light-mode trackbinds bindmap'^R -> ^Z' atinit"
      zstyle :history-search-multi-word page-size 10
      zstyle :history-search-multi-word highlight-color fg=red,bold
      zstyle :plugin:history-search-multi-word reset-prompt-protect 1" \
    zdharma-continuum/history-search-multi-word \
  is-snippet svn submods'zsh-users/zsh-history-substring-search -> external' trackbinds \
  bindmap'^[[A -> history-substring-search-up' bindmap'^[[B -> history-substring-search-down' \
    PZTM::history-substring-search
#=== MISC. =============================================
zturbo svn is-snippet for \
  submods'zsh-users/zsh-autosuggestions -> external' PZT::modules/autosuggestions \
  submods'zsh-users/zsh-completions -> external'     PZT::modules/completion
zturbo from'gh-r' as"command" for \
  sbin'**/bat   -> bat'           @sharkdp/bat       \
  sbin'**/delta -> delta'         dandavison/delta   \
  sbin'**/fd    -> fd'            @sharkdp/fd        \
  sbin'**/grex  -> grex'          pemistahl/grex     \
  sbin'**/rg    -> rg'            BurntSushi/ripgrep \
  sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
  sbin'shfmt*       -> shfmt'     bpick"${bpick}" @mvdan/sh         \
  sbin'**/git-sizer -> git-sizer' bpick"${bpick}" @github/git-sizer \
  sbin"**/bin/nvim  -> nvim"      bpick"${bpick}" \
  atload"export EDITOR='nvim' && alias v=$EDITOR" neovim/neovim \
  sbin'**/exa -> exa' atclone'cp -vf completions/exa.zsh _exa'  \
  atload"
      alias ls='exa --git --group-directories-first'
      alias l='ls -blF' && alias la='ls -abghilmu'
      alias ll='ls -al' && alias tree='exa --tree'" \
    ogham/exa
