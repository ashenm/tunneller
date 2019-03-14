#!/usr/bin/env sh
# Build Docker Image

set -e

# clinch permissions
find tunneller -type d -exec chmod 755 {} \;
find tunneller/etc -type f -exec chmod 644 {} \;
find tunneller/sbin -type f -exec chmod 755 {} \;

# build docker image
docker build --no-cache --tag "${TRAVIS_REPO_SLUG:-ashenm/tunneller}:${TRAVIS_BRANCH:-latest-alpha}" .
