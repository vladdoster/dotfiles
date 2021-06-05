# Mac OS (darwin)

- Install CLI/GUI programs via HomeBrew
- Systemwide config via Applescript

> [!NOTE] sudo access is required or errors will occur.

## Install

To Install and set everything up, run:

```shell
bash <(curl -s https://raw.githubusercontent.com/vladdoster/dotfiles/mac-os/bin/.local/bin/install.sh)
```

## Usage

#### Install dotfiles

```bash
make dotfiles
```

#### Setup a new system

```bash
make dotfiles
```

#### Remove dotfiles

```bash
make dotfiles
```

#### List possible targets

```bash
make
```

#### Change shell

```bash
sudo usermod --shell /bin/zsh
```
