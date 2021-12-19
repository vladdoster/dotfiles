#!/usr/bin/env bash

echo "--- delete local tags"
git tag -d "$(git tag -l)"
echo "--- fetch remote tags"
git fetch
echo "--- delete remote tags"
git push origin --delete "$(git tag -l)"
echo -e "--- delete local tags\n"
git tag -d "$(git tag -l)"
echo "--- checking out tmp orphan branch"
git checkout --orphan develop
echo "--- creating commit"
git commit -m "(init): creating $(basename "$(git rev-parse --show-toplevel)") repository"
echo "--- moving local branch to master"
git branch -f master
echo "--- checking out master branch"
git checkout master
echo "--- deleting tmp orphan branch"
git branch -d develop
