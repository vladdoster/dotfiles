#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== HELPER METHODS ===================================
error() { builtin print -P "%F{red}[ERROR]%f: %F{yellow}$1%f" && return 1; }
info() { builtin print -P "%F{blue}[INFO]%f: %F{cyan}$1%f"; }
# print -P "[ERROR]: $1" print -P "[INFO]: $1"
#=== ZINIT ============================================
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZI_FORK='vladdoster'; ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
if [[ ! -e $ZINIT[BIN_DIR] ]] {
  info 'downloading zinit'
  command git clone https://github.com/$ZI_REPO/zinit.git --branch "maint/update-configure-ice" $ZINIT[BIN_DIR] \
    || error 'failed to clone zinit repository'
  builtin chmod g-rwX $ZINIT[HOME_DIR] \
    && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
    && info 'sucessfully installed zinit'
}
if [[ -e $ZINIT[BIN_DIR]/zinit.zsh ]]; then
  builtin source $ZINIT[BIN_DIR]/zinit.zsh \
    && autoload -Uz _zinit \
    && (( ${+_comps} )) \
    && _comps[zinit]=_zinit
else
  error "unable to find 'zinit.zsh'" && return 1
fi
#=== STATIC ZSH BINARY =======================================
zi \
  as"null" \
  atclone"./install -e no -d ~/.local" \
  atinit"export PATH=$HOME/.local/bin:$PATH" \
  atpull"%atclone" \
  depth"1" \
  lucid \
  nocompile \
  nocompletions \
  for @romkatv/zsh-bin
# #=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi is-snippet for \
  OMZL::{'clipboard','compfix','completion','git','grep','key-bindings'}.zsh \
  OMZP::{'brew','npm'} \
  PZT::modules/{'history','rsync'}
