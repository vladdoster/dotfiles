#!/bin/bash

echo "---Installing $1" &&
        brew install $@ &&
        echo "---Adding $1 to Brewfile" &&
        brew bundle dump --all --describe --force --no-lock --debug &&
        exit 0 ||
        echo "---WARNING: Brew file not updated" &&
        exit 1
