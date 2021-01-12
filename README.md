# Dotfiles

![Arch Linux](https://github.com/vladdoster/dotfiles/workflows/Arch%20Linux/badge.svg)
![MacOS](https://github.com/vladdoster/dotfiles/workflows/MacOS/badge.svg)

| System      | Repository Branch                                                      |
|-------------|------------------------------------------------------------------------|
| Arch Linux  | [arch-linux](https://github.com/vladdoster/dotfiles/tree/arch-linux)   |
| Mac OS      | [mac-os](https://github.com/vladdoster/dotfiles/tree/mac-os)           |
| Remote Host | [remote host](https://github.com/vladdoster/dotfiles/tree/remote-host) | 

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

Check out each systems branch README.md for usage information.
