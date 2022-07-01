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
&& make stow-install \
&& make install

# Reload Zsh process
exec zsh
```

## Makefile targets

| TARGET           | DESCRIPTION                                                   |
| ---------------- | ------------------------------------------------------------- |
| brew             | (Un)install Homebrew                                          |
| brew/bundle      | Install programs defined in `$HOME/.config/dotfiles/Brewfile` |
| brew/fix         | Re-install taps homebrew-core & homebrew-cask                 |
| clean            | Remove installed dotfiles                                     |
| container/build  | Build container && install dotfiles                           |
| container/run    | Run containerized dockerfiles env                             |
| help             | Display all Makfile targets                                   |
| install          | Deploy dotfiles via GNU install                               |
| install/all      | Install Python & Rust programs                                |
| install/gnu-stow | Install GNU stow                                              |
| python/prog      | Install useful Python programs                                |
| python/update    | Update installed Python3 packages                             |
| rust/install     | Install Rust & Cargo pkg manager via Rustup                   |
| rust/prog        | Install useful Rust programs                                  |
| rust/uninstall   | Uninstall Rust via rustup                                     |

## Change shell to ZSH

##### Linux

```zsh
sudo chsh --shell "$(which zsh)" "$USER"
```
