#!/bin/bash

echo "Installing oh-my-zsh to $HOME/dotfiles"

ZSH="$HOME/dotfiles/zsh/.zshrc.d/ohmyzsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

echo "Successfully install oh-my-zsh"
