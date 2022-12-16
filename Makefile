.DEFAULT_SHELL := $(shell command -v zsh 2> /dev/null)
.ONESHELL:

CONFIGS := hammerspoon neovim
CONTAINER_NAME = vdoster/dotfiles
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
PIP_OPTS := --no-compile --trusted-host files.pythonhosted.org --trusted-host pypi.org --upgrade --user
PY_PKGS := bdfr beautysh best-of black bpytop flake8 instaloader isort mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc pynvim reorder-python-imports pip
STOW_OPTS := --target=$$HOME --verbose=1

.PHONY: all brew-install brew-bundle clean dotfiles hammerspoon neovim shell stow test docker-shell docker-build
.SILENT: all brew-install brew-bundle clean dotfiles hammerspoon neovim shell stow test docker-shell docker-build

all: help

hammerspoon: destination:=$${HOME}/.hammerspoon
neovim: destination := $${HOME}/.config/nvim

$(CONFIGS): ## Clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

install: | uninstall ## Install dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --stow {} \;

uninstall: ## Uninstall dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --delete {} \;
	$(info --- uninstalled dotfiles)

docker-build: ## Build docker image
	docker build \
		--compress \
		--force-rm \
		--no-cache \
		--pull \
		--rm \
		--tag=$(CONTAINER_NAME):latest \
		.

docker-shell: ## Start shell in docker container
	@docker run \
		--interactive \
		--mount=source=dotfiles-volume,destination=/home \
		--tty \
		--security-opt seccomp=unconfined \
		$(CONTAINER_NAME):latest

docker-save: ## Create tarball of docker image
	$(info --- saving $(CONTAINER_NAME):latest)
	docker save $(CONTAINER_NAME):latest | gzip > "$$(basename $(CONTAINER_NAME))-latest.tar.gz"

docker-load: ## Create tarball of docker image
	$(info --- loading $(CONTAINER_NAME):latest)
	docker load --input "$$(basename $(CONTAINER_NAME))-latest.tar.gz"

docker-push: docker-clean ## Build and push dotfiles docker image
	make --directory=docker/ manifest

docker-clean: ## Clean docker resources
	docker system prune --all --force

brew-bundle: ## Install programs defined in Brewfile
	brew bundle --cleanup --file Brewfile --force --no-lock --zap

brew-install: ## Install Homebrew
	$(info Preparing to install Homebrew)
	/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/install.sh)"

brew-uninstall: ## Uninstall Homebrew
	$(info Preparing to uninstall brew)
	/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/uninstall.sh)"

chsh: ## Set shell to ZSH
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

safari-extensions: ## Install 1password, vimari, grammarly safari extensions
	brew install mas
	mas install 1569813296 1480933944 1462114288 # 1password, vimari, grammarly

py-install: ## Install pip
	python3 -m ensurepip --upgrade

py-pkgs: ## Install python pkgs
	pip3 install $(PIP_OPTS) $(PY_PKGS)
	$(info --- py packages installed)

py-update: py-pkgs ## Update python packages
	pip3 list --user | cut -d" " -f 1 | tail -n +3 | xargs python3 -m pip install $(PIP_OPTS)

rust-install: ## Install rust & cargo
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rust-pkgs: ## Install rust programs
	cargo install bat cargo-update exa topgrade

help: ## Display available Make targets
	@ # credit: tweekmonster github gist
	echo "$$(grep -hE '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s : | sort)"

%: ## A catch-all target to make fake targets
	@true

# vim: set fenc=utf8 ffs=unix ft=make list noet sw=4 ts=4 tw=72:
