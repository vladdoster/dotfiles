#!/bin/bash
# Installs latest Homebrew version
set -e

# error handling
traperr() {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
    make clean
    _cleanup
    exit 1
}

set -o errtrace
trap traperr ERR

_main() {
    _install_brew
    _cleanup
}

_install_brew() {
    echo "--- Running Brew install script"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_cleanup() {
    echo "--- Cleaned up tmp resources"
}

_main "${@}"
