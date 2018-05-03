# Tunneller #
###### A SOCKS Server ######
[![Build Status](https://travis-ci.org/ashenm/tunneller.svg?branch=master)](https://travis-ci.org/ashenm/tunneller)

## USAGE ##

### Using `scripts/run.sh` ###

##### Basic Usage #####
`./run.sh <PATH TO PRIVATE KEY> <TUNNELLER HOSTNAME>`

##### Additional Options #####

    ./run.sh [OPTIONS] <PATH TO PRIVATE KEY> <TUNNELLER HOSTNAME>

    Options:

          --dev                 Run in development mode.
                                Run Tunneller locally and spawns a session against it

      -f  --forward             Specify [ADDRESS:]PORT for local dynamic
                                application-level port forwarding (default 'localhost:5050')

          --help                Print usage

      -p  --port                Specify endpoint port to connect (defaut '2222')

      -u  --user                Specify the user to log in as (default 'alpine')

### Using a SSH Client ###

Alternately, a SSH client can be used to spawn a session. For instance, with OpenSSH to bound local port `8080` using private key `~/.ssh/id_dsa` for authentication

`ssh -N -D 8080 -i ~/.ssh/id_dsa -l alpine -p 2222 example.org`

> Note: The use of flag `N` is important since the unprivileged user loggings are disabled
