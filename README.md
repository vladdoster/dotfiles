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
bash <(curl -s https://raw.githubusercontent.com/vladdoster/dotfiles/mac-os/bin/.local/bin/install.sh)
```

## Usage

#### Install

```bash
make install
```

#### Uninstall

```bash
make clean
```

#### List Makefile targets

```bash
make
```

#### Change shell

```bash
sudo dscl . -create /Users/"$USER" UserShell "$(which zsh)"
```
