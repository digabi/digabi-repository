#!/bin/sh
set -e

COMMAND="$1"
REPREPRO="/usr/bin/reprepro"
REPREPRO_FLAGS=""
if [ -n "${DEBUG}" ]
then
    REPREPRO_FLAGS="${REPREPRO_FLAGS} -V"
fi

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
# TODO: Parse options using getopts, add support for -s, -t (source and target repositories)
# TODO: Add support for listing packages $@

####

debug "Running command '${COMMAND}'..."

case "${COMMAND}"
in
    do-nothing)
        info "Doing nothing."
        info "TODO: In future, run automatic management tasks: update packages etc."
    ;;
    repo-maintenance)
        info "Clearing vanished distributions..."
        ${REPREPRO} clearvanished
    ;;
    update-mirrors)
        info "Updating mirrors..."
        ${REPREPRO} -V update
    ;;
    receive-gpg-keys-for-upstreams)
        error "TODO"
    ;;
    remove-lockfile)
        PID="$(pidof reprepro || true)"
        if [ -z "${PID}" ]
        then
            info "Removing reprepro lockfile..."
            rm -f ./db/lockfile || true
        else
            error "Reprepro running, not removing lockfile!"
        fi
    ;;
    *)
        error "Unknown command '${COMMAND}'!"
        exit 1
    ;;
esac
