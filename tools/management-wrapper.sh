#!/bin/sh
set -e

[ -r /etc/default/digabi-repository-server ] && . /etc/default/digabi-repository-server

sudo -u digabi-repository /usr/lib/digabi-repository/repository-management.sh $@
