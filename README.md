# macOS

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/vladdoster/dotfiles)

## Features

- Tiling window management via Hammerspoon
- macOS configuration via Ansible
- Dotfiles managed by GNU Stow
- Install all required programs via Brew or from source
- Comfy neovim configuratiom in Lua

## Install

To Install and set everything up, run:

```bash
git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles
```

## Usage

#### Install

```bash
make init
exec $SHELL
```

#### Uninstall

```bash
make clean
```

#### List Makefile targets

```bash
make
```

#### Need to install homebrew?

```
l-installers
./brew.sh
```

#### Change shell

```bash
sudo dscl . -create /Users/"$USER" UserShell "$(which zsh)"
```
