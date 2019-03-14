#!/usr/bin/env sh
# Deploy to to hub.docker.com

set -e

# authenticate
echo "${DOCKER_PASSWORD}" \
  | docker login --username "${DOCKER_USERNAME}" --password-stdin

# deploy docker image
docker push "${TRAVIS_REPO_SLUG:-ashenm/tunneller}:${TRAVIS_BRANCH:-latest-alpha}"
