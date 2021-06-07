#!/usr/bin/env bash

get_platform() {
    case "$OSTYPE" in
        Linux*) platform=Linux ;;
        Darwin*) platform=Mac ;;
        CYGWIN*) platform=Cygwin ;;
        MINGW*) platform=MinGw ;;
        *) platform="UNKNOWN:${unameOut}" ;;
    esac
    echo "--- Platform: $platform"
}

echo "--- Removing neovim cruft"
rm -rf ~/.local/share/nvim

echo "--- Installing packer"

if [ ! -d ~/.local/share/nvim/site/pack/packer ]; then
    echo "--- Installing packer"
    git clone https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    echo "--- Packer installed!"
fi

echo "--- Linking config"
echo "--- Old nvim config will be deleted"
rm -rf ~/.config/nvim/ \
    && mkdir -p ~/.config/nvim \
    && cp -r init.lua ~/.config/nvim \
    && cp -r lua ~/.config/nvim

# change shell in nvim config
if [ "$(get_platform)" = "Mac" ]; then
    gsed -i "s/bash/$SHELL/g" ~/.config/nvim/lua/mappings.lua
else
    sed -i "s/bash/$SHELL/g" ~/.config/nvim/lua/mappings.lua
fi
echo "--- Set shell to $SHELL in nvim successfully!"

nvim +PackerInstall
