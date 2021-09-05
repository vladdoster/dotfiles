NVIM-CONFIG-REPO=https://github.com/vladdoster/nvim-configuration.git 
NVIM-CONFIG-DIR=$$HOME/.config/nvim

define run-stow
	find * -not -path '*/\.*' -type d -exec stow --verbose 1 {} --override=#\*\# --target="$$HOME" \;
endef

.DEFAULT_GOAL := help
.ONESHELL:

help: ## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: nvim-cfg ## Deploy dotfiles via GNU stow
	@$(run-stow)
	@echo "--- dotfiles installed on $$HOSTNAME"
	@exec "$$SHELL"

.PHONY: --delete
clean: --delete ## Remove deployed dotfiles
	@find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	@echo "--- cleaned .DS_Store files"
	rm -rf "$$HOME"/{.local/share,.config}/nvim
	@echo "--- cleaned neovim plugins"
	@find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;
	@echo "--- removed dotfile softlinks"
	@echo "--- cleaned previous dotfiles installations on $$HOSTNAME"

brew-install: ## Install Homebrew pkg manager
	@echo "--- installing homebrew"
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew-uninstall: ## Uninstall Homebrew pkg manager
	@echo "--- uninstalling homebrew"
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

brew-bundle: ## Install programs defined in $HOME/.config/dotfiles/Brewfile
	@echo "--- installing user programs"
	brew bundle install --file "$$(pwd)"/Brewfile

linuxbrew-install: ## Install Linuxbrew pkg manager
	@echo "--- installing linuxbrew"
	@git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	@mkdir ~/.linuxbrew/bin
	@ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
	@eval "$(~/.linuxbrew/bin/brew shellenv)"

nvim-cfg: ## Clone Neovim config $HOME/.config/nvim
	@if [ ! -d $(NVIM-CONFIG-DIR) ] ;\
	then \
	  echo "--- nvim config does not exist, fetching"; \
	  git clone --progress --quiet $(NVIM-CONFIG-REPO) $(NVIM-CONFIG-DIR); \
	else \
	  echo "--- nvim config present, continuing"; \
	fi

pip-update: ## Update Python packages
	@pip3 list --user | cut -d" " -f 1 | tail -n +3 \
	| xargs pip3 install --user --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org

py-deps: ## Install Python dependencies
	@python3 -m pip install --quiet --user --trusted-host pypi.org --trusted-host files.pythonhosted.org \
		black isort \
		pynvim \
		mdformat mdformat-toc mdformat-gfm mdformat-tables mdformat-shfmt mdformat-config
	@echo "--- installed python 3 packages"

dry-run: --simulate ## Simulate an dotfiles deployment
	@echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)
