#!/usr/bin/env bash

_log() { echo -e "[INFO] ${1}"; }

_err() {
    echo -e "[ERROR] ${1}"
    exit 1
}

SRC_URL=$2
PROGRAM_TARBALL=$(basename "$2")
PROGRAM_SRC=$1
MAKE_OPTS=$2

_log "starting install of $PROGRAM_SRC from $SRC_URL"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR=$(mktemp -d)

if [[ ! $WORK_DIR || ! -d $WORK_DIR ]]; then
    _err "failed creating temp build directory"
fi

function cleanup {
    sudo rm -rf "$WORK_DIR"
    _log "cleaned up tmp build directory"
}

trap cleanup EXIT # cleanup build artifacts on EXIT signals

if command -v curl &> /dev/null; then
    DL_CMD="curl -Lk --output $PROGRAM_TARBALL"
elif command -v wget &> /dev/null; then
    DL_CMD="wget --output-document $PROGRAM_TARBAL:"
else
    _err "cURL & wget not found, exiting"
fi

pushd "$WORK_DIR"
if eval "$DL_CMD $SRC_URL"; then
    mkdir "$PROGRAM_SRC"
    _log "downloaded $PROGRAM_TARBALL tarball, continuing"
    if tar -xvf "$PROGRAM_TARBALL" -C "$PROGRAM_SRC" --strip-components 1; then
        _log "unpacked $PROGRAM_SRC tarball, continuing"
    fi
fi
pushd "$PROGRAM_SRC"
ls -al
_log "configuring $PROGRAM_SRC"
if autoconf; then
    _log "autoconf ran successfully, continuing"
elif autoreconf -iv; then
    _log "autoreconf successful, continuing"
elif sh autogen.sh; then
    _log "ran autogen.sh successfully, continuing"
elif AUTOCONF=autoconf2.69 sh ./autogen.sh; then
    _log "ran autogen.sh successfully, continuing"
elif cmake .; then
    _log "ran cmake successfully, continuing"
else
    _log "failed $PROGRAM_SRC configuration"
fi
if [[ -f configure.ac ]]; then
    if automake; then
        _log "configure.ac file present, executing automake"
    fi
fi
if ./configure; then
    _log "configure file present, executing"
elif ./Configure; then
    _log "Configure file present, executing"
else
    _log "failed $PROGRAM_SRC configuration"
fi
if make --jobs 8; then
    _log "make successful, continuing"
    if sudo make --jobs 8 install; then
        _log "$PROGRAM_SRC installed"
        exit 0
    fi
fi
_err "failed to install $PROGRAM_SRC"
exit 1
