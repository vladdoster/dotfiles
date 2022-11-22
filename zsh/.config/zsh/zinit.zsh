#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== HELPER METHODS ===================================
error() { builtin print -P "%F{red}[ERROR]%f: %F{yellow}$1%f" && return 1; }
info() { builtin print -P "%F{white}[INFO]%f: %F{cyan}$1%f"; }
#=== ZINIT ============================================
typeset -gAH ZI=(HOME_DIR $HOME/.local/share/zinit)
ZI+=(
    BIN_DIR "$ZI[HOME_DIR]/zinit.git" COMPLETIONS_DIR "$ZI[HOME_DIR]/completions" OPTIMIZE_OUT_OF_DISK_ACCESSES "1"
    PLUGINS_DIR "$ZI[HOME_DIR]/plugins" SNIPPETS_DIR "$ZI[HOME_DIR]/snippets" ZCOMPDUMP_PATH "$ZI[HOME_DIR]/zcompdump"
    ZPFX "$ZI[HOME_DIR]/polaris" REPO 'zdharma-continuum'
)

if [[ ! -e $ZI[BIN_DIR]/zinit.zsh ]] {
    {
        info 'downloading zinit' && \
            command git clone https://github.com/$ZI[REPO]/zinit.git $ZI[BIN_DIR] && \
            info 'setting up zinit' && \
            command chmod g-rwX $ZI[HOME_DIR] && \
            zcompile $ZI[BIN_DIR]/zinit.zsh && \
            info 'sucessfully installed zinit'
    } || error 'failed to download zinit'
}
if [[ -e $ZI[BIN_DIR]/zinit.zsh ]] {
    typeset -gAH ZINIT=( ${(kv)ZI} ) \
        && builtin source $ZINIT[BIN_DIR]/zinit.zsh \
        && autoload +X -Uz _zinit \
        && (( ${+_comps} )) \
        && _comps[zinit]=_zinit
} else { error 'failed to find zinit installation' }
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi is-snippet light-mode nocompletions for {PZT::modules/{'environment','history'},OMZL::{'compfix','completion','git','key-bindings'}.zsh}
# zi is-snippet light-mode nocompletions for OMZL::{'compfix','completion','git','key-bindings'}.zsh
zi as'completion' for OMZP::{'golang/_golang','pip/_pip'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for light-mode as'completion' has"${1}" nocompile id-as"${1}-completion/_${1}" is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew' 'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
znippet 'exa' 'ogham/exa/master/completions/zsh'
znippet 'fd' 'sharkdp/fd/master/contrib/completion'
zi light-mode as'completion' nocompile is-snippet for \
    "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
    "${GH_RAW_URL}/oven-sh/bun/main/completions/bun.zsh" \
    "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
# eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
zi for as'null' compile'(pure|async).zsh' multisrc'(pure|async).zsh' light-mode atinit"
PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
zstyle ':prompt:pure:git:action' color 'yellow'
zstyle ':prompt:pure:git:branch' color 'blue'
zstyle ':prompt:pure:git:dirty' color 'red'
zstyle ':prompt:pure:path' color 'cyan'
zstyle ':prompt:pure:prompt:success' color 'green'" \
    @sindresorhus/pure
#=== zsh-vim-mode cursor configuration [[[
#=== ANNEXES ==========================================
zi ver'style/rename-funcs' light-mode for @zdharma-continuum/zinit-annex-{'patch-dl','binary-symlink','submods'}
#=== GITHUB BINARIES ==================================
zbin(){ zi for from'gh-r' lbin"!* -> $(basename ${1})" nocompile light-mode "@${1}"; }
zbin "stedolan/jq"

zi from'gh-r' lbin'!' nocompile light-mode for \
    @{'dandavison/delta','pemistahl/grex','r-darwish/topgrade','sharkdp/'{'fd','hyperfine'}}

zi light-mode from'gh-r' nocompile for \
    lbin'!**/exa' atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
    @ogham/exa \
    lbin'!**/nvim -> nvim' ver'nightly' nocompletions atinit'for i (v vi vim); do alias $i="nvim"; done' \
    @neovim/neovim
#=== UNIT TESTING =====================================
zi ice as'command' atclone'./build.zsh' pick'zunit'; zi light @zdharma-continuum/zunit
zi ice wait lucid nocompletions nocompile atinit'bindkey -M vicmd "^v" edit-command-line'; zi light @softmoth/zsh-vim-mode
#=== MISC. ============================================
zi lucid wait light-mode for \
    svn submods'zsh-users/zsh-history-substring-search -> external' \
    @OMZ::plugins/history-substring-search \
    atpull'zinit creinstall -q .' blockf \
    zsh-users/zsh-completions \
    svn submods'zsh-users/zsh-completions -> external' \
    @PZTM::completion \
    atload'!_zsh_autosuggest_start' atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50; bindkey "^_" autosuggest-execute; bindkey "^ " autosuggest-accept;' \
    zsh-users/zsh-autosuggestions \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
    compile'.*fast*~*.zwc' nocompletions \
    $ZI[REPO]/fast-syntax-highlighting

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
