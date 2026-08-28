#!/usr/bin/env zsh
# vim: ft=zsh sw=2 ts=2 et
#=== ZINIT ============================================
# (){
# return 0
if (( $#NO_ZINIT )); then
  unset NO_ZINIT
  log::info 'NO_ZINIT set, skipping zinit'
  return 0
fi

local zi_dir="${HOME}/.local/share/zinit"
alias zic="$EDITOR $0"

typeset -A ZINIT=(
  HOME_DIR "${zi_dir}" BIN_DIR "${zi_dir}/zinit.git"
  COMPLETIONS_DIR "${zi_dir}/completions" PLUGINS_DIR "${zi_dir}/plugins"
  SNIPPETS_DIR "${zi_dir}/snippets" ZPFX "${zi_dir}/polaris"
  SRC 'zdharma-continuum'
  # BRANCH 'fork/tmp' FORK 'vdoster' DEBUG 'true'
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
    command chmod g-rwX ${zi_dir} \
      && zcompile "${ZINIT[BIN_DIR]}/zinit.zsh"
    log::info 'installed zinit'
  } || log::error 'failed to download zinit'
fi
if [[ -e "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
  builtin source "${ZINIT[BIN_DIR]}/zinit.zsh" \
    && autoload _zinit \
    && ((${+_comps})) \
    && _comps[zinit]=_zinit
else
  log::error 'failed to find zinit installation'
  return 1
fi

eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"

zi id-as for \
    ver'fix/binary-selection-glob' \
  @zdharma-continuum/zinit-annex-binary-symlink \
  @zdharma-continuum/zinit-annex-{'bin-gem-node','linkman'}

zi id-as aliases for load @vladdoster/z{'sh','init'}-aliases.plugin.zsh

zi id-as aliases for \
    from'gh-r' lbin'!' \
  @dandavison/delta \
    nocompile atload"!(){ setopt no_aliases; alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
  @zdharma-continuum/null
  # @vladdoster/eza

# zinit light-mode depth=1 for \
#     id-as'nvim-arm64' \
#     if"(( ${${${(m)$(arch):#(arm|aarch)*}:+0}:-1} ))" \
#     make \
#   @neovim/neovim \
#     from'gh-r' \
#     id-as'nvim-x86_64' \
#     if"(( ${${${(M)$(arch):#(arm|aarch)*}:+0}:-1} ))" \
#     lbin'!nvim' \
#   @neovim/neovim

#       as'program' \
# zinit id-as for \
#       compile'revolver' \
#       pick'revolver' \
#   @molovo/revolver \
#       ver'fix/zsh-completion' \
#   @vladdoster/zshfmt

# zinit ver'develop' id-as for \
#   @vladdoster/zshfmt
# as'program' \
# compile'revolver' \
# pick'revolver' \
# @molovo/revolver \
#       null \
#   @zdharma-continuum/zinit-vim-syntax

zi if'(())' from'gh-r' lbin'!' lman for \
    id-as if'((1))' \
  @JohnnyMorganz/StyLua \
  @junegunn/fzf \
  @sharkdp/bat @sharkdp/fd @sharkdp/hyperfine \
  @topgrade-rs/topgrade

# https://unix.stackexchange.com/a/453153/143394

# 'zinit' 'snippet' 'OMZ::plugins/git';
# 'zinit' 'snippet' 'OMZ::lib/git.zsh';
# zinit is-snippet for @OMZ{'::lib/git.zsh',P::{'colored-man-pages','extract'}}

# 'zinit' 'id-as' 'for' 'load' 'DerBunman/bzcurses';

# 'zinit' if'(())' 'build' 'depth=1' 'id-as' 'for' \
#       'configure=--disable-utf8proc' \
#   'tmux/tmux' \
#   'bminor/bash' \
#   'cmatsuoka/figlet' \
#   'jqlang/jq' \
#   'vim/vim'

zi if'(())' cmake for \
  @Koihik/LuaFormatter \
  @thewtex/tmux-mem-cpu-load

# export ZSH_CACHE_DIR=$ZINIT[HOME_DIR]
# zinit ice as'completion' wait'1' atinit"mv $ZSH_CACHE_DIR/completions/_kubectl -> $PWD/OMZP::kubectl/_kubectl; ln -sfv $PWD/OMZP::kubectl/_kubectl $ZSH_CACHE_DIR/completions/_kubectl"
# zi snippet OMZP::kubectl

#     atload'print hello' \
#     as'null' \
#     id-as'hello' \
#   @zdharma-continuum/null

# compinit -d ${ZDOTDIR}/.zcompdump

# zinit ice wait'0' lucid depth=1 atload"autoload -Uz compinit && compinit -u" atpull"zinit cclear && zinit creinstall sainnhe/zsh-completions"
# zinit light sainnhe/zsh-completions

zi id-as for @NICHOLAS85/z-a-eval
zi lucid id-as for \
    as"completion" \
    id-as'claude-code-completion' \
  @wbingli/zsh-claudecode-completion \
    atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
  @zsh-users/zsh-autosuggestions \
    from'gh-r' \
    lbin'!' \
    eval"zsh-patina activate" \
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
    eval"gdircolors -b LS_COLORS" \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
  @trapd00r/LS_COLORS

# zi id-as lucid wait for \
#     atpull'zinit creinstall -q .' \
#     blockf \
#     completions \
#   @zsh-users/zsh-completions
# zi id-as for \
#     as'completion' \
#   @wbingli/zsh-claudecode-completion \
#     atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
#   @zsh-users/zsh-autosuggestions \
#   @NICHOLAS85/z-a-eval \
#     eval'zsh-patina activate' \
#     from'gh-r' \
#     lbin'!' \
#   @michel-kraemer/zsh-patina \
#     atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
#     eval"dircolors -b LS_COLORS" \
#   @trapd00r/LS_COLORS \
#     make \
#   @zdharma-continuum/zshelldoc \
#     atinit'bindkey -M vicmd "^v" edit-command-line' \
#     compile \
#   @softmoth/zsh-vim-mode \
#     build \
#     completions \
#     ver'feat/run-tests-in-parallel-support' \
#   @zdharma-continuum/zunit \
#     atload'bindkey "^[[A" history-substring-search-up;bindkey "^[[B" history-substring-search-down' \
#   @zsh-users/zsh-history-substring-search
  #   atdelete'zinit cuninstall zsh-completions' \
  #   atpull'zinit creinstall -q .' \
  #   atload"zicompinit; zicdreplay" \
  #   blockf \
  # @zsh-users/zsh-completions



#   atpull'zinit creinstall -q .' \
#   blockf \
# @zsh-users/zsh-completions \
#   atinit'zicompinit; zicdreplay' \
# @zdharma-continuum/fast-syntax-highlighting \
#   atload'_zsh_autosuggest_start' \
#   atinit"bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
# @zsh-users/zsh-autosuggestions

#   id-as'hsmw-compile-ice' \
# compile'h*~*zwc' \
#   @zdharma-continuum/history-search-multi-word \
#   id-as'hsmw-no-compile-ice' \
#   @zdharma-continuum/history-search-multi-word \
# }
