# macOS

## Features

- Tiling window management via Hammerspoon
- System configuration via Ansible
- Dotfiles managed by GNU Stow
- Install all required programs via Brew or from source

## Install

To Install and set everything up, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/vladdoster/dotfiles/mac-os/bin/.local/bin/install.sh)
```

## Usage

#### Install dotfiles

```bash
make install
```

#### Setup a new system

```bash
make dotfiles
```

#### Remove dotfiles

```bash
make clean
```

#### List possible targets

```bash
make
```

#### Change shell

```bash
sudo dscl . -create /Users/$USER UserShell "$(which zsh)"
```
