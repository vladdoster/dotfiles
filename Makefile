.SILENT:
SHELL := bash
.ONESHELL:
MAKEFLAGS += --no-builtin-rules
.PHONY : --restow --simulate --delete list

define run-stow
	find * -not -path '*/\.*' -type d -exec stow --verbose 1 {} --override=#\*\# --target="$$HOME" \;
endef

define remove-git-submodules
	echo "--- Removing initialized Git submodules"
	(git submodule deinit --all --force || git submodule deinit --force .) 2>/dev/null \
		|| (echo "--- ERROR: Unable to remove Git submodules" && exit 1)
endef

define install-packer
	if [ ! -d ~/.local/share/nvim/site/pack/packer ]; then
	  echo "--- Installing packer"
	  git clone https://github.com/wbthomason/packer.nvim \
	    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	  echo "--- Installed packer"
	fi
endef

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install: clean
	echo "--- Installing dotfiles"
	$(run-stow)
	echo "--- Installed dotfiles"
	echo "--- Cloning git submodules"
	git submodule update --init --recursive || (echo "--- Unable to initialize Git submodules" && exit 1)
	echo "--- Cloned git submodules"
	echo "--- Installing neovim dependencies and LSPs"
	$(install=packer)
	nvim -c PackerInstall
	nvim -c LspUpdate
	echo "--- Installed neovim dependencies and LSPs"
	echo "--- Successfully installed dotfiles on $$HOSTNAME" 

clean : --delete
	find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	echo "--- Removed .DS_Store files"
	rm -rf "$$HOME"/.local/share/nvim
	echo "--- Cleaned neovim plugins"
	find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;	
	echo "--- Removed dotfile softlinks"
	$(remove-git-submodules)
	echo "--- Removed Git submodules"
	echo "--- Successfully cleaned previous dotfiles installations on $$HOSTNAME" 

update-git:
	

test : --simulate
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)


