#!/bin/bash
#
# Remove all Docker related resources

if docker container ls 2>/dev/null; then
	echo "--- killing $(docker container ls --all --quiet | wc -l) running containers"
	docker container kill $(docker container ls --quiet)
	docker container stop $(docker container ls --all --quiet)
	echo "--- found $(docker container ls --all --quiet | wc -l) running containers"
	echo "--- pruning docker resources"
  docker system prune --all --force
  echo "--- pruning docker volume(s)"
  docker volume prune --force
	exit 0
else
	echo "ERROR: is docker daemon running?"
	exit 1
fi
