#!/bin/sh

# Sync APT repository to server
# (c) 2014 Ylioppilastutkintolautakunta
# Author: Ville Korhonen <ville.korhonen@ylioppilastutkinto.fi>

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

SOURCE="./www"
TARGET="${REPOSITORY_TARGET}"

echo rsync -avh "${SOURCE}" "${REPOSITORY_TARGET}"
