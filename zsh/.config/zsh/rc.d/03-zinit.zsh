#!/usr/bin/env zsh
# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
#=== ZINIT ============================================
local zi_dir="${HOME}/.local/share/zinit"
hash -d zinit="${HOME}/.local/share/zinit"
hash -d zpfx="${HOME}/.local/share/zinit/polaris"
typeset -gxAUH CONFIG=()
CONFIG+=(
  BIN_DIR         ~zinit/zinit.git    COMPINIT_OPTS  '-C'
  COMPLETIONS_DIR ~zinit/completions  SNIPPETS_DIR   ~zinit/snippets
  HOME_DIR        ~zinit              PLUGINS_DIR    ~zinit/plugins
  SRC             'zdharma-continuum' ZCOMPDUMP_PATH ~zinit/zcompdump
)
# CONFIG+=( DEBUG 'true')
typeset -gAHx ZINIT=(${(kv)CONFIG})
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
    command chmod g-rwX ~zinit && \
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
eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
if [[ -z $ZINIT[DEBUG] ]]; then
  zi for compile'(async|pure).zsh' multisrc'(async|pure).zsh' light-mode atinit"
    PURE_GIT_DOWN_ARROW='%1{↓%}'; PURE_GIT_UP_ARROW='%1{↑%}'
    PURE_PROMPT_SYMBOL='${HOST}%2{ ᐳ%}'; PURE_PROMPT_VICMD_SYMBOL='${HOST}%2{ ᐸ%}'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'blue'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'cyan'
    zstyle ':prompt:pure:prompt:success' color 'green'" \
  @sindresorhus/pure
fi
# #=== COMPLETIONS ======================================
# local GH_RAW_URL='https://raw.githubusercontent.com'
# znippet() { zi for as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
# znippet 'brew'   'Homebrew/brew/master/completions/zsh'
# zi as'completion' id-as'auto' is-snippet light-mode for \
#   "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
#   "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
# zi ver'feat/logging' for load @zdharma-continuum/zinit-annex-binary-symlink
# zi for load @zdharma-continuum/zinit-annex-bin-gem-node
# zinit for \
#       from'gh-r' \
#       sbin'* -> tldr' \
#   @dbrgn/tealdeer \
#       as'completion' \
#       id-as'tealdeer/_tldr' \
#       is-snippet \
#   https://raw.githubusercontent.com/dbrgn/tealdeer/main/completion/zsh_tealdeer
# return 0
zi aliases for @vladdoster/z{init,sh}-aliases.plugin.zsh
# #=== ANNEXES ==========================================
zi for @"${ZINIT[SRC]}/zinit-annex-"{'linkman','patch-dl','submods','bin-gem-node'}
# zi load @"${ZINIT[SRC]}/zinit-annex-binary-symlink"
zi ver'feat/logging' for load @"${ZINIT[SRC]}/zinit-annex-binary-symlink"
# #=== GITHUB BINARIES ==================================
zi aliases from'gh-r' lbin'!' light-mode lman for \
  @sharkdp/hyperfine \
   atload'!(){local i;for i (v vi vim);do alias $i="nvim";done; export EDITOR="nvim"; }' \
  @topgrade-rs/topgrade \
    dl'https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1' \
  @junegunn/fzf \
    atload"!(){setopt no_aliases;alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
    if'[[ $VENDOR != apple ]]' \
  @eza-community/eza \
    atload"!(){setopt no_aliases;alias l='exa -blF';alias la='exa -abghilmu';alias ll='exa -al';alias ls='exa --git --group-directories-first';}" \
    if'[[ $VENDOR = apple ]]' \
  @ogham/exa
zi for \
    from'gh-r' \
    sbin'delta' \
  @dandavison/delta
zi for \
    atload'!(){local i;for i (v vi vim);do alias $i="nvim";done; export EDITOR="nvim"; }' \
    cmake \
    depth'1' \
  @neovim/neovim

# zi snippet OMZP::colored-man-pages
# zi snippet OMZ::lib/git.zsh
# zi snippet OMZP::git

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00dd00,fg=#002b36,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#dd0000=#002b36,bold'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'
typeset -ga zle_highlight=( isearch:underline paste:none region:standout special:standout suffix:bold )
#
zi for \
    compile atinit'bindkey -M vicmd "^v" edit-command-line' light-mode \
  @softmoth/zsh-vim-mode \
    null make"prefix=$ZPFX all install" \
  @zdharma-continuum/zshelldoc \
    as'null' atclone'./build.zsh' lbin'!' \
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
