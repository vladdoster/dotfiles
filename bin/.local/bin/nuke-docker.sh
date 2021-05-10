#!/usr/bin/env bash

docker rm -f -v $(docker ps -aq) >/dev/null || echo "--- Nothing to remove"
docker rmi -f $(docker images -q) >/dev/null || echo "--- No images to remove"
docker volume rm $(docker volume ls -q) >/dev/null || echo "--- No volumes to remove"
docker network rm $(docker network ls -q) >/dev/null || echo "--- No networks to remove"
docker system prune --all --force >/dev/null || echo "--- System pruning failed"
