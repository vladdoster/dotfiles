.SILENT:
SHELL := bash
.ONESHELL:
MAKEFLAGS += --no-builtin-rules
.PHONY : --restow --simulate --delete list

define run-stow
find * -not -path '*/\.*' -type d -exec stow --verbose 1 {} --override=#\*\# --target="$$HOME" \;
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
	echo "--- Removing initialized Git submodules"
	git submodule deinit --all --force || (echo "--- ERROR: Unable to remove Git submodules" && exit 1)
	echo "--- Removed dotfiles soft links and Git submodules"

update : --restow
	echo "--- Updating dotfile soft links"
	$(run-stow)
	echo "--- Updating Git submodules"
	git submodule deinit --all --force || (echo "--- ERROR: Unable to update Git submodules" && exit 1)
	echo "--- Updated dotfile soft links and Git submodules"

test : --simulate
	echo "--- DRYRUN: No changes will be made to current environment"
	$(run-stow)


