#!/usr/bin/env sh

set -e

# image label
BUILD_TAG=dev
BUILD_IMAGE=ashenm/tunneller

# scripts directory
SCRIPT_DIRECTORY="$(dirname "$(readlink -f "$BASH_SOURCE")")"

# handle custom tag
test "$1" = "-t" \
  -o "$1" = "--tag" \
    && BUILD_TAG="${2:?Invalid TAG}"

# build image
docker build --no-cache --tag "$BUILD_IMAGE:$BUILD_TAG" "$(dirname "$SCRIPT_DIRECTORY")"
