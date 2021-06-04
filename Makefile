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
	(git submodule deinit --all --force || git submodule deinit --force .) \
		|| (echo "--- ERROR: Unable to remove Git submodules" && exit 1)
endef

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install: clean
	echo "--- Installing dotfiles via GNU Stow"
	$(run-stow)
	echo "--- Cloning Git submodules"
	git submodule update --init --recursive || (echo "--- Unable to initialize Git submodules" && exit 1)
	echo "--- Installed dotfiles and Git submodules"

clean : --delete
	echo "--- Removing pre-exisiting dotfile softlinks"
	find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;	
	$(remove-git-submodules)
	echo "--- Removed dotfiles soft links and Git submodules"

test : --simulate
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)

dirs:
	mkdir -p ~/git
	mkdir -p ~/build

pyenv:
	rm -rf ~/.pyenv
	curl https://pyenv.run | bash

nvim_pyenv: pyenv
	pyenv install 3.7.9
	pyenv virtualenv 3.7.9 neovim
	pyenv activate; pip install pynvim; pyenv deactivate;

nvim: dirs nvim_pyenv
	if [ -d ~/git/neovim ]; then echo "[nvim]: git/neovim Already found"; else git clone https://github.com/neovim/neovim ~/git/neovim; fi
	if [ -d ~/build/neovim ]; then cd ~/build/neovim && git pull; else git clone https://github.com/neovim/neovim ~/build/neovim; fi
	cd ~/build/neovim/ && make -j2 -s --no-print-directory && sudo make install -s

