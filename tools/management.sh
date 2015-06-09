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
    do-nothing)
        info "Doing nothing."
        info "TODO: In future, run automatic management tasks: update packages etc."
    ;;
    update-mirrors)
        info "Updating mirrors..."
        ${REPREPRO} -V update
    ;;
    receive-gpg-keys-for-upstreams)
        error "TODO"
    ;;
    *)
        error "Unknown command '${COMMAND}'!"
        exit 1
    ;;
esac
