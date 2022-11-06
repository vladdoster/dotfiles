# Dotfiles

![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)
[![Release Status](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml/badge.svg)](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml)

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

| TARGET      | DESCRIPTION                          |
| ----------- | ------------------------------------ |
| brew        | (Un)install Homebrew                 |
| brew-bundle | Install programs defined in Brewfile |
| build       | Build docker image                   |
| chsh        | Set user shell to ZSH                |
| clean       | Un-stow dotfiles                     |
| help        | Display available Make targets       |
| install     | Install dotfiles via GNU stow        |
| py-install  | Install pip                          |
| py-pkgs     | Install Python pkgs                  |
| py-update   | Update Python packages               |
| rust-instal | Install Rust & Cargo                 |
| rust-pkgs   | Install Rust programs                |
| shell       | Start shell in Docker container      |
| stow        | Install GNU stow                     |

## Change shell to ZSH

```zsh
make chsh
```
