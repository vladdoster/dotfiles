#!/usr/bin/env bash

function log() { echo "--- $1"; }

function merge {
	log "pulling any changes on branch"
	git pull --rebase
	log "cherry-picking commit: $1"
	git cherry-pick -x "$1"
	git status

	echo "Proceed with commit? (y/N):"
	read XN

	if [ "$XN" = "y" ]; then
		log "committing"
		git push origin
	else
		log "user aborted cherry-picking commit"
		exit
	fi
}

if [ ! -n "$1" ]; then
	echo "Usage: cherrypick.sh <hash> [<branch1> <branch2> <branch3> ...]"
	echo
	echo "e.g. cherrypick.sh fb5cfe1cf2165abee 1.0.0 1.1.0 1.2.0"
	exit
fi

if [ ! -n "$2" ]; then
	log "cherry-picking to current branch"
	merge "$1"
else
	for arg in "${@:2}"; do
		git checkout "$arg"
		merge "$1"
	done
fi
