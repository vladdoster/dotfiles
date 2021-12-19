#!/usr/bin/env bash

set -e

function check_changelog() {
    if [[ ! -f ./CHANGELOG ]]; then
        touch CHANGELOG
    fi
}

function get_changelog() {
    local currentTag previousTag prevChangelogContents
    currentTag=$(git describe --abbrev=0 --tags "$(git describe --abbrev=0)"^)
    previousTag=$(git describe --abbrev=0)
    prevChangelogContents=$(cat ./CHANGELOG)

    {
        echo "## $currentTag"
        echo ""
        git log --short --no-merges "$currentTag...$previousTag" | grep -v "Upgrade to"
        echo ""
    } > CHANGELOG
    echo "$prevChangelogContents" >> CHANGELOG
}

function main() {
    check_changelog
    get_changelog
}

main
