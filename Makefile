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

$(CONFIGS): ## Clone configuration repository
	sh -c "[ ! -d $(destination) ] && git clone $(GH_URL)/$@-configuration $(destination)"

.PHONY: dotfiles
install: | uninstall ## Install dotfiles via GNU stow
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --stow --target $${HOME} {} \;

build: ## Build docker image
	docker build \
		--build-arg USER=$(CONTAINTER_NAME) \
		--file $(CURDIR)/Dockerfile \
		--tag $(CONTAINTER_NAME):latest \
		$(CURDIR)

.PHONY: shell
shell: ## Alias for dev
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

install-all: py-prog rust-prog ## Install Python & Rust programs

dirs:
	mkdir -p ~/code

.PHONY: stow
stow: dirs ## Install GNU stow
	$(info --- installing GNU Stow)
	if [ -d ~/code/stow ]; then echo "[stow]: code/stow already found"; else git clone https://github.com/aspiers/stow ~/code/stow; fi
	cd ~/code/stow/ && autoreconf -ivf && ./configure && make -j2 -s --no-print-directory && sudo make install -s
	$(info --- installed GNU Stow)

safari-extensions:
	brew install mas
	# 1password, vimari, grammarly
	mas install 1569813296 1480933944 1462114288

py-prog: ## Install useful Python programs
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --no-compile --trusted-host files.pythonhosted.org --trusted-host pypi.org --upgrade --user \
		autopep8 \
		bdfr best-of beautysh black bpytop \
		flake8 \
		isort instaloader \
		mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables mdformat-toc \
		pynvim \
		reorder-python-imports
	$(info --- py packages installed)

py-update: ## Update installed Python3 packages
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

uninstall: Un-stow dotfiles
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --target $${HOME} --delete {} \;
	$(info --- uninstalled dotfiles)

help: ## Print help message
	@ # Thanks tweekmonster ;) Saw this in your gist, too.
	@echo "$$(grep -hE '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s : | sort)"

%: ## A catch-all target to make fake targets
	@true

# vim: set sw=2 sts=2 et ft=make et:
