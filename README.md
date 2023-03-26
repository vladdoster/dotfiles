# Dotfiles

[![Release](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml/badge.svg)](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml)
[![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)](https://github.com/vladdoster/dotfiles/releases/latest)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/vladdoster/dotfiles)

Program configuration files are managed by GNU Stow.

Supports x86_64/ARM64 vaiants of GNU Linux & macOS.

## Usage

Install and set everything up, run:

```zsh
mkdir $HOME/.config \
&& git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles \
&& make stow install

# Reload Zsh process
exec zsh -l
```

## Makefile targets

| Target            | Descripton                                             |
| ----------------- | ------------------------------------------------------ |
| brew-bundle       | Install programs defined in brewfile                   |
| brew-install      | Install Homebrew                                       |
| brew-uninstall    | Uninstall Homebrew                                     |
| chsh              | Set shell to ZSH                                       |
| docker-build      | Build docker image                                     |
| docker-clean      | Clean docker resources                                 |
| docker-load       | Create tarball of docker image                         |
| docker-push       | Build and push dotfiles docker image                   |
| docker-save       | Create tarball of docker image                         |
| docker-shell      | Start shell in docker container                        |
| hammerspoon       | Install hammerspoon configuration                      |
| help              | Display all Makfile targets                            |
| install           | Install dotfiles                                       |
| neovim            | Install neovim configuration                           |
| py-pip-install    | Install pip                                            |
| py-pkgs           | Install python pkgs                                    |
| py-update         | Update python packages                                 |
| rust-install      | Install rust & cargo                                   |
| rust-pkgs         | Install rust programs                                  |
| safari-extensions | Install 1password, vimari, grammarly safari extensions |
| stow              | Install GNU stow                                       |
| uninstall         | Uninstall dotfiles                                     |
| update-readme     | Update Make targets table in README                    |
