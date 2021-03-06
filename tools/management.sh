#!/bin/sh
set -e

COMMAND="$1"
REPREPRO_BIN="/usr/bin/reprepro"
REPREPRO_CONFDIR="/etc/digabi-repository"
REPREPRO_LOGDIR="/var/log/digabi-repository"

if [ -r /etc/default/digabi-repository-server ]
then
    . /etc/default/digabi-repository-server
fi

REPREPRO_FLAGS="-v --confdir=${REPREPRO_CONFDIR} --basedir=${REPREPRO_BASEDIR} --logdir=${REPREPRO_LOGDIR}"

COMPONENT="main"

if [ -n "${DEBUG}" ]
then
    REPREPRO_FLAGS="${REPREPRO_FLAGS} -V"
fi
REPREPRO="${REPREPRO_BIN} ${REPREPRO_FLAGS}"

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
    echo "E: $@" 1>&2
}
####

# TODO: Receive GPG signing keys in conf/updates
# TODO: Parse options using getopts, add support for -s, -t (source and target repositories)
# TODO: Add support for listing packages $@

####

debug "Arguments: $@"
debug "Running command '${COMMAND}'..."

## Parse options
while getopts as:t:c: o
do
    case "$o"
    in
        a)
            USE_UPSTREAM_ARTIFACTS="1"
        ;;
        c)
            COMPONENT="${OPTARG}"
            debug "Component: ${COMPONENT}"
        ;;
        s)
            SOURCE="${OPTARG}"
            debug "Source: ${SOURCE}"
        ;;
        t)
            TARGET="${OPTARG}"
            debug "Target: ${TARGET}"
        ;;
        *)
            debug "Argument: ${o}"
            error "Invalid option(s)! $o"
            exit 1
        ;;
    esac
done
shift $(($OPTIND-1))
PACKAGES="$@"
##


case "${COMMAND}"
in
    init)
        info "Initializing..."
        ${REPREPRO} export
    ;;
    pull)
        info "Pulling packages..."
        ${REPREPRO} -V pull
    ;;
    import-package)
        if [ -n "${USE_UPSTREAM_ARTIFACTS}" ]
        then
            PACKAGES="upstream-artifacts"
        fi
        info "Importing package(s) '${PACKAGES}' from '${SOURCE}' to '${TARGET}', component '${COMPONENT}'."
    ;;
    do-nothing)
        info "Doing nothing."
        info "TODO: In future, run automatic management tasks: update packages etc."
    ;;
    export)
        info "Exporting..."
        ${REPREPRO} export
    ;;
    snapshot)
        SNAPSHOT_ID="$(date +%Y%m%d%H%M%S).${BUILD_NUMBER:-0}"
        info "Creating snapshot ${SNAPSHOT_ID} from stable..."
        ${REPREPRO} gensnapshot abitti-stable abitti-${SNAPSHOT_ID}
        ${REPREPRO} gensnapshot digabi-stable digabi-${SNAPSHOT_ID}
        ${REPREPRO} gensnapshot debian-stable debian-${SNAPSHOT_ID}
    ;;
    repo-maintenance)
        info "Clearing vanished distributions..."
        ${REPREPRO} clearvanished
        $0 pull
        $0 export
    ;;
    update-mirrors)
        info "Updating mirrors..."
        ${REPREPRO} -V update
        info "Migrating packages from upstream to unstable..."
        $0 pull
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
