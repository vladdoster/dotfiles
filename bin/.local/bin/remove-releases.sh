#!/usr/bin/env bash

echo "--- Removing tags"
num_tags=$(git tag --list | wc -l)
if [[ $num_tags -eq 0 ]]; then
    echo "--- No tags to delete, exiting."
else
    echo "--- Removing $num_tags releases"
    tags=$(git tag --list | awk '{print $1}')
    for tag in $tags; do
        git push --delete origin $tag
        echo '--- Removing remote tag: $tag'
        echo '--- Removing local tag: $tag'
        git tag --delete $tag
    done
fi

echo "--- Deleting releases"
num_releases=$(gh release list | wc -l)
if [[ $num_releases -eq 0 ]]; then
    echo "--- No releases to delete, exiting."
else
    echo "--- Removing $num_releases releases"
    releases=$(gh release list --limit 1000 | awk '{print $2}')
    for release in $releases; do
        echo '--- Removing $release'
        gh release delete --yes $release
    done
fi
