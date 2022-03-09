
zi for \
    as'completions' \
    atclone'
      ./argocd* completion zsh > _argocd' \
    atpull'%atclone' \
    from'gh-r' \
    if'[[ "$(uname -m)" == x86_64 ]]' \
    sbin'argocd* -> argocd' \
  argoproj/argo-cd

zi for \
    from'gh-r' \
    sbin'**/bat -> bat' \
  @sharkdp/bat \
sbin'**/f*g' chanzuckerberg/fogg \
sbin'**/g*i'extrawurst/gitui \
sbin'**/g*r' idc101/git-mkver \
sbin'**/g*w' charmbracelet/glow \
sbin'**/gh'  cli/cli \
sbin'**/l*t' jesseduffield/lazygit \
sbin'**/m*k' rust-lang/mdBook \
sbin'**/p*s' dalance/procs         \
sbin'**/t*i' XAMPPRocky/tokei  \
sbin'g*r'    @github/git-sizer

zi for \
    from'gh-r' \
    sbin'checkmake* -> checkmake' \
  mrtazz/checkmake

zi for \
    as'program' \
    atclone"./configure --prefix=$ZPRFX > /dev/null" \
    atpull'%atclone' \
    make"-j PREFIX=${ZPRFX} install > /dev/null" \
    pick"cmatrix" \
  abishekvashok/cmatrix

zi for \
    from'gh-r' \
    sbin'**/delta -> delta' \
  dandavison/delta

zi for \
    atclone'cp -vf completions/exa.zsh _exa'  \
    from'gh-r' \
    sbin'**/exa -> exa' \
  ogham/exa

zi for \
    from'gh-r'  \
    sbin'**/fd -> fd' \
  @sharkdp/fd

zi for \
    from'gh-r'  \
    sbin'**/f*g' \
  chanzuckerberg/fogg

zi for \
    from'gh-r'  \
    sbin'**/fx* -> fx' \
  @antonmedv/fx

zi for \
    from'gh-r'  \
    sbin'fzf'   \
  @junegunn/fzf

zi for \
    from'gh-r' \
    sbin'**/gh' \
  cli/cli

zi for \
    from'gh-r' \
    sbin'**/git-mkver' \
  idc101/git-mkver

zi for \
    from'gh-r'      \
    sbin'git-sizer' \
  @github/git-sizer

zi for \
    from'gh-r'  \
    sbin'**/glow' \
  charmbracelet/glow

zi for \
    from'gh-r'  \
    sbin'g*x -> grex'  \
  pemistahl/grex

zi for \
    as'null' \
    atclone'%atpull' \
    atpull'
      ./bin/brew update --preinstall \
      && ln -sf $PWD/completions/zsh/_brew $ZINIT[COMPLETIONS_DIR] \
      && rm -f brew.zsh \
      && ./bin/brew shellenv --dummy-arg > brew.zsh \
      && zcompile brew.zsh' \
    depth'3' \
    nocompletions \
    sbin'bin/brew' \
    src'brew.zsh' \
  @homebrew/brew

zi for \
    from'gh-r' \
    sbin'**/h*e -> hyperfine' \
  @sharkdp/hyperfine

zi for \
    atclone"
      autoreconf -fi \
      && ./configure --with-oniguruma=builtin \
      && make \
      && ln -sfv $PWD/jq.1 $ZPFX/man/man1" \
    as'null' \
    if"(( ${+commands[jq]} == 0 ))" \
    sbin'jq' \
  @stedolan/jq

# zi for \
#     from'gh-r' \
#     sbin'kubectx;kubens'  \
#   ahmetb/kubectx

zi for \
    from'gh-r' \
    sbin'**/lazygit' \
  jesseduffield/lazygit

zi for \
    as'program' \
    atpull'%atclone' \
    make"-j PREFIX=${ZPRFX} install > /dev/null" \
    pick"neofetch" \
  dylanaraps/neofetch

zi for \
    from'gh-r' \
    sbin'**/nvim -> nvim' \
    ver'nightly' \
  neovim/neovim

zi for \
    from'gh-r' \
    sbin'**/procs -> procs' \
  @dalance/procs

zi for \
    from'gh-r' \
    sbin'**/rg -> rg' \
  BurntSushi/ripgrep

zi for \
    from'gh-r' \
    sbin'**/sh* -> shfmt' \
  @mvdan/sh

zi for \
    from'gh-r' \
    sbin'**/starship -> starship' \
  starship/starship

zi for \
    as'program' \
    atpull'%atclone' \
    atclone"
         autoreconf -iv \
      && ./configure --prefix=$ZPFX" \
    make'bin/stow' \
    pick"$ZPFX/bin/stow" \
  @aspiers/stow

zi for \
    as"tmux=$ZPFX/tmux" \
    from'gh-r' \
    mv'tmux* -> tmux' \
    pick'tmux' \
  @tmux/tmux

zi for \
    from'gh-r' \
    sbin'**/t*i -> tokei' \
  XAMPPRocky/tokei
