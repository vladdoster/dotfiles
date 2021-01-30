#!/bin/bash
set -e

_cleanup() {
	[ -d "fzf" ] && rm -rf fzf
}

_main() {
	git clone https://github.com/junegunn/fzf.git
	cd fzf
	./install
}

_cleanup
_main
_cleanup
