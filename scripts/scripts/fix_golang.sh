#!/bin/bash

if [ -d "$HOME"/.go ]; then
    rm -rf "$HOME"/.go
else
    mkdir ~/.go
fi

echo "GOPATH=$HOME/.go" >> "$HOME/.bashrc"
echo "GOPATH=$HOME/.go" >> "$ZDOTDIR/.zshrc"
echo "export GOPATH" >> "$HOME/.bashrc"
echo "export GOPATH" >> "$ZDOTDIR/.zshrc"
echo "PATH=\$PATH:\$GOPATH/bin # Add GOPATH/bin to PATH for scripting" >> "$HOME/.bashrc"
echo "PATH=\$PATH:\$GOPATH/bin # Add GOPATH/bin to PATH for scripting" >> "$ZDOTDIR/.zshrc"

. "$HOME/.bashrc"
. "$ZDOTDIR/.zshrc"
