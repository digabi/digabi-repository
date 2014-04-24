#!/bin/sh

# Sync APT repository to server
# (c) 2014 Ylioppilastutkintolautakunta
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>

RSYNC="/usr/bin/rsync"
RSYNC_FLAGS="-avz"
SOURCE="./www/debian/"

if [ -z "${REPOSITORY_SYNC_USER}" ]
then
    REPOSITORY_SYNC_USER="reposync"
fi

if [ -z "${REPOSITORY_SYNC_HOST}" ]
then
    REPOSITORY_SYNC_HOST="digabi.fi"
fi

if [ -z "${REPOSITORY_PATH}" ]
then
    REPOSITORY_PATH="/srv/digabi-repository/"
fi

${RSYNC} ${RSYNC_FLAGS} "${SOURCE}" "${REPOSITORY_SYNC_USER}@${REPOSITORY_SYNC_HOST}:${REPOSITORY_TARGET}"
