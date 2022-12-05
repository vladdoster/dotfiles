# Dotfiles

![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/vladdoster/dotfiles/Release?label=Release)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/vdoster/dotfiles)

## Features

Program configuration files are managed by GNU Stow.

Supports GNU Linux && macOS (Apple silicon, Intel)

## Install

Install and set everything up, run:

```zsh
mkdir $HOME/.config \
&& git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles \
&& make stow install

# Reload Zsh process
exec zsh
```

## Makefile targets

| TARGET            | DESCRIPTION                                            |
| ----------------- | ------------------------------------------------------ |
| brew-bundle       | Install programs defined in Brewfile                   |
| brew-install      | Install Homebrew                                       |
| brew-uninstall    | Uninstall Homebrew                                     |
| chsh              | Set shell to ZSH                                       |
| docker-build      | Build docker image                                     |
| docker-push       | Build and push dotfiles docker image                   |
| docker-shell      | Start shell in docker container                        |
| help              | Display available Make targets                         |
| install           | Install dotfiles                                       |
| py-install        | Install pip                                            |
| py-pkgs           | Install python pkgs                                    |
| py-update         | Update python packages                                 |
| rust-install      | Install rust & cargo                                   |
| rust-pkgs         | Install rust programs                                  |
| safari-extensions | Install 1password, vimari, grammarly safari extensions |
| stow              | Install GNU stow                                       |
| uninstall         | Uninstall dotfiles                                     |

## Change shell to ZSH

```zsh
make chsh
```
