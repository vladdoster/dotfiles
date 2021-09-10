#!/bin/bash

SRC_URL=$1
PROGRAM_TARBALL="$(basename $1)"
PROGRAM_SRC=$(basename $PROGRAM_TARBALL .tar.gz)

echo "--- installing $PROGRAM from $SRC_URL"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR=$(mktemp -d)

if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    echo "--- failed creating temp build dir"
    exit 1
fi

function cleanup {
    sudo rm -rf "$WORK_DIR"
    echo "--- cleaned up tmp build dir"
}

# cleanup build artifacts on EXIT signals
trap cleanup EXIT

#-- CONFIGURE, BUILD, INSTALL
echo "--- entering build dir $PWD"
pushd "$WORK_DIR"
if wget "$SRC_URL"; then
    echo "--- downloaded $PROGRAM_TARBALL tarball, continuing"
    if tar -xvf "$PROGRAM_TARBALL"; then
        echo "--- unpacked $PROGRAM_SRC tarball, continuing"
    fi
fi
pushd "$PROGRAM_SRC"
if ./configure; then
    echo "--- configure successful, continuing"
fi
echo "--- compiling $PROGRAM"
make
echo "--- installing $PROGRAM"
sudo make install
echo "--- installed $PROGRAM"
exit 0
