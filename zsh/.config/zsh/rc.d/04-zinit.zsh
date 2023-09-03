#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== ZINIT ============================================
# OPTIMIZE_OUT_OF_DISK_ACCESSES "1"
typeset -gAH ZI=(HOME_DIR "$HOME/.local/share/zinit")
ZI+=(
  BIN_DIR "$ZI[HOME_DIR]"/zinit.git
  BRANCH 'main'
  COMPLETIONS_DIR "$ZI[HOME_DIR]"/completions
  PLUGINS_DIR "$ZI[HOME_DIR]"/plugins
  SNIPPETS_DIR "$ZI[HOME_DIR]"/snippets
  SRC 'zdharma-continuum'
  ZCOMPDUMP_PATH "$ZI[HOME_DIR]"/zcompdump
  ZPFX "$ZI[HOME_DIR]"/polaris
)
mkdir -p "$ZI[ZCOMPDUMP_PATH]" || true
# ZSH_CACHE_DIR=$ZINIT[ZCOMPDUMP_PATH]
if [[ ! -e $ZI[BIN_DIR]/zinit.zsh ]]; then
  {
    log::info 'downloading zinit'
    command git clone \
      --branch ${ZI[BRANCH]:-main} \
      https://github.com/${ZI[FORK]:-${ZI[SRC]}}/zinit.git \
      ${ZI[BIN_DIR]}
    log::info 'setting up zinit'
    command chmod g-rwX ${ZI[HOME_DIR]} && \
      zcompile "${ZI[BIN_DIR]}/zinit.zsh"
    log::info 'installed zinit'
  } || log::error 'failed to download zinit'
fi
if [[ -e ${ZI[BIN_DIR]}/zinit.zsh ]]; then
  typeset -gAH ZINIT=(${(kv)ZI})
  builtin source ${ZINIT[BIN_DIR]}/zinit.zsh && \
    autoload _zinit && \
    (( ${+_comps} )) && \
    _comps[zinit]=_zinit
else
  log::error 'failed to find zinit installation'
fi
#=== STATIC ZSH BINARY ======================================
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew'   'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
znippet 'exa'    'ogham/exa/master/completions/zsh'
znippet 'fd'     'sharkdp/fd/master/contrib/completion'
zi as'completion' id-as'auto' is-snippet light-mode for \
  "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
  "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
(( MINIMAL )) || {
    eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
    zinit for compile'(async|pure).zsh' multisrc'(async|pure).zsh' atinit"
      PURE_GIT_DOWN_ARROW='%1{↓%}'; PURE_GIT_UP_ARROW='%1{↑%}'
      PURE_PROMPT_SYMBOL='${HOST}%2{ ᐳ%}'; PURE_PROMPT_VICMD_SYMBOL='${HOST}%2{ ᐸ%}'
      zstyle ':prompt:pure:git:action' color 'yellow'
      zstyle ':prompt:pure:git:branch' color 'blue'
      zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'
      zstyle ':prompt:pure:prompt:success' color 'green'" \
  @sindresorhus/pure
}
#=== ANNEXES ==========================================
zi id-as'auto' for @"${ZI[SRC]}/zinit-annex-"{'linkman','patch-dl','submods','binary-symlink','bin-gem-node'}
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
# (( $+commands[svn] )) && (){
#   local -a f=({functions,git,history,key-bindings,termsupport}'.zsh')
#   zi ice atinit'typeset -grx HIST{FILE=$ZDOTDIR/zsh-history,SIZE=9999999}' compile'(k|g|h)*.zsh' multisrc'$f[@]' svn
#   zi snippet OMZ::lib
  # zi for has'svn' svn submods'zsh-users/zsh-history-substring-search -> external' light-mode \
  # @OMZ::plugins/history-substring-search
# }
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' light-mode nocompile for \
  @dandavison/delta \
  @r-darwish/topgrade \
  @sharkdp/hyperfine \
    cp'**/exa.zsh->_exa' \
    atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa \
    src'key-bindings.zsh' \
    compile'key-bindings.zsh' \
    dl="$(builtin print -c -- https://raw.githubusercontent.com/junegunn/fzf/master/{shell/{'key-bindings.zsh;','completion.zsh -> _fzf;'},man/{'man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1;','man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;'}})" \
  @junegunn/fzf \
    atinit'for i (v vi vim); do alias $i="nvim"; done' \
    lbin'!nvim' \
    ver'nightly' \
  @neovim/neovim
#=== UNIT TESTING =====================================
# oh-my-zsh plugins
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZP::git

# https://github.com/zdharma/zinit-configs/blob/a60ff64823778969ce2b66230fd8cfb1a957fe89/psprint/zshrc.zsh#L277
# Fast-syntax-highlighting & autosuggestions
zinit light-mode for \
  @vladdoster/plugin-zinit-aliases \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
    as'null' \
    lbin'!build/zsd*' \
    make'--always-make' \
  @zdharma-continuum/zshelldoc \
    as'null' \
    atclone'./build.zsh' \
    lbin'!' \
  @zdharma-continuum/zunit

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00dd00,fg=#002b36,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#dd0000=#002b36,bold'

zinit wait lucid light-mode nocd for \
  zsh-users/zsh-history-substring-search \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
  atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
#=== MISC. ============================================
zle_highlight=('paste:fg=white,bg=black')

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2: