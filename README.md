# Dotfiles

| Solution                                       | Problem                  |
| ---------------------------------------------- | ------------------------ |
| [GNU Stow](https://www.gnu.org/software/stow/) | manage dotfiles          |
| [Make](Makefile)                               | {install,update} systems |

- Git branchs for acheiving basic seperation of concerns. 
- Pull requests to keep system branchs up to date. This can seem tedious, but 
enables basic smoke testing via CI tests (github actions) before merging into a different
system branch.

## Usage

#### Change branch

| System     | Repository Branch                                                |
|------------|------------------------------------------------------------------|
| Arch Linux | [Branch](https://github.com/vladdoster/dotfiles/tree/arch-linux) |
| Mac OS     | [Branch](https://github.com/vladdoster/dotfiles/tree/mac-os)     |

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
