#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== HELPER METHODS ===================================
error() { builtin print -P "%F{red}[ERROR]%f: %F{yellow}$1%f" && return 1; }
info() { builtin print -P "%F{blue}[INFO]%f: %F{cyan}$1%f"; }
#=== ZINIT ============================================
typeset -gAH ZI=(HOME_DIR "$HOME/.local/share/zinit")
ZI+=(
  BIN_DIR "$ZI[HOME_DIR]/zinit.git" COMPLETIONS_DIR "$ZI[HOME_DIR]/completions" OPTIMIZE_OUT_OF_DISK_ACCESSES "1"
  PLUGINS_DIR "$ZI[HOME_DIR]/plugins" SNIPPETS_DIR "$ZI[HOME_DIR]/snippets" ZCOMPDUMP_PATH "$ZI[HOME_DIR]/zcompdump"
)
ZI_FORK='vladdoster'; ZI_REPO='zdharma-continuum'; ZPFX=$ZI[HOME_DIR]/polaris
if [[ ! -e $ZI[BIN_DIR]/zinit.zsh ]] {
  info 'downloading zinit' \
    && command git clone "https://github.com/$ZI_REPO/zinit.git" $ZI[BIN_DIR]
  info 'setting up zinit' \
    && command chmod g-rwX $ZI[HOME_DIR] \
    && zcompile $ZI[BIN_DIR]/zinit.zsh \
    && info 'sucessfully installed zinit'
}
if [[ -e $ZI[BIN_DIR]/zinit.zsh ]] {
  typeset -gAH ZINIT=( ${(kv)ZI} ) \
    && builtin source $ZINIT[BIN_DIR]/zinit.zsh \
    && autoload -Uz _zinit \
    && (( ${+_comps} )) \
    && _comps[zinit]=_zinit
} else { error 'failed to find zinit installation' }
#=== STATIC ZSH BINARY =======================================
# #=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi nocompletions is-snippet for OMZL::{'compfix','completion','git'}.zsh
zi nocompletions is-snippet for PZT::modules/{'environment','history','rsync'}
zi as'completion' for OMZP::{'golang/_golang','pip/_pip','terraform/_terraform'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for as'completion' has"${1}" nocompile id-as"${1}-completion/_${1}" is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew' 'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
znippet 'exa' 'ogham/exa/master/completions/zsh'
znippet 'fd' 'sharkdp/fd/master/contrib/completion'
# znippet 'brew_services' 'Homebrew/homebrew-services/master/completions/zsh'
#=== PROMPT ===========================================
zi ice as'null' compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
zstyle ':prompt:pure:git:action' color 'yellow'
zstyle ':prompt:pure:git:branch' color 'blue'
zstyle ':prompt:pure:git:dirty' color 'red'
zstyle ':prompt:pure:path' color 'cyan'
zstyle ':prompt:pure:prompt:success' color 'green'"
zi light @sindresorhus/pure
#=== zsh-vim-mode cursor configuration [[[
#
eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
# export MODE_INDICATOR_{'V'{'IINS=%F{15}%F{8}INSERT%f','ICMD=%F{10}%F{2}NORMAL%f','LINE="%F{12}%F{4}V-LINE%f"','VISUAL=%F{12}%F{4}VISUAL%f'},'REPLACE=%F{9}%F{1}REPLACE%f'}
#=== ANNEXES ==========================================
for ANNEX (bin-gem-node binary-symlink submods readurl); do zi load @zdharma-continuum/zinit-annex-${ANNEX}; done
zi ice ver'fix/correct-logic-bug'; zi load @zdharma-continuum/zinit-annex-patch-dl
zinit ice \
    as"command" \
    atclone"./configure --prefix=$ZPFX" \
    atpull"%atclone" \
    dl"https://aur.archlinux.org/cgit/aur.git/plain/0001-Fix-build-with-gcc-6.patch?h=fbterm-git" \
    dl"https://bugs.archlinux.org/task/46860?getfile=13513 -> ins.patch" \
    make"install" \
    patch"ins.patch;0001-Fix-build-with-gcc-6.patch" \
    pick"$ZPFX/bin/fbterm" \
    reset
zinit load izmntuk/fbterm
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' nocompile for \
  @{'dandavison/delta','junegunn/fzf','koalaman/shellcheck','pemistahl/grex','r-darwish/topgrade','sharkdp/'{'fd','hyperfine'}} \
  lbin'!* -> checkmake' @mrtazz/checkmake \
  lbin'!* -> jq'     @stedolan/jq \
  lbin'!* -> shfmt'  @mvdan/sh \
  lbin'!**/rg'       @BurntSushi/ripgrep \
  lbin'!**/exa' atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
  zinit ice from'gh-r' ver'nightly' nocompletions atinit'for i (v vi vim); do alias $i="nvim"; done' nocompile lbin'!**/nvim -> nvim'
zinit load @neovim/neovim
#=== UNIT TESTING =====================================
zi ice as'command' atclone'./build.zsh' pick'zunit'; zi load @zdharma-continuum/zunit
zi ice nocompile atinit'bindkey -M vicmd "^v" edit-command-line'; zi light @softmoth/zsh-vim-mode
#=== MISC. ============================================
zi lucid wait load for \
  @thewtex/tmux-mem-cpu-load \
  svn submods'zsh-users/zsh-history-substring-search -> external' \
  @OMZ::plugins/history-substring-search \
  svn submods'zsh-users/zsh-completions -> external' \
  atpull'zinit creinstall -q .' blockf \
  @PZTM::completion \
  atload'_zsh_autosuggest_start' atinit'\
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
  bindkey "^_" autosuggest-execute
  bindkey "^ " autosuggest-accept' \
  zsh-users/zsh-autosuggestions \
  atinit'bindkey "^R" history-search-multi-word' \
  $ZI_REPO/history-search-multi-word \
  atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
  atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
  compile'.*fast*~*.zwc' nocompletions \
  $ZI_REPO/fast-syntax-highlighting
