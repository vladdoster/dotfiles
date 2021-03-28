#!/bin/bash

command -v foo > /dev/null 2>&1 || {
    echo >&2 "I require foo but it's not installed.  Aborting."
    exit 1
}
