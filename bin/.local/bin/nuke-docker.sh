#!/usr/bin/env bash

docker rm -f -v $(docker ps -aq) || echo "--- Nothing to remove"
docker rmi -f $(docker images -q) || echo "--- No images to remove"
docker volume rm $(docker volume ls -q) || echo "--- No volumes to remove"
docker network rm $(docker network ls -q) || echo "--- No networks to remove"
docker system prune --all --force || echo "--- System pruning failed"
