#!/bin/bash

num_tags=$(git tag --list | wc -l)
if [[ $num_tags -eq 0 ]]; then
	echo "--- No tags to delete, skipped"
else
	# $(git tag -l | xargs -n 1 git push --delete origin) || continue
	# $(git tag -l | xargs -n 1 git tag --delete) || continue
	echo "--- Deleting $num_tags remote tags"
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
	echo "--- $(git tag --list | wc -l) tag(s) exist"
fi

num_releases=$(gh release list | wc -l)
if [[ $num_releases -eq 0 ]]; then
	echo "--- No releases to delete, skipped"
else
	oldifs="$IFS"
	IFS=$'\n'
	releases=$(gh release list --limit 1000 | awk '{print $5}')
	echo "--- Removing $num_releases releases"
	for release in "$releases"; do
		gh release delete --yes "$release" || continue
	done
	echo "--- $(gh release list | wc -l) release(s) exist"
fi
