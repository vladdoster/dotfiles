#!/bin/bash

docker rm --force $(docker ps --all -q) && \
docker rmi --force $(docker images --all -q) && \
printf "docker was nuked successfully"
