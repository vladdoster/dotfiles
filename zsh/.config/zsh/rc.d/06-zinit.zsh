#!/usr/bin/env zsh
# vim: et:ft=zsh:sw=4:sts=4:ts=4:
${=zsh_load_info}
#=== ZINIT ============================================
local zi_dir="${HOME}/.local/share/zinit"
alias zic="nvim $0"
typeset -Agx CONFIG=()
CONFIG+=(
  HOME_DIR    "${zi_dir}"         BIN_DIR      "${zi_dir}/zinit.git"
  PLUGINS_DIR "${zi_dir}/plugins" SNIPPETS_DIR "${zi_dir}/snippets"
  SRC         'zdharma-continuum' ZPFX         "${zi_dir}/polaris"
  COMPLETIONS_DIR "${zi_dir}/completions"
    # FORK        'vdoster'           BRANCH       'fork/tmp'
)
# CONFIG+=( DEBUG 'true' )
log::info(){ print -P -- "${@}" }
log::error(){ print -P -- "${@}" }
typeset -A ZINIT=(${(kv)CONFIG})
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
    command chmod g-rwX ${zi_dir} && \
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

# zinit id-as for \
#     atinit='\
#       zstyle ":prompt:pure:git:branch" color "blue"; zstyle ":prompt:pure:git:action" color "yellow";
#       zstyle ":prompt:pure:git:dirty" color "red";   zstyle ":prompt:pure:prompt:success" color "green";
#       zstyle ":prompt:pure:path" color "cyan";
#       PURE_GIT_DOWN_ARROW="%1{↓%}"; PURE_PROMPT_SYMBOL="$HOST %2{ᐳ%}" 
#       PURE_GIT_UP_ARROW="%1{↑%}";   PURE_PROMPT_VICMD_SYMBOL="$HOST %2{ᐸ%}"' \
#     compile='(async|pure).zsh' \
#     multisrc="(async|pure).zsh" \
#     atload='
#       unset prompt_pure_debug_depth;
#       typeset -g PROMPT4="%B[%b%F{yellow}%N%f|%F{green}%e%f|%F{blue}%I%f|%F{cyan}%i%f|%F{magenta}%x%f%B]%b";
#       typeset -ag prompt_pure_debug_depth=()' \
#   @sindresorhus/pure
# typeset -g PROMPT4="%F{yellow}%1N %f: %F{cyan}%i%f %B> %b"

eval "MODE_CURSOR_"{'SEARCH="#ff00ff blinking underline"','VICMD="green block"','VIINS="#ffff00  bar"'}";"

zinit id-as for \
    ver='fix/binary-selection-glob' \
  @zdharma-continuum/zinit-annex-binary-symlink \
  @zdharma-continuum/zinit-annex-{'bin-gem-node','linkman'}

zinit id-as aliases for load @vladdoster/z{'sh','init'}-aliases.plugin.zsh

zinit light-mode id-as aliases from='gh-r' lbin='!' for \
  @dandavison/delta  \
    atload="!(){ setopt no_aliases; alias l='eza -blF';alias la='eza -abghilmu';alias ll='eza -al';alias ls='eza --git --group-directories-first';}" \
  @vladdoster/eza

zinit light-mode depth='1' aliases atload='!(){ setopt no_aliases; local i;for i (v vi vim);do alias $i="nvim";done; export EDITOR="nvim"; }' for \
    id-as='nvim-arm64' \
    if="(( ${${${(m)$(arch):#(arm|aarch)*}:+0}:-1} ))" \
    make \
  @neovim/neovim \
    from='gh-r' \
    id-as='nvim-x86_64' \
    if="(( ${${${(M)$(arch):#(arm|aarch)*}:+0}:-1} ))" \
    lbin='!nvim' \
  @neovim/neovim

(){
  zi from='gh-r' lbin='!' id-as for neovim/neovim
  local i;
  for i (v vi vim);do
    alias $i="nvim";
  done;
  export EDITOR="nvim"
}

zinit from="gh-r" lbin="!" id-as'auto' if'((1))' for \
    'JohnnyMorganz/StyLua' 'junegunn/fzf' '@sharkdp/bat' '@sharkdp/fd' '@sharkdp/hyperfine' '@topgrade-rs/topgrade'

zinit if'(())' build depth='1' for \
    configure='--disable-utf8proc' \
  'tmux/tmux' \
  'bminor/bash' \
  'cmatsuoka/figlet' \
  'jqlang/jq' \
  'vim/vim'

zinit if'(())' cmake for \
  'Koihik/LuaFormatter' \
  'thewtex/tmux-mem-cpu-load'

# null make"prefix=$ZPFX all install" \
#   @zdharma-continuum/zshelldoc \
zinit light-mode id-as for \
    compile atinit='bindkey -M vicmd "^v" edit-command-line' \
  @softmoth/zsh-vim-mode \
    ver='develop' build completions \
  @zdharma-continuum/zunit \
    atload='bindkey "^[[A" history-substring-search-up;bindkey "^[[B" history-substring-search-down' \
  @zsh-users/zsh-history-substring-search \
    atinit='zicompinit; zicdreplay' \
  @zdharma-continuum/fast-syntax-highlighting \
    atload='_zsh_autosuggest_start' \
    atinit="bindkey '^_' autosuggest-execute;bindkey '^ ' autosuggest-accept;" \
    nocd \
  @zsh-users/zsh-autosuggestions \
    blockf atpull='zinit creinstall -q .' \
  @zsh-users/zsh-completions
