.DEFAULT_SHELL := $(shell command -v zsh 2> /dev/null)
.ONESHELL:

CONFIGS := hammerspoon neovim
CONTAINER_NAME = vdoster/dotfiles
CONTAINER_TAG = latest
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
PIP_OPTS := --no-compile --trusted-host files.pythonhosted.org --trusted-host pypi.org --upgrade
PY_PKGS := bdfr beautysh best-of black bpytop flake8 instaloader isort mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc pynvim reorder-python-imports pip
STOW_OPTS := --target=$$HOME --verbose=1

TARGETS := all brew-bundle brew-install clean docker-build docker-shell docker-ssh dotfiles hammerspoon neovim shell stow test update-readme help
.PHONY: $(TARGETS)
.SILENT: $(TARGETS)

all: help

hammerspoon: destination:=$${HOME}/.hammerspoon ## Install hammerspoon configuration
neovim: destination := $${HOME}/.config/nvim ## Install neovim configuration

$(CONFIGS): ## Clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

install: | uninstall ## Install dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --stow {} \;

uninstall: ## Uninstall dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --delete {} \;
	$(info --- uninstalled dotfiles)

docker-build: ## Build docker image
	cp ~/.ssh/id_rsa.pub .
	docker build \
		--compress \
		--force-rm \
		--no-cache \
		--progress plain \
		--rm \
		--tag=$(CONTAINER_NAME):latest \
		.

docker-clean: ## Clean docker resources
	docker system prune --all --force

docker-save: ## Create tarball of docker image
	docker save $(CONTAINER_NAME):$(CONTAINER_TAG) | gzip > "$$(basename $(CONTAINER_NAME))-$(CONTAINER_TAG).tar.gz"
	$(info --- saved $(CONTAINER_NAME):$(CONTAINER_TAG))

docker-load: ## Create tarball of docker image
	$(info --- loading $(CONTAINER_NAME):latest)
	docker load --input "$$(basename $(CONTAINER_NAME))-latest.tar.gz"

docker-push: docker-clean ## Build and push dotfiles docker image
	make --directory=docker/ manifest

DOCKER_OPTS := --interactive --mount=source=dotfiles-volume,destination=/home --security-opt seccomp=unconfined

docker-ssh: ## Start docker container running SSH
	@docker run \
		$(DOCKER_OPTS) \
		--detach \
        --publish 2222:22 \
		$(CONTAINER_NAME):$(CONTAINER_TAG)
	docker exec \
		--detach \
		--interactive \
		$$(docker container ls --latest --quiet) \
		sudo service ssh start
	$(info --- to ssh into container. run: ssh --port 2222 $$(basename $(CONTAINER_NAME)).localhost)

docker-shell: ## Start shell in docker container
	docker run \
		$(DOCKER_OPTS) \
		--tty \
		$(CONTAINER_NAME):$(CONTAINER_TAG)

brew-bundle: ## Install programs defined in brewfile
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

py-pip-install: ## Install pip
	python3 -m ensurepip --upgrade

py-pkgs: ## Install python pkgs
	python3 -m pip install $(PIP_OPTS) $(PY_PKGS)
	$(info --- py packages installed)

py-update: py-pkgs ## Update python packages
	python3 -m pip list | cut -d" " -f 1 | tail -n +3 | xargs python3 -m pip install $(PIP_OPTS)

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
	sed  -i '/^|/d' README.md
	make targets-table | mdformat - >> README.md

%: ## A catch-all target to make fake targets
	@true

# vim: set fenc=utf8 ffs=unix ft=make list noet sw=4 ts=4 tw=72:
