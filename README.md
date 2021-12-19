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
```

**Note**: Requires GNU stow. To install stow from source, run:

```bash
cd bin/.local/bin
make stow
cd -      # go back to repository root
make init # retry install command
```

or if Homebrew is installed:

```bash
brew install stow
```

##### Install programs to get full experience

```bash
make all-progs
```

or if Homebrew is installed, run:

```bash
brew install bat exa neovim
```

#### Get all CLI & GUI programs

```bash
make brew-bundle
```

#### Uninstall dotfiles

**Note**: Doesn't remove installed programs

```bash
make clean
```

#### List Makefile targets

```bash
make
```

#### Install Homebrew

```
make brew-install
```

#### Change shell to ZSH

##### macOS

```bash
sudo dscl . -create /Users/"$USER" UserShell "$(which zsh)"
```

##### Linux

```bash
sudo chsh --shell $(which zsh) $USER
```
