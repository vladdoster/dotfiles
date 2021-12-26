#!/bin/bash
#
# Remove all Docker related resources

if docker container ls; then
  echo "--- killing $(docker container ls --all --quiet | wc -l) running containers"
  docker container stop --time 5 "$(docker container ls --all --quiet)"
  echo "--- found $(docker container ls --all --quiet | wc -l) running containers"

  echo "--- pruning docker resources"
  docker system prune --all --force --volumes
  exit 0
else
  echo "ERROR: is docker running?"
  exit 1
fi
