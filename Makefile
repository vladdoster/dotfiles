# vim: set fenc=utf8 ffs=unix ft=make list noet sw=4 ts=4 tw=72:

.DEFAULT_SHELL := $(shell command -v zsh 2> /dev/null)
.ONESHELL:

CONFIGS := hammerspoon neovim
CONTAINTER_NAME = dotfiles
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
PIP_OPTS := --no-compile --trusted-host files.pythonhosted.org --trusted-host pypi.org --upgrade --user
PY_PKGS := bdfr beautysh best-of black bpytop flake8 instaloader isort mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc pynvim reorder-python-imports pip
STOW_OPTS := --target=$$HOME --verbose=1

.PHONY: all brew brew-bundle clean dotfiles hammerspoon neovim shell stow test
.SILENT: all brew brew-bundle clean dotfiles hammerspoon help neovim py-install py-pkgs py-update shell stow test

all: help

hammerspoon: destination:=$${HOME}/.hammerspoon
neovim: destination := $${HOME}/.config/nvim

$(CONFIGS): ## Clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

install: | uninstall ## Install dotfiles via GNU stow
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --stow {} \;

uninstall: ## Un-stow dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --delete {} \;
	$(info --- uninstalled dotfiles)

build: ## Build docker image
	docker build --build-arg USER=$(CONTAINTER_NAME) --tag $(CONTAINTER_NAME):latest $(CURDIR)

shell: ## Start shell in Docker container
	@docker run --interactive --mount source=dotfiles-vol,destination=/home/$(CONTAINTER_NAME) --tty $(CONTAINTER_NAME):latest

brew: ## (Un)install Homebrew
	$(info Preparing to $(filter-out $@, $(MAKECMDGOALS)) homebrew)
	@/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/$(filter-out $@, $(MAKECMDGOALS)).sh)"

brew-bundle: ## Install programs defined in Brewfile
	@brew bundle --cleanup --file Brewfile --force --no-lock --zap

chsh: ## Set user shell to ZSH
	echo "$$(which zsh)" | sudo tee -a /etc/shells
	chsh -s "$$(which zsh)" $$USER

stow: ## Install GNU stow
	$(info --- installing GNU Stow)
	if [ -d stow/stow.git ]; then echo "--- stow already present"; else git clone https://github.com/aspiers/stow stow/stow.git; fi
	cd stow/stow.git \
		&& autoreconf -ivf \
		&& ./configure \
		&& make -j2 -s --no-print-directory bin/chkstow bin/stow \
		&& cp bin/*stow ../../bin/.local/bin/
	$(info --- installed GNU Stow)
	[ -d stow/stow.git ] && rm -rf stow/stow.git

safari-extensions:
	brew install mas
	mas install 1569813296 1480933944 1462114288 # 1password, vimari, grammarly

py-install: ## Install pip
	python3 -m ensurepip --upgrade

py-pkgs: py-install ## Install Python pkgs
	python3 -m pip install $(PIP_OPTS) $(PY_PKGS)
	$(info --- py packages installed)

py-update: py-pkgs ## Update Python packages
	python3 -m pip list --user | cut -d" " -f 1 | tail -n +3 | xargs python3 -m pip install $(PIP_OPTS)

rust-install: ## Install Rust & Cargo
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rust-pkgs: ## Install Rust programs
	cargo install bat cargo-update exa topgrade



help: ## Display available Make targets
	@ # Thanks tweekmonster ;) Saw this in your gist, too.
	echo "$$(grep -hE '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s : | sort)"

%: ## A catch-all target to make fake targets
	@true
