.ONESHELL:
.PHONY : --restow --simulate --delete list run build
.SILENT:

MAKEFLAGS += --no-builtin-rules
SHELL := bash

current_dir=$(shell pwd)
PERSISTENT_PATH=$(current_dir)/persistent
PERSISTENT_DIR=persistent
SSH_DIR=~/.ssh
USERNAME=$(shell whoami)

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
	  git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	  echo "--- Installed packer"
	fi
endef

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install: clean deps
	echo "--- Installing dotfiles"
	$(run-stow)
	echo "--- Installed dotfiles"
	echo "--- Cloning git submodules"
	git submodule update --init --recursive || (echo "--- Unable to initialize Git submodules" && exit 1)
	echo "--- Cloned git submodules"
	echo "--- Installing neovim dependencies and LSPs"
	$(install-packer)
	nvim -c +PackerInstall
	echo "--- Installed neovim dependencies and LSPs"
	echo "--- Successfully installed dotfiles on $$HOSTNAME" 

clean : --delete
	find "$$PWD" -type f -name "*.DS_Store" -ls -delete
	echo "--- Removed .DS_Store files"
	rm -rf "$$HOME"/.local/share/nvim "$$HOME/.config/nvim/plugin"
	echo "--- Cleaned neovim plugins"
	find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;	
	echo "--- Removed dotfile softlinks"
	$(remove-git-submodules)
	echo "--- Removed Git submodules"
	echo "--- Successfully cleaned previous dotfiles installations on $$HOSTNAME" 

test : --simulate
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)

deps:
	echo "--- Installing python3 pkgs"
	pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org ranger-fm pynvim

run:
	docker run --rm -it -v $(SSH_DIR):/home/$(USERNAME)/.ssh -v $(PERSISTENT_PATH):/home/$(USERNAME)/$(PERSISTENT_DIR)/ cloud-dev:latest

build:
	docker build . -t cloud-dev:latest --build-arg username=$(USERNAME)
