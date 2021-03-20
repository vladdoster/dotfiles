#!/usr/bin/env bash

# Installs latest version of GNU stow from source
#

# error handling
_err() {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
    make clean
    _cleanup
    exit 1
}

set -o errtrace
trap _err ERR

_main() {
    _get_stow_src
    _enter_stow_src
    _make_stow
    _install_stow
    _cleanup
}

_get_stow_src() {
    # configure and Makefile are included in official releases of Stow, but they are
    # deliberately omitted from the git repository because they are autogenerated.
    # Therefore if you are installing directly from git, they need to be generated.
    STOW_SRC="stow-latest"
    echo "--- Downloading GNU stow"
    if curl --fail-early --output $STOW_SRC.tar.gz \
        --url http://ftp.gnu.org/gnu/stow/$STOW_SRC.tar.gz; then
        echo "--- Extracting GNU stow src"
        mkdir -p $STOW_SRC
        tar -xzf $STOW_SRC.tar.gz -C $STOW_SRC --strip-components=1
        rm $STOW_SRC.tar.gz
        if [[ ! -d $STOW_SRC ]]; then
            echo "--- No $STOW_DIR found, exiting..."
            exit 1
        fi
    fi
}

_enter_stow_src() {
    echo "--- Entering stow src dir "
    cd $(\ls -1dt ./stow*/ | head -n 1)
}

_make_stow() {
    echo "--- Running ./configure"
    ./configure || echo "ERROR: .configure failed"
    echo "--- Running make"
    make || echo "ERROR: make failed"
}

_install_stow() {
    echo "--- Running make install"
    sudo make install || echo "ERROR: make install failed"
    if test -x $(which stow); then
        echo "--- GNU stow successfully installed"
        exit 0
    else
        echo "--- GNU stow failed to install"
        exit 1
    fi
}

_cleanup() {
    rm -rf ../$STOW_SRC*
    echo "--- Cleaned up tmp resources"
}

_main "${@}"