zi as'completion' for \
  OMZP::{'golang/_golang','pip/_pip','terraform/_terraform'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
install_completion() { zinit for as'completion' nocompile id-as"$1" is-snippet "$GH_RAW_URL/$2"; }
install_completion 'brew-completion/_brew'          'Homebrew/brew/master/completions/zsh/_brew'
install_completion 'brew-completion/_brew-services' 'Homebrew/homebrew-services/master/completions/zsh/_brew_services'
install_completion 'docker-completion/_docker' 'docker/cli/master/contrib/completion/zsh/_docker'
install_completion 'exa-completion/_exa'       'ogham/exa/master/completions/zsh/_exa'
install_completion 'fd-completion/_fd'         'sharkdp/fd/master/contrib/completion/_fd'
#=== PROMPT ===========================================
zi light-mode for \
  compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
zstyle ':prompt:pure:git:action' color 'yellow'
zstyle ':prompt:pure:git:branch' color 'blue'
zstyle ':prompt:pure:git:dirty' color 'red'
zstyle ':prompt:pure:path' color 'cyan'
zstyle ':prompt:pure:prompt:success' color 'green'" \
  sindresorhus/pure
#=== zsh-vim-mode cursor configuration [[[
MODE_CURSOR_VICMD="green block";              MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_INDICATOR_REPLACE='%F{9}%F{1}REPLACE%f'; MODE_INDICATOR_VISUAL='%F{12}%F{4}VISUAL%f'
MODE_INDICATOR_VIINS='%F{15}%F{8}INSERT%f';   MODE_INDICATOR_VICMD='%F{10}%F{2}NORMAL%f'
MODE_INDICATOR_VLINE='%F{12}%F{4}V-LINE%f';   MODE_CURSOR_SEARCH="#ff00ff blinking underline"
export KEYTIMEOUT=1; export LESS='-RMs'; export PAGER=less; export VISUAL=vi;
# LC_CTYPE=en_US.UTF-8; LC_ALL=en_US.UTF-8
#=== ANNEXES ==========================================
zi light-mode for "$ZI_REPO"/zinit-annex-{'bin-gem-node','binary-symlink','patch-dl','submods'}
zi light-mode ver'style/format-zsh' for "$ZI_REPO"/zinit-annex-readurl
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' nocompile for \
  @{'dandavison/delta','junegunn/fzf','koalaman/shellcheck','pemistahl/grex'} \
  @{'r-darwish/topgrade','sharkdp/fd','sharkdp/hyperfine','itchyny/gojq'} \
  blockf atclone'**/bin/gh completion --shell zsh > _gh' lbin'!**/bin/gh' @cli/cli \
  bpick'*extended*' @gohugoio/hugo \
  lbin'!* -> checkmake' @mrtazz/checkmake \
  lbin'!* -> jq'     @stedolan/jq \
  lbin'!* -> shfmt'  @mvdan/sh \
  lbin'!* -> stylua' @JohnnyMorganz/StyLua  \
  lbin'!**/rg'       @BurntSushi/ripgrep \
  lbin'!**/bin/nvim' @neovim/neovim \
  lbin'!**/exa' atinit"alias l='exa -blF'; alias la='exa -abghilmu'; alias ll='exa -al'; alias ls='exa --git --group-directories-first'" \
  @ogham/exa
#=== UNIT TESTING =====================================
zi as'command' for \
  pick'src/semver' vladdoster/semver-tool \
  pick'revolver' @molovo/revolver \
  atclone'./build.zsh' pick'zunit' @zdharma-continuum/zunit
#=== COMPILED PROGRAMS ================================
  # configure'--disable-lzmadec --disable-lzmainfo' \
  # lbin'!$PWD/**/bin/xz' \
# zi configure'--prefix=$PWD' make'-j PREFIX=$PWD install' nocompile for \
# zi for configure'#--disable-utf8proc' extract'!' from'gh-r' ver'latest' nocompile as'null' lbin'!**/bin/tmux' make'install' \
#   @tmux/tmux
#
# zi for configure'#' nocompile as'null' lbin'!**/bin/stow' make'install' \
#   @aspiers/stow
#
zi configure'#--prefix=$PWD' nocompile as'null' make'PREFIX=$PWD install' for \
  lbin'!**/tree' \
  @Old-Man-Programmer/tree \
  lbin'!$PWD/**/zsd*$' \
  ${ZI_REPO}/zshelldoc

# zi \
  #   as'completions' \
  #   atclone'./buildx* completion zsh > _buildx' \
  #   from'gh-r' \
  #   lbin'!buildx-* -> buildx' \
  #   nocompile \
  #   for @docker/buildx

# zi \
  #   as'completion' \
  #   atclone'luarocks completion zsh > _luarocks' \
  #   lucid \
  #   nocompile \
  #   for $ZI_REPO/null
#=== PYTHON ===========================================
_pip_completion() {
  local words cword; read -Ac words; read -cn cword
  reply=($(
      COMP_WORDS="$words[*]"
      COMP_CWORD=$(( cword-1 )) PIP_AUTO_COMPLETE=1 $words 2>/dev/null
))}; compctl -K _pip_completion pip3
#=== MISC. ============================================
zi light-mode lucid wait'1' for \
  atinit'bindkey -M vicmd "^v" edit-command-line' \
  compile'zsh-vim-mode*.zsh' \
  softmoth/zsh-vim-mode \
  thewtex/tmux-mem-cpu-load \
  submods'zsh-users/zsh-history-substring-search -> external' \
  svn \
  OMZ::plugins/history-substring-search \
  atpull'zinit creinstall -q .' \
  blockf \
  zsh-users/zsh-completions \
  atload'_zsh_autosuggest_start' \
  atinit'\
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50;\
  bindkey "^_" autosuggest-execute;\
  bindkey "^ " autosuggest-accept' \
  zsh-users/zsh-autosuggestions \
  atinit'bindkey "^R" history-search-multi-word' \
  $ZI_REPO/history-search-multi-word \
  atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
  atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
  compile'.*fast*~*.zwc' nocompletions \
  $ZI_REPO/fast-syntax-highlighting

zi \
  as'null' \
  atload'_zsh_autosuggest_bind_widgets; _zsh_highlight_bind_widgets; zicompinit; zicdreplay' \
  id-as'zinit/cleanup' \
  lucid \
  nocd \
  wait'2' \
  for @$ZI_REPO/null

# vim:ft=zsh:sw=2:sts=2:et
