#!/usr/bin/env bash

echo "--- Cleaning docker-compose resources"
if [[ $# -gt 0 ]]; then
    docker compose --file "$1" down --remove-orphans --rmi all --volumes 2> /dev/null
else
    docker compose down --remove-orphans --rmi all --volumes 2> /dev/null
fi
echo "--- Pruning system Docker resources"
docker system prune --all --force --volumes 2> /dev/null

# Kills all runnign containers and removes any Docker resources.
(
    docker kill --signal=KILL $(docker ps --quiet) \
        && echo "--- Stopped all running containers"
) || echo "--- No containers running"

(
    docker container rm --force --volumes $(docker container ls --quiet) \
        && echo "--- Removed all running containers"
) || echo "--- No containers removed"

(
    docker network rm $(docker network ls --quiet) \
        && echo "--- Removed all running containers"
) || echo "--- All networks removed"

(
    docker system prune --all --force --volumes \
        && echo "--- Removed all running containers"
) || echo "--- Docker resources removed"
