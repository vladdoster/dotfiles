MAKEFLAGS += --silent

ZSH := $(shell command -v zsh 2> /dev/null)
# Stop a recipe when a command in a pipe fails.
SHELL := $(ZSH) -o pipefail

BREWFILE := Brewfile
CONFIGS := hammerspoon neovim
GH_URL := https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
NPROC = $(shell getconf _NPROCESSORS_ONLN)
PACKAGES := $(patsubst %/,%,$(wildcard */))
STOW_OPTS := --target=$(HOME) --verbose=1

# Use the arch names that docker/Makefile gives its images (amd64, arm64).
CONTAINER_ARCH ?= $(subst aarch64,arm64,$(subst x86_64,amd64,$(shell uname -m)))
CONTAINER_LABEL ?= $(shell git rev-parse --short HEAD)
CONTAINER_NAME = vdoster/dotfiles-$(CONTAINER_ARCH)
CONTAINER_TAG ?= $(CONTAINER_NAME):$(CONTAINER_LABEL)
CONTAINER_TARBALL = $(notdir $(CONTAINER_NAME))-$(CONTAINER_LABEL).tar.gz

DOCKER_OPTS = --hostname docker-$(notdir $(CONTAINER_NAME)) \
	--interactive \
	--mount=source=dotfiles-$(CONTAINER_ARCH)-volume,destination=/home \
	--security-opt seccomp=unconfined

# Print each "target: ## text" line with the awk printf format in $(1).
list-targets = grep -E '^[a-zA-Z_-]+:.*\#\# ' $(firstword $(MAKEFILE_LIST)) | sort \
	| awk -F ':.*\#\# ' '{ printf "$(1)", $$1, $$2 }'

TARGETS := $(shell grep -oE '^[a-zA-Z_-]+:' $(firstword $(MAKEFILE_LIST)) | tr -d ':' | sort -u)
.PHONY: $(TARGETS)

all: help

help: ## Show all Makefile targets
	$(call list-targets,\033[36m%-20s\033[0m %s\n)

# Stow each package alone. A conflict in one package does not stop the other packages.
install: ## Install dotfiles
	for pkg in $(PACKAGES); do stow $(STOW_OPTS) --restow "$$pkg" || echo "==> skipped $$pkg" >&2; done

uninstall: ## Uninstall dotfiles
	stow $(STOW_OPTS) --delete $(PACKAGES)
	echo '==> uninstalled dotfiles'

hammerspoon: destination := $(HOME)/.hammerspoon
neovim: destination := $(HOME)/.config/nvim
hammerspoon: ## Install hammerspoon configuration
neovim: ## Install neovim configuration
$(CONFIGS):
	[ -d "$(destination)" ] || git clone "$(GH_URL)/$@-configuration" "$(destination)"

chsh: ## Set shell to ZSH
	grep -qxF "$(ZSH)" /etc/shells || echo "$(ZSH)" | sudo tee -a /etc/shells > /dev/null
	chsh -s "$(ZSH)" "$$USER"

brew-install: ## Install Homebrew
	$(info ==> installing homebrew)
	NONINTERACTIVE=1 /bin/bash -c "unset GIT_CONFIG; $$(curl -fsSL $(HOMEBREW_URL)/install.sh)"

brew-uninstall: ## Uninstall Homebrew
	$(info ==> uninstalling homebrew)
	/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/uninstall.sh)"

brew-bundle: export HOMEBREW_NO_ENV_HINTS := 1
brew-bundle: ## Install programs defined in Brewfile
	$(info ==> syncing Brewfile packages)
	brew bundle install --file=$(BREWFILE) --jobs=auto --force --force-cleanup --zap --verbose

brew-nuke: ## DESTRUCTIVE: uninstall every brew/cask package declared in the Brewfile
	read -r "ans?Uninstalls every Brewfile package (incl. git, zsh, python3). Continue? [y/N] " && [[ $$ans == [yY] ]] || exit 1
	brew bundle list --file=$(BREWFILE) --brews --casks | xargs brew uninstall --force --ignore-dependencies --verbose --zap

safari-extensions: ## Install 1password, vimari, grammarly safari extensions
	brew install mas
	mas install 1569813296 1480933944 1462114288

build-neovim: ## Build neovim from source
	$(info ==> building neovim)
	build_dir=$$(mktemp -d) && \
	git clone --depth=1 https://github.com/neovim/neovim "$$build_dir" && \
	make --directory="$$build_dir" --jobs=$(NPROC) CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$(HOME)/.local install && \
	rm -rf "$$build_dir"

build-stow: ## Build stow from source
	$(info ==> building gnu stow)
	build_dir=$$(mktemp -d) && \
	curl -fsSL https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz | tar -xz --strip-components=1 -C "$$build_dir" && \
	cd "$$build_dir" && ./configure --prefix=$(HOME)/.local && make --jobs=$(NPROC) install && \
	rm -rf "$$build_dir"

docker-build: ## Build docker image
	docker buildx build \
		--label org.opencontainers.image.created="$$(date -u +%FT%TZ)" \
		--load \
		--platform linux/$(CONTAINER_ARCH) \
		--progress plain \
		--pull \
		--tag "$(CONTAINER_TAG)" \
		.

docker-load: ## Load docker image from tarball
	$(info ==> loading $(CONTAINER_TAG))
	docker load --input "$(CONTAINER_TARBALL)"

docker-push: ## Build and push dotfiles docker image
	$(MAKE) --directory=docker manifest

docker-save: ## Create tarball of docker image
	docker save "$(CONTAINER_TAG)" | gzip > "$(CONTAINER_TARBALL)"
	echo '==> saved $(CONTAINER_TAG)'

docker-shell: ## Start shell in docker container
	docker run --tty $(DOCKER_OPTS) "$(CONTAINER_TAG)"

clean: clean-brew clean-docker ## Clean homebrew and docker resources

clean-brew: ## Clean homebrew caches and stale versions
	brew cleanup --prune=all --scrub --verbose

clean-docker: ## Clean docker resources
	docker system prune --all --force

update-readme: ## Update Make targets table in README
	sed -i '' -e '/^|/d' README.md
	{ printf '| Target | Description |\n| --- | --- |\n'; $(call list-targets,| %s | %s |\n); } \
		| uvx --with mdformat-gfm mdformat - >> README.md

# vim: set fenc=utf8 ffs=unix ft=make foldmethod=indent list noet sw=4 ts=4 tw=100:
