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
  PLUGINS_DIR "$ZI[HOME_DIR]/plugins" SNIPPETS_DIR "$ZI[HOME_DIR]/snippets" ZCOMPDUMP_PATH "${ZDOTDIR:-$HOME/.config/zsh}/zcompdump"
  ZPFX "$ZI[HOME_DIR]/polaris" SRC 'zdharma-continuum' BRANCH 'main'
)

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
    autoload +X -Uz _zinit && \
    (( ${+_comps} )) && \
    _comps[zinit]=_zinit
else
  log::error 'failed to find zinit installation'
fi
#=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi id-as is-snippet light-mode nocompletions compile for {PZTM::{environment,history},OMZL::{compfix,completion,git,key-bindings}.zsh}
# zi as'completion' for OMZP::{'golang/_golang','pip/_pip'}
# #=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
znippet() { zi for light-mode as'completion' has"${1}" nocompile id-as"${1}-completion/_${1}" is-snippet "${GH_RAW_URL}/${2}/_${1}"; }
znippet 'exa' 'ogham/exa/master/completions/zsh'
# # znippet 'fd' 'sharkdp/fd/master/contrib/completion'
znippet 'brew' 'Homebrew/brew/master/completions/zsh'
znippet 'docker' 'docker/cli/master/contrib/completion/zsh'
# zi light-mode as'completion' nocompile is-snippet for \
  #   "${GH_RAW_URL}/git/git/master/contrib/completion/git-completion.zsh"
#   "${GH_RAW_URL}/Homebrew/homebrew-services/master/completions/zsh/_brew_services"
#=== PROMPT ===========================================
zmodload zsh/nearcolor; colors
eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"
zi null compile'(pure|async).zsh' multisrc'(pure|async).zsh' light-mode atinit"
    PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    PURE_PROMPT_SYMBOL=' ᐳ'; PURE_PROMPT_VICMD_SYMBOL=' ᐸ'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'cyan'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'magenta'
    zstyle ':prompt:pure:prompt:success' color 'green'" for \
  @sindresorhus/pure
# PROMPT="\033[48:2:255:165:0m%s\033[m\n%m "$PROMPT
setopt PROMPTSUBST
PROMPT=$(print "\e[38;5;208m%m\e[0m\e[1m${PROMPT}\e[22m")
# PROMPT="$(print '\e[38;5;208m%m'$PROMPT)"
#\033[48:2:255:165:0m%s\033[m\n
#=== ANNEXES ==========================================
zi light-mode ver'style/logging' for @${ZI[SRC]}/zinit-annex-{linkman,binary-symlink,patch-dl}
zi light-mode for @${ZI[SRC]}/zinit-annex-{submods,default-ice}
#=== GITHUB BINARIES ==================================
zi default-ice --quiet from"gh-r" id-as lbin"!" nocompile
zi null light-mode for @{dandavison/delta,r-darwish/topgrade,sharkdp/fd}
# zi lman light-mode from'gh-r' id-as lbin'!' nocompile for @{trufflesecurity/trufflehog,dandavison/delta,r-darwish/topgrade}
# zi from'gh-r' nocompile id-as lbin for Swordfish90/cool-retro-term
zi light-mode lman as'completions' for \
    dl="$(print -c https://raw.githubusercontent.com/junegunn/fzf/master/{shell/{'key-bindings.zsh;','completion.zsh -> _fzf;'},man/{'man1/fzf.1 -> $ZPFX/share/man/man1/fzf.1;','man1/fzf-tmux.1 -> $ZPFX/share/man/man1/fzf-tmux.1;'}})" \
    src'key-bindings.zsh' \
  @junegunn/fzf \
    atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
zi default-ice --clear --quiet
#   atinit'for i (v vi vim); do alias $i="nvim"; done' \
  #   lbin'!**/nvim -> nvim' \
  # @neovim/neovim \
# alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'
#=== UNIT TESTING =====================================
#   lbin'!zsd*' make"install" \
  # @zdharma-continuum/zshelldoc \
zi light-mode lucid wait'0a' for \
    null make"PREFIX=${ZPFX} install" \
  @zdharma-continuum/zshelldoc \
    as'command' atclone'./build.zsh' lbin'!' ver'main' \
  @zdharma-continuum/zunit \
    atinit'bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode 
  #     null lbin'!bin/tig' configure make'install' \
  #   @jonas/tig \
  #=== MISC. ============================================
zi lucid wait'0b' light-mode nocompile for \
    svn submods'zsh-users/zsh-history-substring-search -> external' \
  OMZP::history-substring-search \
    atpull'zinit creinstall -q .' blockf null \
  zsh-users/zsh-completions \
    svn submods'zsh-users/zsh-completions -> external' \
  PZTM::completion \
    atload'!_zsh_autosuggest_start' atinit'bindkey "^_" autosuggest-execute;bindkey "^ " autosuggest-accept;' \
  zsh-users/zsh-autosuggestions \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' atpull'%atclone' compile'.*fast*~*.zwc' \
  @${ZI[FORK]:-zdharma-continuum}/fast-syntax-highlighting

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
