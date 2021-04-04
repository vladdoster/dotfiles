#!/bin/bash
set -e

# Takes either a git URL or file path and attempts to install it

_cleanup() {
    rm -rf "$program"
    echo "--- Cleaned up $program resources"
}

_err() {
    echo "ERROR: something went wrong"
    _cleanup
    exit 1
}

_main() {
    program_url=$1
    program="$(basename "$1" .git)"
    _get_src_code
    _make_install
    _cleanup
}

_get_src_code() {
    echo "--- Pulling down $program source code"
    if [[ -d $program ]]; then
        sudo -u "$USER" rm -rf "$program"
    fi
    echo 'sudo -u "$USER" git clone --depth 1 "$program_url" "$program"'
    if sudo -u "$USER" git clone --depth 1 "$program_url" "$program"; then
        echo "- cloned $program git repository"
    else
        curl --fail-early --output "$program" --url "$program_url"
        tar -xf "$program" || echo "failed to extract download"
    fi
    cd "$program" || exit 1
    echo "--- Starting install process in $PWD"
}

_make_install() {
    echo "--- Compiling source"
    #    if [[ -d "automake" ]]; then
    #        echo "--- Generating components via autoreconf"
    #        autoreconf -iv
    #    fi
    echo "--- Building source via autotools"
    ./configure && make
    echo "--- Installing via autotools"
    sudo make install
}

trap _err ERR
_main "$@"
