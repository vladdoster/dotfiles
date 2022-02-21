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

## Makefile targets

| TARGET          | DESCRIPTION                                                 |
| --------------- | ----------------------------------------------------------- |
| all-prog        | Install Python & Rust programs                              |
| brew-bundle     | Install programs defined in $HOME/.config/dotfiles/Brewfile |
| brew-fix        | Re-install Homebrew taps homebrew-core & homebrew-cask      |
| brew-install    | Install Homebrew pkg manager                                |
| brew-uninstall  | Uninstall Homebrew pkg manager                              |
| build-container | Build containerized env and install dotfiles                |
| clean           | Remove deployed dotfiles                                    |
| help            | Display all Makfile targets                                 |
| install         | Deploy dotfiles via GNU install                             |
| linuxbrew-fix   | Re-install Linuxbrew taps homebrew-core & homebrew-cask     |
| pip-update      | Update Python packages                                      |
| py-prog         | Install Python dependencies                                 |
| rust-install    | Install Rust & Cargo pkg manager via Rustup                 |
| rust-prog       | Install programs via rust                                   |
| rust-uninstall  | Uninstall Rust                                              |
| stow            | Install GNU stow                                            |

#### Change shell to ZSH

##### macOS

```bash
sudo dscl . -create /Users/"$USER" UserShell "$(which zsh)"
```

##### Linux

```bash
sudo chsh --shell $(which zsh) $USER
```
