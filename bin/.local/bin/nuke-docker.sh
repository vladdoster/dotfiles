#!/bin/bash
#
# Remove all Docker related resources

echo "--- killing $(docker container ls --all --quiet | wc -l) running containers"
docker container stop --time 5 "$(docker container ls --all --quiet)"
echo "--- found $(docker container ls --all --quiet | wc -l) running containers"

echo "--- pruning docker resources"
docker system prune --all --force --volumes
