#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== ZINIT ============================================
typeset -gAH ZI=(HOME_DIR $HOME/.local/share/zinit)
ZI+=(
  BIN_DIR "$ZI[HOME_DIR]/zinit.git" COMPLETIONS_DIR "$ZI[HOME_DIR]/completions" OPTIMIZE_OUT_OF_DISK_ACCESSES "1"
  PLUGINS_DIR "$ZI[HOME_DIR]/plugins" SNIPPETS_DIR "$ZI[HOME_DIR]/snippets" ZCOMPDUMP_PATH "${ZINIT[HOME_DIR]}/zcompdump"
  ZPFX "$ZI[HOME_DIR]/polaris" SRC 'zdharma-continuum' BRANCH 'main' COMPINIT_OPTS '-C'
)
ZSH_CACHE_DIR=$ZINIT[ZCOMPDUMP_PATH]
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
  typeset -gAH ZINIT=( ${(kv)ZI} )
  builtin source ${ZINIT[BIN_DIR]}/zinit.zsh && \
    autoload _zinit && \
    (( ${+_comps} )) && \
    _comps[zinit]=_zinit
else
  log::error 'failed to find zinit installation'
fi

#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for  as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew'   'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
znippet 'exa'    'ogham/exa/master/completions/zsh'
znippet 'fd'     'sharkdp/fd/master/contrib/completion'
zi as'completion' is-snippet light-mode for \
  "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
  "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
(( MINIMAL )) || {
    eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
    zinit for light-mode compile'(async|pure).zsh' multisrc'(async|pure).zsh' atinit"
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
zi light-mode for @"${ZI[SRC]}/zinit-annex-"{'linkman','patch-dl','submods','binary-symlink'}
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
(( $+commands[svn] )) && (){
  local -a f=({git,history,key-bindings}'.zsh')
  zi ice atinit'typeset -grx HIST{FILE=$ZDOTDIR/zsh-history,SIZE=9999999}' compile'(k|g|h)*.zsh' light-mode multisrc'$f[@]' svn
  zi snippet OMZ::lib

  zi ice submods'zsh-users/zsh-history-substring-search -> external' svn load
  zi snippet OMZP::history-substring-search
}
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' light-mode no'compile' for \
  @dandavison/delta \
  @r-darwish/topgrade \
  @sharkdp/hyperfine \
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
zi lucid wait'!' light-mode for \
    compile \
  @vladdoster/plugin-zinit-aliases \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
    lbin'!build/zsd*' \
    make'--always-make' \
  @zdharma-continuum/zshelldoc \
    as'command' \
    lbin'!' \
    nocompile \
  @shellspec/shellmetrics \
    as'command' \
    lbin'!' \
  @shellspec/altshfmt \
    as'null' \
    atclone'./build.zsh' \
    completions \
    lbin'!' \
  @zdharma-continuum/zunit
#=== MISC. ============================================
  zinit light-mode lucid wait for \
 atinit" zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
