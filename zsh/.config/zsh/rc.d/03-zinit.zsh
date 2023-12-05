#!/usr/bin/env zsh
# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
#
# zdharma-continuum/zinit config for macOS/Linux arm64/x86_64
#
#=== ZINIT ============================================
local zi_dir="${HOME}/.local/share/zinit"
typeset -gAH ZINIT=()
ZINIT+=(
  BIN_DIR "${zi_dir}/zinit.git"
  COMPINIT_OPTS '-C'
  COMPLETIONS_DIR "${zi_dir}/completions"
  FORK 'vladdoster'
  HOME_DIR "${zi_dir}"
  PLUGINS_DIR "${zi_dir}/plugins"
  REPO 'zinit-t' 
  SNIPPETS_DIR "${zi_dir}/snippets"
  SRC 'zdharma-continuum'
  ZCOMPDUMP_PATH "${zi_dir}/zcompdump"
  ZPFX "${zi_dir}/polaris"
)
local ZI_REPO="${ZINIT[FORK]:-${ZINIT[SRC]}}/${ZINIT[REPO]:-zinit}"
if [[ ! -e $ZINIT[BIN_DIR]/zinit.zsh ]]; then
  {
    log::info "cloning %B${ZI_REPO}%b to %B${(D)ZINIT[BIN_DIR]}%b"
    command git clone \
      --branch "${ZINIT[BRANCH]:-main}" \
      --quiet \
      "https://github.com/${ZI_REPO}" \
      "${ZINIT[BIN_DIR]}"
    log::info 'setting up zinit'
    command chmod g-rwX ${ZINIT[HOME_DIR]} && \
      zcompile "${ZINIT[BIN_DIR]}/zinit.zsh"
    log::info 'installed zinit'
  } || log::error 'failed to download zinit'
fi
if [[ -e "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
  builtin source "${ZINIT[BIN_DIR]}/zinit.zsh" && \
    autoload _zinit && \
    (( ${+_comps} )) && \
    _comps[zinit]=_zinit
else
  log::error 'failed to find zinit installation'
  return 1
fi
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
# znippet() { zi for as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
# znippet 'brew'   'Homebrew/brew/master/completions/zsh'
zi as'completion' id-as'auto' is-snippet light-mode for \
  "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh"
#   "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
zinit aliases id-as for @vladdoster/z{init,sh}-aliases.plugin.zsh
#=== PROMPT ===========================================
(( MINIMAL )) || {
  eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
  zinit for compile'(async|pure).zsh' multisrc'(async|pure).zsh' light-mode atinit"
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
zi light-mode for @"${ZINIT[SRC]}/zinit-annex-"{'linkman','patch-dl','submods'}
zi light-mode ver'feat/logging' for @"${ZINIT[SRC]}/zinit-annex-binary-symlink"
#=== GITHUB BINARIES ==================================
zi aliases from'gh-r' lbin'!' light-mode lman for \
  @sharkdp/hyperfine \
  @topgrade-rs/topgrade \
  @dandavison/delta \
    dl'https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1' \
  @junegunn/fzf \
    atload"!(){setopt no_aliases;alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
    if'[[ $VENDOR != apple ]]' \
  @eza-community/eza \
    atload"!(){setopt no_aliases;alias l='exa -blF';alias la='exa -abghilmu';alias ll='exa -al';alias ls='exa --git --group-directories-first';}" \
    if'[[ $VENDOR = apple ]]' \
  @ogham/exa \
    atload'!(){local i;for i (v vi vim);do alias $i="nvim";done; export EDITOR="nvim"; }' \
    if"[[ ! ${(L)OSTYPE}$(arch) =~ linux.*a(arch|rm)* ]]" \
    nocompletions \
    ver'nightly' \
  @neovim/neovim

  # atload'!(){local i;for i (v vi vim);do alias $i="nvim";done; export EDITOR="nvim"; }' \
  #   @neovim/neovim


# zi snippet OMZP::colored-man-pages
# zi snippet OMZ::lib/git.zsh
# zi snippet OMZP::git

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00dd00,fg=#002b36,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#dd0000=#002b36,bold'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'
typeset -ga zle_highlight=( isearch:underline paste:none region:standout special:standout suffix:bold )

zi light-mode for \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
    null make"prefix=$ZPFX all install" \
  @zdharma-continuum/zshelldoc \
    as'null' completions atclone'./build.zsh' lbin'!' \
  @zdharma-continuum/zunit \
    atload'bindkey "^[[A" history-substring-search-up;bindkey "^[[B" history-substring-search-down' \
    light-mode \
  @zsh-users/zsh-history-substring-search \
    compile'h*~*.zwc' \
    light-mode \
  @zdharma-continuum/history-search-multi-word

(){
  # emulate -LR zsh -o no_aliases


  zinit wait light-mode lucid for \
    atinit"zicompinit; zicdreplay" \
      @zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
      @zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
      @zsh-users/zsh-completions
}
