#!/usr/bin/env zsh
# vim: set et ft=zsh sw=2 sts=2 ts=2 tw=100:
#=== ZINIT ============================================
if (( $#NO_ZINIT )); then
  unset NO_ZINIT
  log::info 'NO_ZINIT set, skipping zinit'
  return 0
fi

typeset zi_dir="${HOME}/.local/share/zinit"

typeset -A ZINIT=(
  HOME_DIR "${zi_dir}" BIN_DIR "${zi_dir}/zinit.git"
  COMPLETIONS_DIR "${zi_dir}/completions" PLUGINS_DIR "${zi_dir}/plugins"
  SNIPPETS_DIR "${zi_dir}/snippets" ZPFX "${zi_dir}/polaris"
  SRC 'zdharma-continuum'
  # BRANCH 'fork/tmp' FORK 'vdoster' DEBUG 'true'
)
typeset ZI_REPO="${ZINIT[FORK]:-${ZINIT[SRC]}}/${ZINIT[REPO]:-zinit}"
if [[ ! -e $ZINIT[BIN_DIR]/zinit.zsh ]]; then
  log::info "cloning ${ZI_REPO} to ${(D)ZINIT[BIN_DIR]}"
  command git clone \
    --branch "${ZINIT[BRANCH]:-main}" \
    --quiet \
    "https://github.com/${ZI_REPO}" \
    "${ZINIT[BIN_DIR]}" \
    && command chmod g-rwX ${zi_dir} \
    && zcompile "${ZINIT[BIN_DIR]}/zinit.zsh" \
    && log::info 'installed zinit' \
    || log::error 'failed to install zinit'
fi
unset zi_dir ZI_REPO
if [[ -e "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
  builtin source "${ZINIT[BIN_DIR]}/zinit.zsh"
else
  log::error 'failed to find zinit installation'
  return 1
fi

typeset -gx DISABLE_MAGIC_FUNCTIONS=true
MODE_CURSOR_SEARCH="#ff00ff blinking underline"
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#ffff00 bar"

zi id-as for \
    ver'fix/binary-selection-glob' \
  @zdharma-continuum/zinit-annex-binary-symlink \
  @zdharma-continuum/zinit-annex-{'bin-gem-node','linkman'}

zi id-as aliases for load @vladdoster/z{'sh','init'}-aliases.plugin.zsh
# zsh-aliases defines alias zdd, which would shadow functions/zdd
(( ${+aliases[zdd]} )) && unalias zdd

zi id-as aliases for \
    from'gh-r' lbin'!' \
  @dandavison/delta \
    nocompile atload"!(){ setopt no_aliases; alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
  @zdharma-continuum/null

zi from'gh-r' lbin'!' lman id-as for @JohnnyMorganz/StyLua

zi id-as for @NICHOLAS85/z-a-eval
zi lucid id-as for \
    as"completion" \
    id-as'claude-code-completion' \
  @wbingli/zsh-claudecode-completion \
    atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
  @zsh-users/zsh-autosuggestions \
    from'gh-r' \
    lbin'!' \
    eval'zsh-patina activate' \
  @michel-kraemer/zsh-patina \
    make \
  @zdharma-continuum/zshelldoc \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
    compile \
  @softmoth/zsh-vim-mode \
    build \
    completions \
    ver'feat/run-tests-in-parallel-support' \
  @zdharma-continuum/zunit \
    atload'bindkey "^[[A" history-substring-search-up;bindkey "^[[B" history-substring-search-down' \
  @zsh-users/zsh-history-substring-search \
    eval'gdircolors -b LS_COLORS' \
  @trapd00r/LS_COLORS
