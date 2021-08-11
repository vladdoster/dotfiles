define get-nvim-config
	( \
		git clone https://github.com/vladdoster/neovim-configuration.git $$HOME/.config/nvim \
		&& echo "--- Cloned neovim configuration" \
	) 2>/dev/null \
	|| echo "--- neovim config already exists" 
endef

define run-stow
	find * -not -path '*/\.*' -type d -exec stow --verbose 1 {} --override=#\*\# --target="$$HOME" \;
endef

.DEFAULT_GOAL := help

help: ## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: py-deps ## Deploy dotfiles via GNU stow
	@$(run-stow)
	@echo "--- Installed dotfiles"
	@$(get-nvim-config)
	@echo "--- Success: dotfiles installed on $$HOSTNAME"
	@echo "--- Reloading shell"
	@exec $$SHELL

.PHONY: --delete
clean: --delete ## Remove deployed dotfiles
	@find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	@echo "--- Cleaned .DS_Store files"
	@rm -rf "$$HOME"/.local/share/nvim "$$HOME/.config/nvim/plugin"
	@echo "--- Cleaned neovim plugins"
	@find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;
	@echo "--- Removed dotfile softlinks"
	@rm -rf $$HOME/.{config/nvim/plugin,local/share/nvim}
	@echo "--- Successfully cleaned previous dotfiles installations on $$HOSTNAME"

brew-install: ## Install Homebrew pkg manager
	@echo "--- Installing Homebrew"
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew-uninstall: ## Uninstall Homebrew pkg manager
	@echo "--- Uninstalling Homebrew"
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

brew-bundle: ## Install programs defined in $HOME/.config/dotfiles/Brewfile
	@echo "--- Installing user programs"
	@brew bundle install --file $$(pwd)/Brewfile

py-deps: ## Install neovim python dependencies
	@( \
		python3 -m pip --quiet install --user --trusted-host pypi.org --trusted-host files.pythonhosted.org \
			black \
			isort \
			mdformat \
			pynvim \
		&& echo "--- Installed Python 3 packages" \
	) 2>/dev/null

pip-update: ## Update Python packages
	@pip3 list --user | cut -d" " -f 1 | tail -n +3 \
	| xargs pip3 install --user --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org

dry-run: --simulate ## Simulate an dotfiles deployment
	@echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)
