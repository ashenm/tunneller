#!/usr/bin/env sh

set -e

# image name
BUILD_TARGET=ashenm/tunneller

# remove only `dev` tag if
# not explicitly specified
test ! "$1" = "-a" \
  -a ! "$1" = "--all" \
    && BUILD_TARGET="$BUILD_TARGET:dev"

# remove all `BUILD_TARGET` images
docker images --all "$BUILD_TARGET" | awk 'NR>1 { print $1":"$2 }' | xargs -r docker rmi
