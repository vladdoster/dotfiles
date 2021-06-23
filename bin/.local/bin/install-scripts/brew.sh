#!/usr/bin/env bash

PROGRAM="brew"
URL="https://github.com/homebrew/brew"

temp_dir() {
    temp_prefix=$(basename "$0")
    mktemp -d /tmp/${temp_prefix}.${PROGRAM}.XXXXXX
}

INSTALL_DIR=$(temp_dir)

trap 'catch' ERR
catch() {
  echo "--- ERROR: An error has occurred while running $0"
}

trap 'catch' EXIT
catch() {
  rm -rf "$temp_dir"
  echo "--- Removed tmp files"
}

if [[ $OSTYPE =~ "linux" ]] && [[ -e /home/linuxbrew ]]; then
  echo "--- Attempting to remove previous Linuxbrew installations"
  sudo rm -rf /home/linuxbrew
fi

echo "--- Installing brew on $OSTYPE"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "--- Successfully installed brew"
