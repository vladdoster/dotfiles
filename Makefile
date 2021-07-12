define remove-git-submodules
	echo "--- Removing initialized Git submodules"
	(git submodule deinit --all --force || git submodule deinit --force .) 2>/dev/null \
		|| (echo "--- ERROR: Unable to remove Git submodules" && exit 1)
endef

define run-stow
	find * -not -path '*/\.*' -type d -exec stow --verbose 1 {} --override=#\*\# --target="$$HOME" \;
endef

.PHONY: install 
install: clean deps
	@$(run-stow)
	@echo "--- Installed dotfiles"
	@git submodule update --init --recursive || (echo "--- Unable to initialize Git submodules" && exit 1)
	@echo "--- Cloned git submodules"
	@nvim +PackerInstall
	@echo "--- Success: dotfiles installed on $$HOSTNAME" 

.PHONY: clean --delete
clean: --delete
	@find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	@echo "--- Removed .DS_Store files"
	@rm -rf "$$HOME"/.local/share/nvim "$$HOME/.config/nvim/plugin"
	@echo "--- Cleaned neovim plugins"
	@find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;	
	@echo "--- Removed dotfile softlinks"
	@$(remove-git-submodules)
	@(git submodule deinit --all --force) 2>/dev/null || (echo "--- ERROR: Unable to remove Git submodules" && exit 1)
	@echo "--- Removed Git submodules"
	@echo "--- Successfully cleaned previous dotfiles installations on $$HOSTNAME" 

.PHONY: test --simulate
test: --simulate
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)

.PHONY: deps
deps:
	python3 -m pip install --user --trusted-host pypi.org --trusted-host files.pythonhosted.org ranger-fm pynvim
	echo "--- Installed Python 3 packages"

.PHONY: run
run:
	docker run \
		-it \
		--rm \
		--name development \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		cloud-dev:latest

.PHONY: build
build:
	docker build . --no-cache --tag cloud-dev:latest --build-arg username=$$USER
