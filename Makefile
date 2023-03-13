MAKEFLAGS += --silent

# SHELL := $(shell command -v zsh 2> /dev/null)
.DEFAULT_SHELL := $(shell command -v zsh 2> /dev/null)
.ONESHELL:

CONFIGS := hammerspoon neovim
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD

CONTAINER_NAME := vdoster/dotfiles
CONTAINER_LABEL ?= $(shell git rev-parse --short HEAD)
CONTAINER_TAG ?= $(CONTAINER_NAME):$(CONTAINER_LABEL)
BUILD_DATE := $(shell date -u +%FT%TZ) # https://github.com/opencontainers/image-spec/blob/master/annotations.md

DOCKER_OPTS := --hostname docker-$(shell basename $(CONTAINER_NAME)) --interactive --mount=source=dotfiles-volume,destination=/home --security-opt seccomp=unconfined
PIP_OPTS := --trusted-host=files.pythonhosted.org --trusted-host=pypi.org --upgrade --target=$$HOME/.local/bin/python
PY_PKGS := bdfr beautysh best-of black bpytop diagrams flake8 instaloader isort mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc pynvim reorder-python-imports pip
STOW_OPTS := --target=$$HOME --verbose=1

TARGETS := all brew-bundle brew-install clean docker-build docker-shell docker-ssh dotfiles hammerspoon help neovim shell stow targets-table test update-readme
.PHONY: $(TARGETS)

all: help

hammerspoon: destination:=$${HOME}/.hammerspoon ## Install hammerspoon configuration
neovim: destination := $${HOME}/.config/nvim ## Install neovim configuration

$(CONFIGS): ## Clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

install: | uninstall ## Install dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --stow {} \;

uninstall: ## Uninstall dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --delete {} \;
	$(info ==> uninstalled dotfiles)

docker-build: ## Build docker image
	docker --debug \
		buildx \
			build \
			--label org.opencontainers.image.created="$(BUILD_DATE)" \
			--load \
			--no-cache \
			--platform linux/amd64 \
			--progress plain \
			--pull \
			--tag "$(CONTAINER_TAG)" \
			.

docker-clean: ## Clean docker resources
	docker system prune --all --force

docker-load: ## Create tarball of docker image
	$(info ==> loading $(CONTAINER_TAG))
	docker load --input "$$(basename $(CONTAINER_NAME))-$(CONTAINER_LABEL).tar.gz"

docker-push: ## Build and push dotfiles docker image
	make --directory=docker/ manifest

docker-save: ## Create tarball of docker image
	docker save $(CONTAINER_TAG) | gzip > "$$(basename $(CONTAINER_NAME))-$(CONTAINER_LABEL).tar.gz"
	$(info ==> saved $(CONTAINER_TAG))

docker-shell: ## Start shell in docker container
	docker run \
		--tty \
		$(DOCKER_OPTS) \
		$(CONTAINER_TAG)

brew-bundle: ## Install programs defined in brewfile
	brew bundle --cleanup --file Brewfile --force --no-lock --zap

brew-install: ## Install Homebrew
	$(info Preparing to install Homebrew)
	/bin/bash -c "unset GIT_CONFIG;  $$(curl -fsSL $(HOMEBREW_URL)/install.sh)"

brew-uninstall: ## Uninstall Homebrew
	$(info Preparing to uninstall brew)
	/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/uninstall.sh)"

chsh: ## Set shell to ZSH
	echo "$$(which zsh)" | sudo tee -a /etc/shells
	chsh -s "$$(which zsh)" $$USER

stow: ## Install GNU stow
	$(info ==> installing GNU Stow)
	if [ -d stow/stow.git ]; then echo "==> stow already present"; else git clone https://github.com/aspiers/stow stow/stow.git; fi
	cd stow/stow.git \
		&& autoreconf -ivf \
		&& eval $$(perl -V:siteprefix) \
		&& ./configure --prefix=$$siteprefix \
		&& make --jobs=4 --no-print-directory --silent \
		&& cp bin/*stow ../../bin/.local/bin/ \
		&& $(info ==> installed GNU Stow)
	[ -d stow/stow.git ] && rm -rf stow/stow.git

safari-extensions: ## Install 1password, vimari, grammarly safari extensions
	brew install mas
	mas install 1569813296 1480933944 1462114288 # 1password, vimari, grammarly

py-pip-install: ## Install pip
	python3 -m ensurepip --upgrade

py-pkgs: ## Install python pkgs
	$(info ==> installing py pkgs)
	python3 -m pip install $(PIP_OPTS) $(PY_PKGS) \
	&& echo '==> py packages installed'

py-update: py-pkgs ## Update python packages
	$(info ==> updating py pkgs)
	python3 -m pip install $(PIP_OPTS) --upgrade pip \
		&& python3 -m pip list | cut -d" " -f 1 | tail -n +3 | xargs python3 -m pip install $(PIP_OPTS) \
		&& echo '==> py packages updated'

rust-install: ## Install rust & cargo
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rust-pkgs: ## Install rust programs
	cargo install bat cargo-update exa topgrade

help: ## Display all Makfile targets
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

targets-table:
	printf "|Target|Descripton|\n|---|---|\n"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "| %s| %s |\n", $$1, $$2}'

update-readme: ## Update Make targets table in README
	sed -i '' -e '/^|/d' README.md
	make targets-table | mdformat - >> README.md

%: ## A catch-all target to make fake targets
	true

# vim: set fenc=utf8 ffs=unix ft=make list noet sw=4 ts=4 tw=72:
