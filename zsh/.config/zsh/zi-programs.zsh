#!/usr/bin/env zsh

# reduce verbiage

zi from'gh-r' for \
  sbin'**/bat -> bat' @sharkdp/bat \
  sbin'**/delta -> delta' dandavison/delta \
  sbin'**/f*g' @chanzuckerberg/fogg \
  sbin'**/fx* -> fx' @antonmedv/fx \
  sbin'**/gh' cli/cli \
  sbin'**/git-mkver' @idc101/git-mkver \
  sbin'**/glow' charmbracelet/glow \
  sbin'**/lazygit' jesseduffield/lazygit \
  sbin'**/procs -> procs' @dalance/procs \
  sbin'**/rg -> rg' @BurntSushi/ripgrep \
  sbin'**/sh* -> shfmt' @mvdan/sh \
  sbin'**/starship -> starship' @starship/starship \
  sbin'**/volta' volta-cli/volta \
  sbin'checkmake* -> checkmake' mrtazz/checkmake \
  sbin'fzf' @junegunn/fzf \
  sbin'g*x -> grex' pemistahl/grex \
  sbin'git-sizer' @github/git-sizer
# from'gh-r' sbin'**/h*e -> hyperfine' for @sharkdp/hyperfine \
# from'gh-r' sbin'**/tokei -> tokei' for @XAMPPRocky/tokei
zi sbin'**/nvim -> nvim' ver'nightly' from'gh-t' for neovim/neovim

#zi for \
#
#  ver'nightly' neovim/neovim \
#  @BurntSushi/ripgrep \
#  @XAMPPRocky/tokei \
#  @antonmedv/fx \
#  @chanzuckerberg/fogg \
#  @dalance/procs \
#  @github/git-sizer \
#  @idc101/git-mkver \
#  @junegunn/fzf \
#  @mvdan/sh \
#  @sharkdp/bat \
#  @sharkdp/hyperfine \
#  @starship/starship \
#  charmbracelet/glow \
#  cli/cli \
#  dandavison/delta \
#  jesseduffield/lazygit \
#  mrtazz/checkmake \
#  pemistahl/grex \
#  volta-cli/volta


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
