#!/usr/bin/env sh
# Build Docker Image

set -e

# clinch permissions
find ssh -type d -exec chmod 755 {} \;
find ssh/etc -type f -exec chmod 644 {} \;
find ssh/sbin -type f -exec chmod 755 {} \;

# build docker image
docker build --no-cache --tag "${TRAVIS_REPO_SLUG:-ashenm/tunneller}:${TRAVIS_BRANCH:-latest-alpha}" .
