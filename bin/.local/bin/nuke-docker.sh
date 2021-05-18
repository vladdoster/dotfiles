#!/usr/bin/env bash

echo "--- Cleaning docker-compose resources"
if [[ $# -gt 0 ]]; then
    docker-compose --file "$1" down --remove-orphans --rmi all --volumes 2> /dev/null
else
    docker-compose down --remove-orphans --rmi all --volumes 2> /dev/null
fi
echo "--- Pruning system Docker resources"
docker system prune --all --force --volumes 2> /dev/null
