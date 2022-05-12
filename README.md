# macOS

![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)
[![Release Status](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml/badge.svg)](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml)

## Features

Program configuration files are managed by GNU Stow.

## Install

Install and set everything up, run:

```bash
git clone https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles
```

## Makefile targets

| TARGET          | DESCRIPTION                                                 |
| :-------------: | ----------------------------------------------------------- |
| all-prog        | Install Python & Rust programs                              |
| brew-bundle     | Install programs defined in $HOME/.config/dotfiles/Brewfile |
| brew-fix        | Re-install Homebrew taps homebrew-core & homebrew-cask      |
| brew-install    | Install Homebrew pkg manager                                |
| brew-uninstall  | Uninstall Homebrew pkg manager                              |
| build-container | Build containerized env and install dotfiles                |
| clean           | Remove deployed dotfiles                                    |
| help            | Display available Makfile targets                           |
| install         | Deploy dotfiles via GNU install                             |
| linuxbrew-fix   | Re-install Linuxbrew taps homebrew-core & homebrew-cask     |
| pip-update      | Update Python packages                                      |
| py-prog         | Install Python dependencies                                 |
| rust-install    | Install Rust & Cargo pkg manager via Rustup                 |
| rust-prog       | Install programs via rust                                   |
| rust-uninstall  | Uninstall Rust                                              |
| stow            | Install GNU stow                                            |

## Change shell to ZSH

##### Linux

```bash
sudo chsh --shell "$(which zsh)" "$USER"
```
