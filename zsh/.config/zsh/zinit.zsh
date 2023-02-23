#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== ZINIT ============================================
typeset -gAH ZI=(HOME_DIR $HOME/.local/share/zinit)
ZI+=(
  BIN_DIR "$ZI[HOME_DIR]/zinit.git" COMPLETIONS_DIR "$ZI[HOME_DIR]/completions" OPTIMIZE_OUT_OF_DISK_ACCESSES "0"
  PLUGINS_DIR "$ZI[HOME_DIR]/plugins" SNIPPETS_DIR "$ZI[HOME_DIR]/snippets" ZCOMPDUMP_PATH "${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
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
zi id-as is-snippet nocompletions light-mode compile light-mode for \
  {PZTM::environment,OMZL::{compfix,git,key-bindings,completion}.zsh}
# zi as'completion' for OMZP::{'golang/_golang','pip/_pip'}
# #=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for  as'completion' has"${1}" depth'1' light-mode nocompile id-as"${1}-completion/_${1}" is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'exa' 'ogham/exa/master/completions/zsh'
# # znippet 'fd' 'sharkdp/fd/master/contrib/completion'
znippet 'brew' 'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
zi  as'completion' light-mode nocompile is-snippet for \
  "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh" \
  "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
zi null compile'(pure|async).zsh' id-as multisrc'(pure|async).zsh'  atinit"
    PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    PURE_PROMPT_SYMBOL='$(hostname -s) ᐳ'; PURE_PROMPT_VICMD_SYMBOL='$(hostname -s) ᐸ'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'blue'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'cyan'
    zstyle ':prompt:pure:prompt:success' color 'green'" for \
  @sindresorhus/pure
#=== ANNEXES ==========================================
zi id-as ver'style/logging' light-mode depth'1' for @${ZI[SRC]}/zinit-annex-{linkman,binary-symlink,patch-dl}
zi id-as depth'1' for @${ZI[SRC]}/zinit-annex-{submods,default-ice}
#=== GITHUB BINARIES ==================================
zi default-ice --quiet from'gh-r' light-mode lbin'!' nocompile
zi null id-as light-mode for @{dandavison/delta,r-darwish/topgrade,sharkdp/fd}
# zi lman  from'gh-r' id-as lbin'!' nocompile for @{trufflesecurity/trufflehog,dandavison/delta,r-darwish/topgrade}
zi lman completions id-as lbin'!' light-mode as'program' for \
    dl="$(print -c https://raw.githubusercontent.com/junegunn/fzf/master/{shell/{'key-bindings.zsh;','completion.zsh -> _fzf;'},man/{'man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1;','man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;'}})" \
    src'key-bindings.zsh' \
  @junegunn/fzf \
  null ver'nightly' atinit'for i (v vi vim); do alias $i="nvim"; done' lbin'!**/nvim -> nvim' \
  @neovim/neovim \
    atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
zi default-ice --clear --quiet
zi default-ice --quiet light-mode depth'1'
# alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'
#=== UNIT TESTING =====================================
zi ice id-as null make lbin'!'; zi light vladdoster/zunit
zi ice id-as nocompile mv'*completion -> _revolver' lbin'!'; zi light molovo/revolver
zi lucid wait'0a' light-mode id-as completions for \
    null make'PREFIX=${ZI[PLUGINS_DIR]}/zshelldoc --always-make' lbin'!build/zsd*' \
  @zdharma-continuum/zshelldoc \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
  @vladdoster/plugin-zinit-aliases
#=== MISC. ============================================
zi lucid wait'0b' id-as light-mode depth'1' for \
    svn submods'zsh-users/zsh-history-substring-search -> external' \
  OMZP::history-substring-search \
    atpull'zinit creinstall -q .' blockf null \
  zsh-users/zsh-completions \
    svn submods'zsh-users/zsh-completions -> external' \
  PZTM::completion \
    atload'!_zsh_autosuggest_start' atinit'bindkey "^_" autosuggest-execute;bindkey "^ " autosuggest-accept;' \
  zsh-users/zsh-autosuggestions

zi ice lucid wait'0c' depth'1' atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' atpull'%atclone' compile'.*fast*~*.zwc'
zi light "${ZI[FORK]:-${ZI[SRC]}}"/fast-syntax-highlighting

autoload select-word-style
select-word-style normal
# these characters do _not_ separate words but are part of words
zstyle ':zle:*' word-chars '*?[]~;!#$%^(){}<>'

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
