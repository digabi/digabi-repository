#!/bin/sh
set -e

CURDIR="$(realpath $(dirname $0)/../)"
LISTS="$(grep -h ^Name: ${CURDIR}/conf/pulls ${CURDIR}/conf/updates |awk '{print $2}' |sort -u)"

for list in ${LISTS}
do
    LIST="${CURDIR}/conf/packages/${list}"
    if [ -f "${CURDIR}/conf/packages/${list}" ]
    then
        echo "I: Package list already exists: ${LIST}."
    else
        echo "I: Creating package list: ${LIST}."
        touch ${LIST}
    fi
done
