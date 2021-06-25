#!/bin/bash
#
# Install tmux from source

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
PROGRAM="gcc-5.4.0"
SOURCE_URL="https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.bz2"
SOURCE_ARCHIVE=$(basename $SOURCE_URL)

#pushd "$WORK_DIR"
echo "--- Entered tmp work dir $PWD"
echo "--- Downloading $PROGRAM source tarball..."
curl --show-error "$SOURCE_URL" --output "$SOURCE_ARCHIVE"
echo "--- Extracting files..."
tar xvfj "$SOURCE_ARCHIVE" | (pv -p --timer --rate --bytes > $PROGRAM)
echo "--- Removing source archive"
rm $SOURCE_ARCHIVE
echo "--- Installing dependencies..."
sudo yum -y install gmp-devel mpfr-devel libmpc-devel
echo "--- Entering $PROGRAM dir..."
pushd "$PROGRAM"
echo "--- Configuring..."
./configure --enable-languages=c,c++ --disable-multilib
echo "--- Compiling $PROGRAM"
make -j$(nproc)
echo "--- Installing $PROGRAM"
sudo make install
echo "--- Installed $PROGRAM"
