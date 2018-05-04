#!/usr/bin/env sh

set -e

# image tag
BUILD_TARGET=ashenm/tunneller

# remove all `BUILD_TARGET` images
docker images --all "$BUILD_TARGET" | awk 'NR>1 { print $1":"$2 }' | xargs -r docker rmi
