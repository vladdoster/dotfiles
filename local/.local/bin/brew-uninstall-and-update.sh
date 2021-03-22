#!/bin/bash

echo "---Uninstalling $1" \
    && brew uninstall $@ \
    && echo "---Adding $1 to Brewfile" \
    && brew bundle dump --all --describe --force --no-lock --debug \
    && exit 0 \
    || echo "---WARNING: Brew file not updated" \
    && exit 1
