# Dotfiles

[![Release](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml/badge.svg)](https://github.com/vladdoster/dotfiles/actions/workflows/release.yml)
[![Release Version](https://img.shields.io/github/v/release/vladdoster/dotfiles)](https://github.com/vladdoster/dotfiles/releases/latest)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/vladdoster/dotfiles)

Program configuration files are managed by GNU Stow.

Supports x86_64/ARM64 vaiants of GNU Linux & macOS.

## Usage

Install and set everything up, run:

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/vladdoster/dotfiles/master/install.zsh)"
```

This clones the repository to `~/.config/dotfiles`, installs Homebrew, syncs the Brewfile, and
stows the configuration packages. Pass flags after the command substitution (the first trailing
argument becomes `$0`):

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/vladdoster/dotfiles/master/install.zsh)" install.zsh --only stow --dry-run
```

Or from a local clone:

```zsh
zsh install.zsh --help
```

## Makefile targets

| Target            | Descripton                                                              |
| ----------------- | ----------------------------------------------------------------------- |
| brew-bundle       | Install programs defined in Brewfile                                    |
| brew-install      | Install Homebrew                                                        |
| brew-nuke         | DESTRUCTIVE: uninstall every brew/cask package declared in the Brewfile |
| brew-uninstall    | Uninstall Homebrew                                                      |
| build-neovim      | Build neovim from source                                                |
| build-stow        | Build stow from source                                                  |
| chsh              | Set shell to ZSH                                                        |
| clean-brew        | Clean homebrew caches and stale versions                                |
| clean-docker      | Clean docker resources                                                  |
| docker-build      | Build docker image                                                      |
| docker-load       | Create tarball of docker image                                          |
| docker-push       | Build and push dotfiles docker image                                    |
| docker-save       | Create tarball of docker image                                          |
| docker-shell      | Start shell in docker container                                         |
| hammerspoon       | Install hammerspoon configuration                                       |
| help              | Display all Makfile targets                                             |
| install           | Install dotfiles                                                        |
| neovim            | Install neovim configuration                                            |
| safari-extensions | Install 1password, vimari, grammarly safari extensions                  |
| uninstall         | Uninstall dotfiles                                                      |
| update-readme     | Update Make targets table in README                                     |
