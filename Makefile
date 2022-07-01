.DEFAULT_GOAL:=install
.ONESHELL:
CONTAINER_NAME:=dotfiles

help: ## Display all Makfile targets
	@grep -E '^.*[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:
CONFIGS:= hammerspoon neovim
GH_URL=https://github.com/vladdoster
HOMEBREW_URL:=https://raw.githubusercontent.com/Homebrew/install/HEAD
hammerspoon: destination:=$$HOME/.hammerspoon
neovim: destination:=$$HOME/.config/nvim

.SILENT: neovim
$(CONFIGS): ## Clone a program's configuration repository
	sh -c "[ -d $(destination) ] || git clone $(GH_URL)/$@-configuration $(destination)"

install: | clean ## Deploy dotfiles via GNU install
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --stow --target $$HOME {} \;

update: clean
	git pull --autostash --quiet
	make
	$(info -- updated dotfiles)

container/build: ## Build container && install dotfiles
	# docker buildx create --use --name dotfiles-builder || echo "--- exists"
	docker volume create configuration
	docker build --tag=$(CONTAINER_NAME):latest .
	# docker buildx build \
	# 	--platform=darwin/arm64e\
	# 	--load \
	# 	.
	$(info --- built df container)

container/run: ## Run containerized dockerfiles env
	$(info --- starting df container)
	docker run \
		--interactive \
		--tty \
		--user docker \
		--volume configuration:/home/docker \
		$(CONTAINER_NAME)

brew: ## (Un)install Homebrew
	$(info Preparing to $(filter-out $@, $(MAKECMDGOALS)) homebrew)
	@/bin/bash -c "$$(curl -fsSL $(HOMEBREW_URL)/$(filter-out $@, $(MAKECMDGOALS)).sh)"

brew/bundle: ## Install programs defined in $HOME/.config/dotfiles/Brewfile
	@brew bundle --cleanup --file Brewfile --force --no-lock --zap

brew/fix: ## Re-install Linuxbrew taps homebrew-core & homebrew-cask
	$(info --- adding git remote to origin)
	@git -C "/home/linuxbrew/.linuxbrew/Homebrew" remote add origin https://github.com/Homebrew/brew
	brew tap homebrew/core homebrew/cask

install/all: python/prog rust/prog ## Install Python & Rust programs

install/gnu-stow: ## Install GNU stow
	$(info --- installing GNU Stow)
	$(shell pushd ./bin/.local/bin; make stow)
	$(info --- installed GNU Stow)

python/prog: ## Install useful Python programs
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org --no-compile \
		autopep8 \
		black bpytop \
		flake8 \
		isort \
		mdformat mdformat-config mdformat-gfm mdformat-shfmt mdformat-tables \
		pynvim \
		reorder-python-imports
	$(info --- py packages installed)

python/update: ## Update installed Python3 packages
	@pip3 list --user \
	| cut -d" " -f 1 \
	| tail -n +3 \
	| xargs pip3 install \
		--no-compile \
		--trusted-host files.pythonhosted.org \
		--trusted-host pypi.org \
		--upgrade \
		--user

rust/install: ## Install Rust & Cargo pkg manager via Rustup
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rust/prog: ## Install useful Rust programs
	cargo install bat cargo-update exa topgrade

rust/uninstall: ## Uninstall Rust via rustup
	@rustup self uninstall

clean/nvim:
	rm -rf $$HOME/.{cache,config/nvim/lua/plugins,local/share/nvim}
	$(info --- removed nvim artifacts)

clean/dotfiles:
	find * -maxdepth 0 -mindepth 0 -type d -exec stow --verbose 1 --target $$HOME --delete {} \;
	$(info --- uninstalled dotfiles)

clean: clean/nvim clean/dotfiles  ## Remove installed dotfiles
	find $$PWD -type f -name ".DS_Store" -print -delete
	$(info --- cleaned .DS_Store files)

# A catch-all target to make fake targets
%:
	@true

.PHONY: CONFIGS all clean hammerspoon install neovim test
.SILENT: brew-install clean container/build container/run stow
