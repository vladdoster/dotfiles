
define run-stow
find * -not -path '*/\.*' -type d -exec stow {} --ignore=#\.bash*\# --target=$$HOME $^ \;
endef

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	UNAME_D := $(shell uname --kernel-release)
	ifeq ($(filter %arch%,$(UNAME_D)),)
        FLAGS += ARCH
    endif
	FLAGS += LINUX
endif
ifeq ($(UNAME_S),Darwin)
	FLAGS += OSX
endif

.SILENT:
SHELL := bash
.ONESHELL:
MAKEFLAGS += --no-builtin-rules
.PHONY : --restow --simulate list

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	echo $(FLAGS)


dotfiles:
	#$(run-stow)
	echo "++ installed dotfiles ++"

setup: dotfiles
	OS=$(shell uname -s)
	ifeq ($OS, Darwin)
		echo "Setting up MacOS"
		bash "$$HOME/.local/bin/system-setup/mac_os.sh"
	else
		DISTRO=$(shell cat /etc/issue*)
			ifneq (,$(findstring Arch, $$DISTRO))
				echo "Setting up Arch Linux"
				bash "$$HOME/.local/bin/system-setup/arch_linux.sh"
			endif
	endif

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
