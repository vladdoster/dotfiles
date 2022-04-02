#!/usr/bin/env zsh

# reduce verbiage
zi light zdharma-continuum/zinit-annex-default-ice
zi default-ice lucid from'gh-r' lbin nocompile

# zi sbin'**/bat -> bat' for @sharkdp/bat
# zi sbin'**/delta -> delta' for dandavison/delta
# zi sbin'**/f*g' for @chanzuckerberg/fogg
# zi sbin'**/fx* -> fx' for @antonmedv/fx
# zi sbin'**/gh' for cli/cli
# zi sbin'**/git-mkver' for @idc101/git-mkver
# zi sbin'**/glow' for charmbracelet/glow
# zi sbin'**/h*e -> hyperfine' for @sharkdp/hyperfine
# zi sbin'**/lazygit' for jesseduffield/lazygit
# zi sbin'**/nvim -> nvim' ver'nightly' for neovim/neovim
# zi sbin'**/procs -> procs' for @dalance/procs
# zi sbin'**/rg -> rg' for @BurntSushi/ripgrep
# zi sbin'**/sh* -> shfmt' for @mvdan/sh
# zi sbin'**/starship -> starship' for @starship/starship
# zi sbin'**/t*i -> tokei' for @XAMPPRocky/tokei
# zi sbin'**/volta' for volta-cli/volta
# zi sbin'checkmake* -> checkmake' for mrtazz/checkmake
# zi sbin'fzf' for @junegunn/fzf
# zi sbin'g*x -> grex' for pemistahl/grex
# zi sbin'git-sizer' for @github/git-sizer

zi for \
  ver'nightly' neovim/neovim \
  @BurntSushi/ripgrep \
  @XAMPPRocky/tokei \
  @antonmedv/fx \
  @chanzuckerberg/fogg \
  @dalance/procs \
  @github/git-sizer \
  @idc101/git-mkver \
  @junegunn/fzf \
  @mvdan/sh \
  @sharkdp/bat \
  @sharkdp/hyperfine \
  @starship/starship \
  charmbracelet/glow \
  cli/cli \
  dandavison/delta \
  jesseduffield/lazygit \
  mrtazz/checkmake \
  pemistahl/grex \
  volta-cli/volta

zi default-ice --clear

# zi for \
#     as'completions' \
#     atclone'./argocd* completion zsh > _argocd' \
#     atpull'%atclone' \
#     if'[[ "$(uname -m)" == x86_64 ]]' \
#     sbin'argocd* -> argocd' \
#   argoproj/argo-cd
#
# zi for \
#     as'program' \
#     atclone"./configure --prefix=$ZPRFX > /dev/null" \
#     atpull'%atclone' \
#     make"-j PREFIX=${ZPRFX} install > /dev/null" \
#     pick"cmatrix" \
#   abishekvashok/cmatrix
#
# zi for \
#     atclone'cp -vf completions/exa.zsh _exa'  \
#     sbin'**/exa -> exa' \
#   ogham/exa
#
# zi for \
#     atclone'cp -vf completions/fd.zsh _fd' \
#     sbin'**/fd -> fd' \
#   @sharkdp/fd
#
# zi for \
#     atclone"
#       autoreconf -fi
#       ./configure --with-oniguruma=builtin
#       make
#       ln -sfv $PWD/jq.1 $ZPFX/man/man1" \
#     atpull'%atclone' \
#     if"(( ${+commands[jq]} == 0 ))" \
#     sbin'jq' \
#   @stedolan/jq
#
# zi for \
#     as'program' \
#     atpull'%atclone' \
#     make"-j PREFIX=${ZPRFX} install > /dev/null" \
#     pick"neofetch" \
#   dylanaraps/neofetch
#
# zi for \
#     as'program' \
#     atclone" autoreconf -iv; ./configure --prefix=$ZPFX" \
#     atpull'%atclone' \
#     make'-j bin/stow' \
#     pick"$ZPFX/bin/stow" \
#   @aspiers/stow
#
# zi for \
#     as"tmux=$ZPFX/tmux" \
#     make'-j' \
#     mv'tmux* -> tmux' \
#     pick'tmux' \
#   @tmux/tmux
#
# zi for \
#     as'null' \
#     atclone'%atpull' \
#     atpull'
#       ./bin/brew update --preinstall \
#       && ln -sf $PWD/completions/zsh/_brew $ZINIT[COMPLETIONS_DIR] \
#       && rm -f brew.zsh \
#       && ./bin/brew shellenv --dummy-arg > brew.zsh \
#       && zcompile brew.zsh' \
#     depth'3' \
#     nocompletions \
#     sbin'bin/brew' \
#     src'brew.zsh' \
#   @homebrew/brew

# zi for \
#     as'completions' \
#     atclone'./argocd* completion zsh > _argocd' \
#     atpull'%atclone' \
#     if'[[ "$(uname -m)" == x86_64 ]]' \
#     sbin'argocd* -> argocd' \
#   argoproj/argo-cd
#
# zi for \
#     as'program' \
#     atclone"./configure --prefix=$ZPRFX > /dev/null" \
#     atpull'%atclone' \
#     make"-j PREFIX=${ZPRFX} install > /dev/null" \
#     pick"cmatrix" \
#   abishekvashok/cmatrix
#
# zi for \
#     atclone'cp -vf completions/exa.zsh _exa'  \
#     sbin'**/exa -> exa' \
#   ogham/exa
#
# zi for \
#     atclone'cp -vf completions/fd.zsh _fd' \
#     sbin'**/fd -> fd' \
#   @sharkdp/fd
#
# zi for \
#     atclone"
#       autoreconf -fi
#       ./configure --with-oniguruma=builtin
#       make
#       ln -sfv $PWD/jq.1 $ZPFX/man/man1" \
#     atpull'%atclone' \
#     if"(( ${+commands[jq]} == 0 ))" \
#     sbin'jq' \
#   @stedolan/jq
#
# zi for \
#     as'program' \
#     atpull'%atclone' \
#     make"-j PREFIX=${ZPRFX} install > /dev/null" \
#     pick"neofetch" \
#   dylanaraps/neofetch
#
# zi for \
#     as'program' \
#     atclone" autoreconf -iv; ./configure --prefix=$ZPFX" \
#     atpull'%atclone' \
#     make'-j bin/stow' \
#     pick"$ZPFX/bin/stow" \
#   @aspiers/stow
#
# zi for \
#     as"tmux=$ZPFX/tmux" \
#     make'-j' \
#     mv'tmux* -> tmux' \
#     pick'tmux' \
#   @tmux/tmux
#
# zi for \
#     as'null' \
#     atclone'%atpull' \
#     atpull'
#       ./bin/brew update --preinstall \
#       && ln -sf $PWD/completions/zsh/_brew $ZINIT[COMPLETIONS_DIR] \
#       && rm -f brew.zsh \
#       && ./bin/brew shellenv --dummy-arg > brew.zsh \
#       && zcompile brew.zsh' \
#     depth'3' \
#     nocompletions \
#     sbin'bin/brew' \
#     src'brew.zsh' \
#   @homebrew/brew
