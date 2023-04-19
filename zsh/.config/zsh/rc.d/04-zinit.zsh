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
  ZPFX "$ZI[HOME_DIR]/polaris" SRC 'zdharma-continuum' BRANCH 'main'
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
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi snippet OMZP::gnu-utils
zi is-snippet for OMZL::{key-bindings,git}.zsh
zi is-snippet nocompletions light-mode compile for {OMZP::gnu-utils,OMZL::{key-bindings,git}.zsh}
# zi as'completion' for OMZP::{'golang/_golang','pip/_pip'}
# #=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for  as'completion' has"${1}" depth'1' light-mode nocompile is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'brew'   'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
znippet 'exa'    'ogham/exa/master/completions/zsh'
znippet 'fd'     'sharkdp/fd/master/contrib/completion'
zi  as'completion' light-mode nocompile is-snippet for \
  "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
  "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
(( ZPROF )) || {
eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
zinit for compile'(pure|async).zsh' multisrc'(pure|async).zsh'  atinit"
PURE_GIT_DOWN_ARROW='%1{↓%}'; PURE_GIT_UP_ARROW='%1{↑%}'
PURE_PROMPT_SYMBOL='${HOST}%2{ ᐳ%}'; PURE_PROMPT_VICMD_SYMBOL='${HOST}%2{ ᐸ%}'
zstyle ':prompt:pure:git:action' color 'yellow'
zstyle ':prompt:pure:git:branch' color 'blue'
zstyle ':prompt:pure:git:dirty' color 'red'
zstyle ':prompt:pure:path' color 'cyan'
zstyle ':prompt:pure:prompt:success' color 'green'" light-mode \
  @sindresorhus/pure
}
#=== ANNEXES ==========================================
zi light-mode for @${ZI[SRC]}/zinit-annex-{binary-symlink,linkman,patch-dl,submods,bin-gem-node,default-ice}
#=== GITHUB BINARIES ==================================
# autoload -U zargs
# scripts=( @{sharkdp/fd,trufflesecurity/trufflehog,dandavison/delta,r-darwish/topgrade} )
# zi default-ice --quiet from"gh-r" lbin'!' nocompile
# setopt localoptions extendedglob globstarshort nullglob
zi light-mode id-as from'gh-r' lbin'!' null for @{dandavison/delta,r-darwish/topgrade}

zi from'gh-r' light-mode for \
    dl="$(print -c https://raw.githubusercontent.com/junegunn/fzf/master/{shell/{'key-bindings.zsh;','completion.zsh -> _fzf;'},man/{'man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1;','man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;'}})" \
    lbin'!' \
    src'key-bindings.zsh' \
  @junegunn/fzf \
    as'null' atinit'for i (v vi vim); do alias $i="nvim"; done' lbin'!**/nvim -> nvim' ver'nightly' \
  @neovim/neovim \
    lbin'!**/exa -> exa' atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
# for i (v vi vim); do alias $i="nvim"; done
# alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'
#=== UNIT TESTING =====================================
zinit for \
    as'command' \
    atclone'./build.zsh' \
    light-mode \
    nocompile \
    pick'zunit' \
  @zdharma-continuum/zunit

zi ice nocompile mv'*completion -> _revolver' lbin'!'; zi light molovo/revolver
zi lucid wait'!' light-mode completions for \
  null make'PREFIX=${ZI[PLUGINS_DIR]}/zshelldoc --always-make' lbin'!build/zsd*' \
  @zdharma-continuum/zshelldoc \
  atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
  @vladdoster/plugin-zinit-aliases

# zinit ice id-as lucid blockf wait as"completion"
# zinit snippet https://github.com/zsh-users/zsh-completions/blob/master/src/_git-flow

#=== MISC. ============================================
# zinit wait lucid for \
  #   atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  #   zdharma-continuum/fast-syntax-highlighting \
  #   blockf \
  #   zsh-users/zsh-completions \
  #   atload"!_zsh_autosuggest_start" \
  #   zsh-users/zsh-autosuggestions
  # atpull'zinit creinstall -q .' blockf \

  # zsh-users/zsh-completions \
zi wait lucid for \
    has'svn' svn submods'zsh-users/zsh-history-substring-search -> external' \
  OMZP::history-substring-search \
  zsh-users/zsh-autosuggestions \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    atload'{ zicompinit; zicdreplay }&!' \
    atpull'%atclone' \
    compile'.*fast*~*.zwc' \
  "${ZI[FORK]:-${ZI[SRC]}}/fast-syntax-highlighting"

# bindkey "^_" autosuggest-execute;bindkey "^ " autosuggest-accept;

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
