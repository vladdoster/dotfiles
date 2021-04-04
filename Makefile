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

dotfiles:
	$(run-stow)
	echo "--installed dotfiles"

update : --restow
	$(run-stow)
	echo "--updated dotfiles"

test : --simulate
	$(run-stow)
	echo "--simulated dotfiles install"

clean : --delete
	find * -type d -not -path '*/\.*' -exec stow --target="$$HOME" --verbose 1 --delete {} \;	
