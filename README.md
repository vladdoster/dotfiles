# Dotfiles

| System     | Repository Branch | CI build                   |
|------------|-------------------|----------------------------|
| arch linux | [arch-linux]      | ![build][arch-linux build] |
| macOS      | [mac-os]          | ![build][mac-os build]     |

## Problem & Solution

| Problem                  | Solution         |
|--------------------------|------------------|
| manage dotfiles          | [GNU stow]       |
| {install,update} systems | [Make](Makefile) |

1. Git branches for elementary separation of concerns. Sharing the master branch
   led to obtuse workarounds for removing configs and development overhead
   deciphering configs.

1. Pull requests to keep system branches up to date. The system requires more
   diligence, but enables necessary smoke testing via CI tests (GitHub actions)
   before merging into a different system branch.

[arch-linux]: https://github.com/vladdoster/dotfiles/tree/arch-linux
[arch-linux build]: https://github.com/vladdoster/dotfiles/workflows/Arch%20Linux/badge.svg
[mac-os]: https://github.com/vladdoster/dotfiles/tree/mac-os 
[mac-os build]: https://github.com/vladdoster/dotfiles/workflows/MacOS/badge.svg
[GNU stow]: https://www.gnu.org/software/stow/
