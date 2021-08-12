#!/usr/bin/env bash

if command -V yabai; then
    echo "--- Installing yabai"
    brew install koekeishiya/formulae/yabai
    echo "Add the following to sudoers:"
    echo "$USER ALL = (root) NOPASSWD: /usr/local/bin/yabai --load-sa"

    read -s -n 1 key
    if [[ $key == "" ]]; then
        echo '--- Continuing'
        sudo yabai --install-sa
        sudo yabai --load-sa
        brew services start yabai
        sudo defaults write com.apple.finder DisableAllAnimations -bool true
        echo "Press enter to start yabai on boot: "
        read -s -n 1 key
        if [[ $key == "" ]]; then
            brew services start koekeishiya/formulae/yabai
            echo "--- set yabai to run on boot"
        else
            echo "--- yabai won't start on boot, exiting"
        fi
    else
        echo "--- Incorrect key pressed, exiting"
        exit 1
    fi
else
    echo "--- Upgrading yabai"
    brew services stop yabai
    brew upgrade yabai
    sudo yabai --uninstall-sa
    sudo yabai --install-sa
    brew services start yabai
fi

if ! command -V skhd; then
    echo "--- Installing skhd"
    brew install koekeishiya/formulae/skhd
    brew services start skhd

    echo "Press enter to start skhd on boot: "
    read -s -n 1 key
    if [[ $key == "" ]]; then
        brew services start koekeishiya/formulae/skhd
        echo "--- set skhd to run on boot"
    else
        echo "--- skhd won't start on boot, exiting"
    fi
else
    echo "--- Upgrading yabai"
    brew services stop skhd
    brew upgrade skhd
    brew services start skhd
fi
