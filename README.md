# Dotfiles

| Solution                                       | Problem                  |
| ---------------------------------------------- | ------------------------ |
| [GNU Stow](https://www.gnu.org/software/stow/) | manage dotfiles          |
| [Make](Makefile)                               | {install,update} systems |

## Usage

#### Install dotfiles

```bash
make dotfiles
```

#### Setup a new system

The Makefile will deduce what system and distro (if applicable). 

```bash
make setup
```

## Useful commands

#### List possible targets

```bash
make list
```

#### Change shell

```bash
sudo usermod --shell /bin/zsh
```
