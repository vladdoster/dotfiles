#!/bin/bash
#
#Install tmux from source

GIT_URL="https://github.com/tmux/tmux.git"
PKG_PATH="$(echo ${GIT_URL} | grep / | cut -d/ -f2-)"

echo "---Installing ${PKG_PATH##*/}"

if [[ -d ${PKG_PATH##*/} ]]; then
    rm -rf "${PKG_PATH##*/}"
fi

git clone "${GIT_URL}" "${PKG_PATH##*/}" && cd "${PKG_PATH##*/}" || exit 1

if [[ -e autogen.sh ]]; then
    sh autogen.sh
fi

if ./configure $*; then
    if make; then
        if sudo make install; then
            echo "---Installed tmux"
        else
            echo "ERROR: tmux install failed"
        fi
    fi
fi
