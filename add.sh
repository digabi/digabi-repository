#!/bin/sh

PACKAGE="$1"
DIST="$(cat ./conf/distributions |grep ^Codename: |awk '{print $2}')"

reprepro includedeb ${DIST} "${PACKAGE}"
