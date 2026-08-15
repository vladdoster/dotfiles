MAKEFLAGS += --silent

SHELL := $(shell command -v zsh 2> /dev/null)
# .DEFAULT_SHELL := command -v zsh 2> /dev/null)
.ONESHELL:

BREWFILE := Brewfile
CONFIGS := hammerspoon neovim
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD

CONTAINER_ARCH ?= $$(arch)
CONTAINER_LABEL ?= $(shell git rev-parse --short HEAD)
CONTAINER_NAME := vdoster/dotfiles-$(CONTAINER_ARCH)
CONTAINER_TAG ?= $(CONTAINER_NAME):$(CONTAINER_LABEL)
BUILD_DATE := $(shell date -u +%FT%TZ) # https://github.com/opencontainers/image-spec/blob/master/annotations.md

DOCKER_OPTS := --hostname docker-$(shell basename $(CONTAINER_NAME)) --interactive --mount=source=dotfiles-$(CONTAINER_ARCH)-volume,destination=/home --security-opt seccomp=unconfined
STOW_OPTS := --target=$$HOME --verbose=1

TARGETS := $(shell grep -oE '^[a-zA-Z_-]+:' $(firstword $(MAKEFILE_LIST)) | tr -d ':' | sort -u)
.PHONY: $(TARGETS)

all: help

hammerspoon: destination:=$${HOME}/.hammerspoon ## Install hammerspoon configuration
neovim: destination := $${HOME}/.config/nvim ## Install neovim configuration

$(CONFIGS): ## Clone configuration repository
	sh -c "[ -d $(destination) ] || git clone $(GH_URL)/$@-configuration $(destination)"

install: | uninstall ## Install dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --stow {} \;

uninstall: ## Uninstall dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow $(STOW_OPTS) --delete {} \;
	$(info ==> uninstalled dotfiles)

docker-build: ## Build docker image
	docker buildx build \
	--label org.opencontainers.image.created="$(BUILD_DATE)" \
	--load \
	--platform linux/"$(CONTAINER_ARCH)" \
	--progress plain \
	--pull \
	--tag "$(CONTAINER_TAG)" \
	.

clean-docker: ## Clean docker resources
	docker system prune --all --force

clean-brew: ## Clean homebrew caches and stale versions
	brew cleanup --prune=all --scrub --verbose

brew-nuke: ## DESTRUCTIVE: uninstall every brew/cask package declared in the Brewfile
	read -r "ans?Uninstalls every Brewfile package (incl. git, zsh, python3). Continue? [y/N] " && [[ $$ans == [yY] ]] || exit 1
	brew bundle list --file=$(BREWFILE) --brews --casks | xargs brew uninstall --force --ignore-dependencies --verbose --zap

clean: clean-brew clean-docker

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

brew-bundle: export HOMEBREW_NO_ENV_HINTS := 1
brew-bundle: ## Install programs defined in Brewfile
	$(info ==> syncing Brewfile packages)
	brew bundle install --file=$(BREWFILE) --jobs=auto --force --force-cleanup --zap --verbose

brew-install: ## Install Homebrew
	$(info Preparing to install Homebrew)
	NONINTERACTIVE=1 /bin/bash -c "unset GIT_CONFIG; $$(curl -fsSL $(HOMEBREW_URL)/install.sh)"

brew-uninstall: ## Uninstall Homebrew
	$(info Preparing to uninstall brew)
	/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/uninstall.sh)"

chsh: ## Set shell to ZSH
	grep -qxF "$$(which zsh)" /etc/shells || echo "$$(which zsh)" | sudo tee -a /etc/shells
	chsh -s "$$(which zsh)" $$USER

build-neovim: ## Build neovim from source
	$(info ==> building neovim)
	build_dir=$$(mktemp -d);\
	git clone https://github.com/neovim/neovim $$build_dir;\
	make --directory $$build_dir --jobs 8 CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$$HOME/.local/ install

build-stow: ## Build stow from source
	$(info ==> building gnu stow)
	build_dir=$$(mktemp -d);\
	curl -L http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz | tar xz --strip 1 -C $$build_dir;\
	( cd $$build_dir && ./configure --prefix=$$HOME/.local ); \
	make --directory $$build_dir --jobs 8 install

safari-extensions: ## Install 1password, vimari, grammarly safari extensions
	brew install mas
	mas install 1569813296 1480933944 1462114288

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
	make targets-table | uvx --with mdformat-gfm mdformat - >> README.md

%: ## A catch-all target to make fake targets
	true

# vim: set fenc=utf8 ffs=unix ft=make foldmethod=indent list noet sw=4 ts=4 tw=100:
