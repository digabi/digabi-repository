#!/bin/sh

# Sync APT repository to server
# (c) 2014 Ylioppilastutkintolautakunta
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>

# Note: You MUST define REPOSITORY_TARGET in your ~/.digabirc
# Format: username@host:/target/path

RSYNC="/usr/bin/rsync"
RSYNC_FLAGS="-avh"
SOURCE="./www"

if [ -f "${HOME}/.digabirc" ]
then
    . "${HOME}/.digabirc"
else
    echo "E: File ~/.digabirc not found, exiting..."
    exit 1
fi

if [ -z "${REPOSITORY_TARGET}" ]
then
    echo "E: \$REPOSITORY_TARGET not specified in ~/.digabirc, exiting..."
    exit 1
fi


${RSYNC} ${RSYNC_FLAGS} "${SOURCE}" "${REPOSITORY_TARGET}"
