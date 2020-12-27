# Dotfiles

![Arch Linux CI](https://github.com/vladdoster/dotfiles/workflows/Arch-Linux/badge.svg?branch=arch-linux)
![MacOS CI](https://github.com/vladdoster/dotfiles/workflows/MacOS/badge.svg?branch=mac-os)

| System     | Repository Branch                                                    | Documentation                                                                  |
|------------|----------------------------------------------------------------------|--------------------------------------------------------------------------------|
| Arch Linux | [arch-linux](https://github.com/vladdoster/dotfiles/tree/arch-linux) | [README.md](https://github.com/vladdoster/dotfiles/tree/arch-linux#arch-linux) |
| Mac OS     | [mac-os](https://github.com/vladdoster/dotfiles/tree/mac-os)         | [README.md](https://github.com/vladdoster/dotfiles/tree/mac-os#mac-os-darwin)  |

## Problem & Solution

| Problem                  | Solution                                       |
| ------------------------ | ---------------------------------------------- |
| manage dotfiles          | [GNU Stow](https://www.gnu.org/software/stow/) | 
| {install,update} systems | [Make](Makefile)                               |

1. Git branches for elementary separation of concerns. Sharing the master branch led to obtuse workarounds for removing configs
and development overhead deciphering configs.
1. Pull requests to keep system branches up to date. The system requires more diligence, but 
enables necessary smoke testing via CI tests (GitHub actions) before merging into a different
system branch.

## Usage

#### Change branch

```bash
git checkout -b {arch-linux, mac-os}
```

#### Install dotfiles

```bash
make dotfiles
```

#### Setup a new system

```bash
make setup
```

#### List possible targets

```bash
make list
```

#### Change shell

```bash
sudo usermod --shell /bin/zsh
```
