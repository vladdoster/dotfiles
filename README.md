# Dotfiles

| Solution                                       | Problem                  |
| ---------------------------------------------- | ------------------------ |
| [GNU Stow](https://www.gnu.org/software/stow/) | manage dotfiles          |
| [Make](Makefile)                               | {install,update} systems |

## Design Choices

- Git branchs for basic seperation of concerns. Mixing led to ugly workarounds removing configs
and development overhead deciphering configs.
- Pull requests to keep system branchs up to date. This can seem tedious, but 
enables basic smoke testing via CI tests (github actions) before merging into a different
system branch.

| System     | Repository Branch                                                    | Documentation                                                                  |
|------------|----------------------------------------------------------------------|--------------------------------------------------------------------------------|
| Arch Linux | [arch-linux](https://github.com/vladdoster/dotfiles/tree/arch-linux) | [README.md](https://github.com/vladdoster/dotfiles/tree/arch-linux#arch-linux) |
| Mac OS     | [mac-os](https://github.com/vladdoster/dotfiles/tree/mac-os)         | [README.md](https://github.com/vladdoster/dotfiles/tree/mac-os#mac-os-darwin)  |

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
