#!/bin/sh
set -ex

SYMLINKS_VERSION=1.4.3

docker build \
    --build-arg SYMLINKS_VERSION=${SYMLINKS_VERSION} \
    --no-cache --progress=plain -t krautsalad/symlinks:latest -f docker/Dockerfile .
docker push krautsalad/symlinks:latest

VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)")

docker tag krautsalad/symlinks:latest krautsalad/symlinks:${VERSION}
docker push krautsalad/symlinks:${VERSION}
