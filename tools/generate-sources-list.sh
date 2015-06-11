#!/bin/sh
set -e

SUITE="${1:-stable}"
BASE_URL="${2:-http://dev.digabi.fi/debian}"

COMPONENTS="main contrib non-free"

echo "##### BEGIN"
echo "# Debian"
echo "deb ${BASE_URL} debian-${SUITE} ${COMPONENTS}"
echo "#deb-src ${BASE_URL} debian-${SUITE} ${COMPONENTS}"
echo ""
echo "# Third-party components"
echo "deb ${BASE_URL} thirdparty-${SUITE} ${COMPONENTS}"
echo "#deb-src ${BASE_URL} thirdparty-${SUITE} ${COMPONENTS}"
echo ""
echo "# Digabi custom packages"
echo "deb ${BASE_URL} digabi-${SUITE} ${COMPONENTS}"
echo "#deb-src ${BASE_URL} digabi-${SUITE} ${COMPONENTS}"
echo ""
echo "# Abitti computer-based testing software"
echo "deb ${BASE_URL} abitti-${SUITE} ${COMPONENTS}"
echo "#deb-src ${BASE_URL} abitti-${SUITE} ${COMPONENTS}"
echo "##### END"

echo "deb http://dev.digabi.fi/debian jessie main contrib non-free"
