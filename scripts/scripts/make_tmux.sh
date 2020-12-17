#!/usr/bin/env zsh
#
# Installs git completion for zsh
#

git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
