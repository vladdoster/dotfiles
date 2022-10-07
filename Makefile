# Overridable env vars
#
#
ZSH := $(shell command -v zsh 2> /dev/null)
.DEFAULT_SHELL := $(ZSH)
.ONESHELL:
CONFIGS := hammerspoon neovim
CONTAINTER_NAME = dotfiles
GH_URL = https://github.com/vladdoster
HOMEBREW_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD
test:
	$(CURDIR)

.PHONY: hammerspoon
hammerspoon: destination:=$${HOME}/.hammerspoon

.PHONY: neovim
neovim: destination := $${HOME}/.config/nvim

$(CONFIGS): ## clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

.PHONY: dotfiles
dotfiles: | clean ## Deploy dotfiles via GNU install
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --stow --target $${HOME} {} \;


build: ## Build docker image
	docker build \
		--build-arg USER=$(CONTAINTER_NAME) \
		--file $(CURDIR)/Dockerfile \
		--tag $(CONTAINTER_NAME):latest \
		$(CURDIR)

.PHONY: shell
shell: ## alias for dev
	@docker run \
		--interactive \
		--tty \
		--mount source=dotfiles-vol,destination=/home/$(CONTAINTER_NAME) \
		$(CONTAINTER_NAME):latest

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

safari-extensions:
	brew install mas
	# 1password, vimari, grammarly
	mas install 1569813296 1480933944 1462114288

python-prog: ## Install useful Python programs
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org --no-compile \
		autopep8 \
		bdfr best-of beautysh black bpytop \
		flake8 \
		isort instaloader \
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
	rm -rf $${HOME}/.{cache,config/nvim/lua/plugins,local/share/nvim}
	$(info --- removed nvim artifacts)

clean-dotfiles:
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --target $${HOME} --delete {} \;
	$(info --- uninstalled dotfiles)

.PHONY: clean
clean: clean/nvim clean/dotfiles  ## Remove installed dotfiles
	find $$PWD -type f -name ".DS_Store" -print -delete
	$(info --- cleaned .DS_Store files)

# A catch-all target to make fake targets
%:
	@true

help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

