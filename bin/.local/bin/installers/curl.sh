#!/bin/bash
#
# Install neovim from source

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# the temp directory used, within $DIR
# omit the -p parameter to create a temporal directory in the default location
WORK_DIR=$(mktemp -d)

# check if tmp dir was created
if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    echo "--- Failed to create temp dir"
    exit 1
fi

# deletes the temp directory
function cleanup {
    sudo rm -rf "$WORK_DIR"
    echo "--- Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

# implementation of script starts here
# --------------------------------------------
PROGRAM="curl"
GIT_URL="https://github.com/curl/curl.git"

pushd "$WORK_DIR"
echo "--- Entered tmp work dir $PWD"
echo "--- Cloning $PROGRAM"
git clone "$GIT_URL" "$PROGRAM"
cd "$PROGRAM"
if autoreconf -iv; then
    echo "--- Ran autoreconf successfully, continuing"
fi
if [[ -e autogen.sh ]]; then
    echo "--- Found autogen.sh, executing "
    sh autogen.sh
fi
if [[ -e ./configure ]]; then
    echo "--- Found configure, executing "
    ./configure --with-ssl
fi
echo "--- Compiling $PROGRAM"
make -j8
echo "--- Installing $PROGRAM"
sudo make install
popd
echo "--- Installed $PROGRAM"
