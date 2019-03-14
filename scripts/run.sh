#!/usr/bin/env sh
# Start a dynamic application-level port forwarding session

set -e

#######################################
# Print usage instructions to STDIN
# Arguments:
#   None
# Returns:
#   None
#######################################
usage() {

cat <<USAGE

Usage: $SELF [OPTIONS] <PATH TO PRIVATE KEY> <TUNNELLER HOSTNAME>
Spawn a dynamic port forwarding session

Options:
      --dev                 Run in development mode.
                            Runs tunneller locally and spawns session against it
  -f  --forward             Specify [ADDRESS:]PORT for local dynamic
                            application-level port forwarding (default 'localhost:5050')
      --help                Print usage
  -p  --port                Specify endpoint port to connect (defaut '2222')
  -u  --user                Specify the user to log in as (default 'alpine')

USAGE

}

#######################################
# Print invalid argument details to STDERR
# Arguments:
#   Invalid argument
# Returns:
#   None
#######################################
invalid() {

cat >&2 <<INVALID

$SELF: unrecognized option '$1'
Try '--help' flag for more information.

INVALID

}

# script reference
SELF="$(basename "$0")"

# tunneller defaults
ENDPOINT_PORT='2222'
ENDPOINT_USER='alpine'

# local bounding address
SOURCE_ADDRESS='localhost:5050'

# parse options
while [ $# -ne 0 ]
do

  case "$1" in

    -h|--help)
      usage
      exit 0
      ;;

    --dev)
      SELF_HOSTED=true
      shift
      ;;

    -p|--port)
      ENDPOINT_PORT="${2:?Invalid PORT}"
      shift 2
      ;;

    -f|--forward)
      SOURCE_ADDRESS="${2:?Invalid BIND_ADDRESS}"
      shift 2
      ;;

    -u|--user)
      ENDPOINT_USER="${2:?Invalid USER}"
      shift 2
      ;;

    -*|--*)
      invalid "$1"
      exit 1
      ;;

    *)
      break
      ;;

  esac

done

# ensure requisites
PRIVATE_KEY="${1:?Invalid PRIVATE_KEY}"
ENDPOINT_HOSTNAME="${2:?Invalid TUNNELLER}"

# run development mode
test $SELF_HOSTED && {

  # scripts directory
  SCRIPT_DIRECTORY="$(dirname "$(readlink -f "$BASH_SOURCE")")"

  # build local image
  $SCRIPT_DIRECTORY/build.sh

  # override tunneller parameters
  ENDPOINT_USER='alpine'
  ENDPOINT_HOSTNAME='localhost'
  ENDPOINT_PORT='2222'

  # container name
  CONTINER_REFERENCE="tunneller-dev-$RANDOM"

  # trim bind address
  # to extract only port
  SOURCE_ADDRESS="$(echo $SOURCE_ADDRESS | sed 's/^.*://')"

  # spin docker container
  docker run --rm --detach --name "$CONTINER_REFERENCE" --publish "$ENDPOINT_PORT":"$ENDPOINT_PORT" "${TRAVIS_REPO_SLUG:-ashenm/tunneller}:${TRAVIS_BRANCH:-latest-alpha}"

  # clean on exit
  trap "docker stop $CONTINER_REFERENCE; exit" EXIT

}

# spawn port forwarding
ssh -N -D "$SOURCE_ADDRESS" -i "$PRIVATE_KEY" -p "$ENDPOINT_PORT" -l "$ENDPOINT_USER" "$ENDPOINT_HOSTNAME"
