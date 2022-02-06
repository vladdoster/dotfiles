#!/usr/bin/env bash
#
# Remove remote and local git tags
git tag -d $(git tag -l) # Fetch remote tags.
git fetch # Delete remote tags.
git push origin --delete $(git tag -l) # Pushing once should be faster than multiple times
git tag -d $(git tag -l) # Delete local tags.
