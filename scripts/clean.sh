#!/usr/bin/env sh
# Remove Docker Image(s)

set -e

# select only `latest-alpha` tag
# unless explicitly specified
test "$1" = "-a" \
  -o "$1" = "--all" \
    && TRAVIS_BRANCH="*"

# remove all selected images
docker images --filter reference="${TRAVIS_REPO_SLUG:-ashenm/tunneller}:${TRAVIS_BRANCH:-latest-alpha}" \
  | awk 'NR>1 { print $3 }' \
  | xargs -r docker rmi
