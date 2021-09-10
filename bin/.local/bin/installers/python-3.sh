#!/bin/bash

PROGRAM="python"
SRC_URL="https://github.com/${PROGRAM}/cpython.git"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR=$(mktemp -d)

if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    echo "--- failed creating temp dir"
    exit 1
fi

function cleanup() {
    sudo rm -rf "$WORK_DIR"
    echo "--- cleaned up tmp build dir"
}

# cleanup build artifacts on EXIT signals
trap cleanup EXIT

#-- CONFIGURE, BUILD, INSTALL
echo "--- entering tmp work dir $PWD"
pushd "$WORK_DIR"
if git clone --depth 1 "$SRC_URL" "$PROGRAM"; then
    echo "--- cloned $PROGRAM, continuing"
fi
pushd "$PROGRAM"
if autoreconf -iv; then
    echo "--- autoreconf successfully, continuing"
fi
if sh autogen.sh; then
    echo "--- autogen.sh successful, continuing"
fi
if ./configure --enable-optimizations --with-lto; then
    echo "--- configure successful, continuing"
fi
echo "--- compiling $PROGRAM"
make -j8
echo "--- installing $PROGRAM"
sudo make install
echo "--- installed $PROGRAM"
exit 0
