#!/bin/sh
set -ex
docker build --no-cache --progress=plain -t krautsalad/symlinks:latest -f Dockerfile .
