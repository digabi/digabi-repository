#!/bin/sh
set -e

COMMAND="$1"
if [ -z "${COMMAND}" ]
then
    echo "usage: $0 <command>"
    exit 1
fi
shift

##
debug() {
    if [ -n "${DEBUG}" ]
    then
        echo "D: $@"
    fi
}

info() {
    echo "I: $@"
}

error() {
    echo "E: $@"
}
##

debug "Running command '${COMMAND}'..."

case "${COMMAND}"
in
    *)
        error "Unknown command '${COMMAND}'!"
        exit 1
    ;;
esac
