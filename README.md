# Dotfiles

[![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)](https://github.com/vladdoster/dotfiles/releases/latest)
[![Release Status](https://img.shields.io/github/workflow/status/vladdoster/dotfiles/Release?label=build)](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml)
[![Docker Build Status](https://img.shields.io/docker/cloud/build/vdoster/dotfiles)](https://hub.docker.com/repository/docker/vdoster/dotfiles)
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
| docker-ssh        | Start docker container running SSH                     |
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
