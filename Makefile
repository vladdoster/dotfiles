# Overridable env vars
DOCKER_CLI_MOUNTS ?= -v "$(CURDIR)":/go/src/github.com/docker/cli
DOCKER_CLI_CONTAINER_NAME ?=

CONFIGS := hammerspoon neovim
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
#
# Sets the name of the company that produced the windows binary.
PACKAGER_NAME ?=

DEV_DOCKER_IMAGE_NAME = docker-cli-dev$(IMAGE_TAG)
CACHE_VOLUME_NAME := docker-cli-dev-cache
ifeq ($(DOCKER_CLI_GO_BUILD_CACHE),y)
DOCKER_CLI_MOUNTS += -v "$(CACHE_VOLUME_NAME):/root/.cache/go-build"
endif

.PHONY: hammerspoon
hammerspoon: destination:=$$HOME/.hammerspoon

.PHONY: neovim
neovim: destination := $$HOME/.config/nvim

$(CONFIGS): ## clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

.PHONY: dotfiles
dotfiles: | clean ## Deploy dotfiles via GNU install
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --stow --target $$HOME {} \;

# Some Dockerfiles use features that are only supported with BuildKit enabled
export DOCKER_BUILDKIT=1

# build docker image (dockerfiles/Dockerfile.build)
.PHONY: build_docker_image
build_docker_image:
	# build dockerfile from stdin so that we don't send the build-context; source is bind-mounted in the development environment
	cat ./Dockerfile | docker build ${DOCKER_BUILD_ARGS} --load -t $(DEV_DOCKER_IMAGE_NAME) -

DOCKER_RUN_NAME_OPTION := $(if $(DOCKER_CLI_CONTAINER_NAME),--name $(DOCKER_CLI_CONTAINER_NAME),)
DOCKER_RUN := docker run --rm $(ENVVARS) $(DOCKER_CLI_MOUNTS) $(DOCKER_RUN_NAME_OPTION)

.PHONY: dev
dev: build_docker_image ## start a build container in interactive mode for in-container development
	$(DOCKER_RUN) -it \
		--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
		$(DEV_DOCKER_IMAGE_NAME)

.PHONY: shell
shell: dev ## alias for dev

.PHONY: brew
brew: ## (Un)install Homebrew
	$(info Preparing to $(filter-out $@, $(MAKECMDGOALS)) homebrew)
	@/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/$(filter-out $@, $(MAKECMDGOALS)).sh)"

.PHONY: brew-bundle
brew-bundle: ## Install programs defined in $HOME/.config/dotfiles/Brewfile
	@brew bundle --cleanup --file Brewfile --force --no-lock --zap

brew-fix: ## Re-install Linuxbrew taps homebrew-core & homebrew-cask
	$(info --- adding git remote to origin)
	@git -C "/home/linuxbrew/.linuxbrew/Homebrew" remote add origin https://github.com/Homebrew/brew
	brew tap homebrew/core homebrew/cask

install-all: python/prog rust/prog ## Install Python & Rust programs

install-gnu-stow: ## Install GNU stow
	$(info --- installing GNU Stow)
	cd ./bin/.local/bin && make stow
	$(info --- installed GNU Stow)

python-prog: ## Install useful Python programs
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org --no-compile \
		autopep8 \
		beautysh black bpytop \
		flake8 \
		isort \
		mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc \
		pynvim \
		reorder-python-imports
	$(info --- py packages installed)

python-update: ## Update installed Python3 packages
	@pip3 list --user \
	| cut -d" " -f 1 \
	| tail -n +3 \
	| xargs pip3 install \
		--no-compile \
		--trusted-host files.pythonhosted.org \
		--trusted-host pypi.org \
		--upgrade \
		--user

rust-install: ## Install Rust & Cargo pkg manager via Rustup
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rust-programs: ## Install useful Rust programs
	cargo install bat cargo-update exa topgrade

rust-uninstall: ## Uninstall Rust via rustup
	@rustup self uninstall

clean-nvim:
	rm -rf $$HOME/.{cache,config/nvim/lua/plugins,local/share/nvim}
	$(info --- removed nvim artifacts)

clean-dotfiles:
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --target $$HOME --delete {} \;
	$(info --- uninstalled dotfiles)

.PHONY: clean
clean: clean/nvim clean/dotfiles  ## Remove installed dotfiles
	find $$PWD -type f -name ".DS_Store" -print -delete
	$(info --- cleaned .DS_Store files)

# A catch-all target to make fake targets
%:
	@true

.PHONY: help
help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
