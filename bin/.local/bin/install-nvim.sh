#!/usr/bin/env bash

# the directory of the script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# the temp directory used, within $DIR
# omit the -p parameter to create a temporal directory in the default location
WORK_DIR=$(mktemp -d)

# check if tmp dir was created
if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    echo "Could not create temp dir"
    exit 1
fi

# deletes the temp directory
function cleanup {
    rm -rf "$WORK_DIR"
    echo "Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

# implementation of script starts here

pushd "$WORK_DIR"
echo "--- entered work dir $PWD"
echo "--- cloning neovim"
git clone https://github.com/neovim/neovim
cd neovim
echo "--- compiling neovim"
make CMAKE_BUILD_TYPE=Release
echo "--- installing neovim"
sudo make install
popd
