# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== ZINIT ============================================
typeset -gAH ZI=(HOME_DIR "$HOME/.local/share/zinit")
ZI+=(
  BIN_DIR "$ZI[HOME_DIR]"/zinit.git
  BRANCH 'main'
  COMPINIT_OPTS '-C'
  COMPLETIONS_DIR "$ZI[HOME_DIR]"/completions
  DEBUG "1"
  OPTIMIZE_OUT_OF_DISK_ACCESSES '1'
  PLUGINS_DIR "$ZI[HOME_DIR]"/plugins
  SNIPPETS_DIR "$ZI[HOME_DIR]"/snippets
  SRC 'zdharma-continuum'
  ZCOMPDUMP_PATH "$ZI[HOME_DIR]"/zcompdump
  ZPFX "$ZI[HOME_DIR]"/polaris
)
if [[ ! -e $ZI[BIN_DIR]/zinit.zsh ]]; then
  {
    log::info 'downloading zinit'
    command git clone --branch ${ZI[BRANCH]:-main} \
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
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew'   'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
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
zi light-mode for @"${ZI[SRC]}/zinit-annex-"{'linkman','patch-dl','submods','binary-symlink','bin-gem-node'}
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' light-mode nocompile for \
  @dandavison/delta \
  @sharkdp/hyperfine \
  @topgrade-rs/topgrade \
    dl'https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1' lman \
  @junegunn/fzf \
    aliases \
    atload"!(){setopt no_aliases;alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
    if'[[ $VENDOR != apple ]]' \
  @eza-community/eza \
    aliases \
    atload"!(){setopt no_aliases;alias l='exa -blF';alias la='exa -abghilmu';alias ll='exa -al';alias ls='exa --git --group-directories-first';}" \
    if'[[ $VENDOR = apple ]]' \
  @ogham/exa \
    aliases \
    atload'!(){local i;for i (v vi vim);do alias $i="nvim";done; }' \
    if"[[ ! ${(L)OSTYPE}$(arch) =~ linux.*a(arch|rm)* ]]" \
    lbin'!nvim' \
    nocompletions \
    ver'nightly' \
  @neovim/neovim

zinit snippet OMZ::lib/git.zsh
zinit snippet OMZP::git

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00dd00,fg=#002b36,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#dd0000=#002b36,bold'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'

typeset -ga zle_highlight=(
  # region:fg="#a89983",bg="#4c96a8"
  isearch:underline
  paste:none
  region:standout
  special:standout
  suffix:bold
)

zinit light-mode for \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
    as'null' lbin'!build/zsd*' make'--always-make' \
  @zdharma-continuum/zshelldoc \
    as'null' atclone'./build.zsh' completions lbin'!' \
  @zdharma-continuum/zunit \
    atload'bindkey "^[[A" history-substring-search-up;bindkey "^[[B" history-substring-search-down' \
  @zsh-users/zsh-history-substring-search \
    compile'h*~*.zwc' \
  @zdharma-continuum/history-search-multi-word

(){
  emulate -LR zsh -o no_aliases
  zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
      @zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
      @zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
      @zsh-users/zsh-completions \
    aliases \
      @vladdoster/plugin-zinit-aliases
}

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
