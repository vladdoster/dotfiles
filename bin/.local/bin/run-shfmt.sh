#!/bin/bash

docker run --volume "$PWD":/mnt \
    --rm \
    mvdan/shfmt -bn -ci -i 4 -ln=bash -s -sr -w /mnt
