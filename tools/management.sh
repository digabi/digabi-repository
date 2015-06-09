#!/bin/sh
set -e

COMMAND="$1"
REPREPRO="/usr/bin/reprepro"

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
####

# TODO: Receive GPG signing keys in conf/updates

####

debug "Running command '${COMMAND}'..."

case "${COMMAND}"
in
    update-mirrors)
        info "Updating mirrors..."
        ${REPREPRO} -V update
    ;;
    *)
        error "Unknown command '${COMMAND}'!"
        exit 1
    ;;
esac
