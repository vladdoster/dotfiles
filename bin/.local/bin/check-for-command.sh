#!/usr/bin/env bash

command -v "$1" > /dev/null 2>&1 || {
    echo >&2 "--- ERROR: $1 is required, but it's not callable. Exiting."
    exit 1
}
