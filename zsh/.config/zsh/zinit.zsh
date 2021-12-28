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
autoload -U +X bashcompinit && bashcompinit
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
ZINIT_REPO="zdharma-continuum"
FZF_REPO="https://raw.githubusercontent.com/junegunn/fzf/master"
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
#=== ZSH-STATIC =======================================
zinit for \
  lucid as"null" depth"1" atclone"./install -e yes -d /usr/local" \
  atpull"%atclone" nocompile nocompletions \
    @romkatv/zsh-bin
#  zinit for \
  #  as'null' atclone'./install -e no -d ~/.local' atpull'%atclone' \
  #  depth'1' git id-as'romkatv/zsh-bin' lucid nocompile nocompletions \
    #  @romkatv/zsh-bin
#=== FZF ==============================================
zturbo 0a for \
  as'command' atclone'mkdir -p $ZPFX/bin; cp -vf fzf $ZPFX/bin' atpull'%atclone' \
  from'gh-r' id-as'junegunn/fzf' lucid nocompile pick'$ZPFX/bin/fzf' src'key-bindings.zsh' \
  dl'
      https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -> _fzf_completion;
      https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -> key-bindings.zsh;
      https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/man/man1/fzf-tmux.1;
      https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/man/man1/fzf.1' \
    @junegunn/fzf \
  light-mode \
    @Aloxaf/fzf-tab
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|v):*' fzf-preview 'exa -1 --color=always ${realpath}'
zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|v):*' popup-pad 30 0
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line enter
export FZF_DEFAULT_COMMAND="
        fd --type f --hidden --follow --exclude .git \
          || git ls-tree -r --name-only HEAD \
          || rg --files --hidden --follow --glob '!.git' \
          || find ."
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
#=== GIT ===============================================
zi ice svn; zi snippet OMZ::plugins/git
zi snippet OMZ::plugins/git/git.plugin.zsh
#=== OSX ===============================================
zi ice if'[[ $OSTYPE = darwin* ]]' svn; zi snippet PZTM::gnu-utility
#=== PIP ===============================================
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip
#=== MISC. =============================================
zinit ice svn submods'zsh-users/zsh-autosuggestions -> external'
zinit snippet PZT::modules/autosuggestions
  #  is-snippet svn submods'zsh-users/zsh-autosuggestions -> external' \
    #  PZTM::autosuggestions \
zturbo 1a for \
  atload'zstyle '\'':completion:*:default'\'' list-colors "${(s.:.)LS_COLORS}";' \
  atpull'%atclone' git id-as'trapd00r/LS_COLORS' lucid nocompile'!' pick'clrs.zsh' \
  reset atclone'
     [[ -z ${commands[dircolors]} ]] \
      && local P=${${(M)OSTYPE##darwin}:+g};
      ${P}sed -i '\''/DIR/c\DIR 38;5;63;1'\'' LS_COLORS;
      ${P}dircolors -b LS_COLORS >! clrs.zsh' \
    @trapd00r/LS_COLORS \
  is-snippet svn submods'zsh-users/zsh-completions -> external' \
    PZTM::completion \
  light-mode \
    zdharma-continuum/fast-syntax-highlighting \
  is-snippet svn atload'
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down' \
  submods'zsh-users/zsh-history-substring-search -> external' \
    PZTM::history-substring-search \
    OMZP::vi-mode
#=== BINARIES ==========================================
zturbo 2a from"gh-r" as'program' for \
    pick'git-sizer'    bpick"${bpick}"  @github/git-sizer \
    pick'grex'         pemistahl/grex
zturbo 3a from'gh-r' as"command" for \
    mv'bat* bat'             sbin'**/bat -> bat'             @sharkdp/bat       \
    mv"delta* delta"         sbin'**/delta -> delta'         dandavison/delta   \
    mv'fd* fd'               sbin'**/fd -> fd'               @sharkdp/fd        \
    mv'hyperfine* hyperfine' sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
    mv'rip* ripgrep'         sbin'**/rg -> rg'               BurntSushi/ripgrep \
    mv'shfmt* shfmt'         sbin'**/shfmt -> shfmt'         bpick"${bpick}"    @mvdan/sh \
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
