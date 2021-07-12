#!/bin/bash

usage() { echo "Usage: $0 [-p <PROGRAM NAME>] [-u <GIT REPO URL>]" 1>&2; exit 1; }

while getopts ":p:u:" o; do
    case "${o}" in
        u)
            u=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${p}" ] || [ -z "${u}" ]; then
    usage
fi

echo "u = ${u}"
echo "p = ${p}"

exit

#!/usr/bin/env bash

temp_dir() {
    temp_prefix=$(basename "$0")
    mktemp -d /tmp/${temp_prefix}.XXXXXX
}

INSTALL_DIR=$(temp_dir)

trap 'catch' EXIT
catch() {
  rm -rf "$INSTALL_DIR"
  echo "--- ERROR: An error has occurred while running $0"
}

echo "--- Cloning git repository"
git clone https://github.com/git/git "$INSTALL_DIR"
pushd "$INSTALL_DIR"
#echo -e "--- List dir contents\n $(ls -al)"
echo -e "--- Configuring git install\n"
if [[ -e autogen.sh ]]; then
  echo "--- Found an autogen.sh file"
    sh autogen.sh
elif [[ -e configure ]]; then 
  echo "--- Found a ./configure file"
  ./configure
else
  echo "--- No configuration files found"
fi
echo -e "\n--- Configured neovim install"
PS3="Select an install type: "
select opt in "global" "user"; do
    case $REPLY in
        1)
            echo "--- Updating $opt neovim install"
            make CMAKE_BUILD_TYPE=Release
            sudo make install
            break
            ;;
        2)
            echo "--- Updating $opt neovim install"
            make CMAKE_BUILD_TYPE=Release
            make install
            break
            ;;
          *)
            echo "--- Invalid selection"
            exit 1
            ;;
    esac
done
pushd
source "$SHELL"
if ! command -v nvim &> /dev/null; then
  echo "--- Install completed but program isn't on $USER's path"
  exit 1
echo "--- Successfully installed neovim"

