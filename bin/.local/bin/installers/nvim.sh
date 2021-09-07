#!/bin/bash

PROGRAM="nvim"
SRC_URL="https://github.com/neovim/neovim.git"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR=$(mktemp -d)

if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    echo "--- failed to create temp dir"
    exit 1
fi

function cleanup { # delete the temp directory
    sudo rm -rf "$WORK_DIR"
    echo "--- deleted temp working directory $WORK_DIR"
}

# register cleanup function to be called on the EXIT signal
trap cleanup EXIT

# install logic
# --------------------------------------------
echo "--- entering tmp work dir $PWD"
pushd "$WORK_DIR"
echo "--- cloning $PROGRAM"
git clone --branch=release-0.5 "$SRC_URL" "$PROGRAM"
cd "$PROGRAM"
if autoreconf -iv; then
    echo "--- ran autoreconf successfully, continuing"
fi
if [[ -e autogen.sh ]]; then
    echo "--- found autogen.sh, executing "
    sh autogen.sh
fi
if [[ -e ./configure ]]; then
    echo "--- found configure, executing "
    ./configure
fi
echo "--- compiling $PROGRAM"
make -j8 CMAKE_BUILD_TYPE=Release
echo "--- installing $PROGRAM"
sudo make install
popd
echo "--- installed $PROGRAM"
