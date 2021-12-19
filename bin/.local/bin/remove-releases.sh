#!/bin/bash

echo "--- Removing tags"
num_tags=$(git tag --list | wc -l)
if [[ $num_tags -eq 0 ]]; then
  echo "--- No tags to delete, exiting."
else
  echo "--- Removing $num_tags releases"
  oldifs="$IFS"
  IFS=$'\t'
  tags=$(git tag --list | awk "{print $1}")
  IFS="$oldifs"
  # readarray -t tags <<< "$(git tag --list 2>&1 | awk '{print $1}')"
  for tag in "$tags"; do
    git push --delete origin "$tag" || continue
    echo "--- Removing remote tag: $tag" || continue
    echo "--- Removing local tag: $tag" || continue
    git tag --delete "$tag" || continue
  done
fi

echo "--- Deleting releases"
num_releases=$(gh release list | wc -l)
if [[ $num_releases -eq 0 ]]; then
  echo "--- No releases to delete, exiting."
else
  echo "--- Removing $num_releases releases"
  releases=$(gh release list --limit 1000 | awk "{print $2}")
  for release in "$releases"; do
    echo "--- Removing $release" || continue
    gh release delete --yes "$release" || continue
  done
fi
