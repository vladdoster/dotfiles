#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
# #=== HELPER METHODS ===================================
# error() { builtin print -P "%F{red}[ERROR]%f: %F{yellow}$1%f" && return 1; }
# info() { builtin print -P "%F{blue}[INFO]%f: %F{cyan}$1%f"; }
# # print -P "[ERROR]: $1" print -P "[INFO]: $1"
# #=== ZINIT ============================================
# typeset -gAH ZINIT;
# ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
# ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
# ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
# ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
# ZI_FORK='vladdoster'; ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
# if [[ ! -e $ZINIT[BIN_DIR] ]] {
#   info 'downloading zinit'
#   command git clone https://github.com/$ZI_REPO/zinit.git $ZINIT[BIN_DIR] \
#     || error 'failed to clone zinit repository'
#   builtin chmod g-rwX $ZINIT[HOME_DIR] \
#     && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
#     && info 'sucessfully installed zinit'
# }
# if [[ -e $ZINIT[BIN_DIR]/zinit.zsh ]]; then
#   builtin source $ZINIT[BIN_DIR]/zinit.zsh \
#     && autoload -Uz _zinit \
#     && (( ${+_comps} )) \
#     && _comps[zinit]=_zinit
# else
#   error "unable to find 'zinit.zsh'" && return 1
# fi
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
if [[ ! -e "$ZI[BIN_DIR]/zinit.zsh" ]] {
  info 'downloading zinit' \
    && command rm -rf $ZI[BIN_DIR] \
    && command git clone "https://github.com/$ZI_REPO/zinit.git" $ZI[BIN_DIR]
  info 'setting up zinit' \
    && command chmod g-rwX $ZI[HOME_DIR] \
    && zcompile $ZI[BIN_DIR]/zinit.zsh \
    && info 'sucessfully installed zinit'
}
# } else { error 'failed to install zinit' }
if [[ -e "$ZI[BIN_DIR]/zinit.zsh" ]] {
  typeset -gAH ZINIT=( ${(kv)ZI} ) \
    && builtin source $ZINIT[BIN_DIR]/zinit.zsh \
    && autoload -Uz _zinit \
    && (( ${+_comps} )) \
    && _comps[zinit]=_zinit
} else { error 'failed to find zinit installation' }
#=== STATIC ZSH BINARY =======================================
zi for \
  as"null" \
  atclone"./install -e no -d ${ZPFX}" \
  depth"1" \
  lucid \
  nocompile \
  nocompletions \
  @romkatv/zsh-bin
# #=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi is-snippet for \
  OMZL::{'clipboard','compfix','completion','git','grep','key-bindings'}.zsh \
  OMZP::{'brew','npm'} \
  PZT::modules/{'history','rsync'}
zi as'completion' for \
  OMZP::{'golang/_golang','pip/_pip','terraform/_terraform'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zinit for as'completion' has"${1}" nocompile id-as"${1}-completion/_${1}" is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew'          'Homebrew/brew/master/completions/zsh'
# znippet 'brew_services' 'Homebrew/homebrew-services/master/completions/zsh'
znippet 'docker'        'docker/cli/master/contrib/completion/zsh'
znippet 'exa'           'ogham/exa/master/completions/zsh'
znippet 'fd'            'sharkdp/fd/master/contrib/completion'
#=== PROMPT ===========================================
zi for as'null' light-mode compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
    PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'blue'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'cyan'
    zstyle ':prompt:pure:prompt:success' color 'green'" \
  @sindresorhus/pure
#=== zsh-vim-mode cursor configuration [[[
MODE_CURSOR_VICMD="green block";              MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_INDICATOR_REPLACE='%F{9}%F{1}REPLACE%f'; MODE_INDICATOR_VISUAL='%F{12}%F{4}VISUAL%f'
MODE_INDICATOR_VIINS='%F{15}%F{8}INSERT%f';   MODE_INDICATOR_VICMD='%F{10}%F{2}NORMAL%f'
MODE_INDICATOR_VLINE='%F{12}%F{4}V-LINE%f';   MODE_CURSOR_SEARCH="#ff00ff blinking underline"
export PAGER=less; export VISUAL=vi;
(( $+commands[locale] )) || return
local loc=(${(@M)$(locale -a):#*.(utf|UTF)(-|)8})
(( $#loc )) || return
export LC_ALL=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}}
#=== ANNEXES ==========================================
zi light-mode for "$ZI_REPO"/zinit-annex-{'bin-gem-node','binary-symlink','patch-dl','submods','readurl'}
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' nocompile for \
  @{'dandavison/delta','junegunn/fzf','koalaman/shellcheck','pemistahl/grex'} \
  @{'r-darwish/topgrade','sharkdp/fd','sharkdp/hyperfine'} \
  lbin'!* -> checkmake' @mrtazz/checkmake \
  lbin'!* -> jq'     @stedolan/jq \
  lbin'!* -> shfmt'  @mvdan/sh \
  lbin'!**/rg'       @BurntSushi/ripgrep \
  sbin'**/bin/nvim' ver'nightly' atinit'alias v=nvim; alias vim=nvim' @neovim/neovim \
  lbin'!**/exa' atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
#=== UNIT TESTING =====================================
zi as'command' for \
  pick'src/semver' vladdoster/semver-tool \
  pick'revolver' @molovo/revolver \
  atclone'./build.zsh' pick'zunit' @zdharma-continuum/zunit
#=== COMPILED PROGRAMS ================================
zi configure nocompile as'null' make'PREFIX=$PWD' for \
  lbin'!**/tree' \
  @Old-Man-Programmer/tree \
  lbin'!$PWD/**/zsd*$' \
  ${ZI_REPO}/zshelldoc

#=== MISC. ============================================
zi light-mode lucid wait'1' for \
  atinit'bindkey -M vicmd "^v" edit-command-line' \
  compile'zsh-vim-mode*.zsh' \
  softmoth/zsh-vim-mode \
  thewtex/tmux-mem-cpu-load \
  MichaelAquilina/zsh-auto-notify \
  submods'zsh-users/zsh-history-substring-search -> external' \
  svn \
  OMZ::plugins/history-substring-search \
  atpull'zinit creinstall -q .' \
  blockf \
  zsh-users/zsh-completions \
  atload'_zsh_autosuggest_start' \
  atinit'\
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50;\
  bindkey "^_" autosuggest-execute;\
  bindkey "^ " autosuggest-accept' \
  zsh-users/zsh-autosuggestions \
  atinit'bindkey "^R" history-search-multi-word' \
  $ZI_REPO/history-search-multi-word \
  atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
  atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
  compile'.*fast*~*.zwc' nocompletions \
  $ZI_REPO/fast-syntax-highlighting
#=== PYTHON ===========================================
_pip_completion() {
  local words cword; read -Ac words; read -cn cword
  reply=($(COMP_WORDS="$words[*]" COMP_CWORD=$(( cword-1 )) PIP_AUTO_COMPLETE=1 $words 2>/dev/null))
};
zi for \
  as'null' \
  atload'( _zsh_autosuggest_bind_widgets && _zsh_highlight_bind_widgets && zicompinit && zicdreplay ) &>/dev/null' \
  id-as'zinit/cleanup' \
  lucid \
  nocd \
  wait'2' \
  @${ZI_REPO}/null
# vim:ft=zsh:sw=2:sts=2:et
