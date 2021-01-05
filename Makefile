.SILENT:
SHELL := bash
.ONESHELL:
MAKEFLAGS += --no-builtin-rules
.PHONY : --restow --simulate list

define run-stow
find * -not -path '*/\.*' -type d -exec stow {} --override=#\*\# --target=$$HOME $^ \;
endef

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

dotfiles:
	$(run-stow)
	echo "++ installed dotfiles ++"

update : --restow
	$(run-stow)
	echo "++ updated dotfiles ++"

test : --simulate
	$(run-stow)

clean :
	find "$$HOME" -path '*/.*' -maxdepth 1 -type l -print \
		| while read f_name ; do \
				found=$$(readlink -e "$$f_name") ; \
				if [ -z "$$found" ]; then \
					exists=$$(find . -name "$$f_name") ; \
					if [ -z "$$exists" ]; then \
						rm $$f_name ; \
						echo "Removed $$f_name but had a symlink mismatch" ; \
					else \
						echo "Unable to find $$f_name" ; \
					fi ; \
				else \
					rm $$f_name ; \
					echo "Removed $$f_name" ; \
				fi ; \
			done ; \
	echo "++ removed dotfiles ++"
