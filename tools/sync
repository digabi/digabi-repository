#!/bin/sh

# Sync APT repository to server
# (c) 2014 Ylioppilastutkintolautakunta
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>

RSYNC="/usr/bin/rsync"
RSYNC_FLAGS="-aqz --progress"
RSYNC_USER="reposync"
RSYNC_HOST="digabi.fi"
RSYNC_PATH="repository/"

SYNC_DIRS="./db/ ./www/debian/pool/ ./www/debian/dists/"

DIRECTION="$1"

usage() {
    echo "usage: $0 <from-server|to-server>"
}

if [ -z "${DIRECTION}" ]
then
    usage
    exit 1
fi

if [ "${DIRECTION}" != "from-server" ] && [ "${DIRECTION}" != "to-server" ]
then
    echo "Invalid direction: ${DIRECTION}"
    usage
    exit 1
fi

for source in ${SYNC_DIRS}
do
    TARGET="${RSYNC_USER}@${RSYNC_HOST}:${RSYNC_PATH}$(echo ${source} |sed 's/^\.\///g')"
    if [ "${DIRECTION}" = "from-server" ]
    then
        # We should switch source <> target
        _TARGET="${source}"
        source="${TARGET}"
        TARGET="${_TARGET}"
    fi
    echo "Syncing ${source} to ${TARGET}..."
    ${RSYNC} ${RSYNC_FLAGS} "${source}" "${TARGET}"
done
