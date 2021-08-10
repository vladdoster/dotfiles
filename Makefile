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

# ${HOME}/.local:
#	mkdir -p $<

.DEFAULT_GOAL := help

help: ## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
init: deps ## Initial deploy dotfiles
	@$(run-stow)
	@echo "--- Installed dotfiles"
	@$(get-nvim-config)
	@echo "--- Success: dotfiles installed on $$HOSTNAME"
	@echo "--- Reloading shell"
	@exec $$SHELL

.PHONY: clean --delete
clean: --delete ## Remove deployed dotfiles
	@find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	@echo "--- Cleaned .DS_Store files"
	@rm -rf "$$HOME"/.local/share/nvim "$$HOME/.config/nvim/plugin"
	@echo "--- Cleaned neovim plugins"
	@find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;
	@echo "--- Removed dotfile softlinks"
	@rm -rf $$HOME/.{config/nvim/plugin,local/share/nvim}
	@echo "--- Successfully cleaned previous dotfiles installations on $$HOSTNAME"

.PHONY: test --simulate
test: --simulate ## Simulate an installation
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)

.PHONY: deps
deps: ## Install neovim python dependencies
	@( \
		python3 -m pip --quiet install --user --trusted-host pypi.org --trusted-host files.pythonhosted.org \
			black \
			isort \
			mdformat \
			pynvim \
		&& echo "--- Installed Python 3 packages" \
	) 2>/dev/null

.PHONY: run
run: ## Run dockerized devel env
	docker run \
		-it \
		--rm \
		--name development \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		cloud-dev:latest

.PHONY: build
build: ## Build dockerized devel env
	docker build . --no-cache --tag cloud-dev:latest --build-arg username=$$USER

pip-update: ## Update python packages
	pip3 list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user
