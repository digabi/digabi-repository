#
# Makefile for controlling our custom repository
#

DISTRIBUTION ?= jessie

SYNC_USER = reposync
SYNC_HOST = dev.digabi.fi
SYNC_PATH = repository

COMPONENT ?= main

DEB =

SYNC_TARGET = $(SYNC_USER)@$(SYNC_HOST):$(SYNC_PATH)
#SYNC_DIRS = ./db/ ./www/debian/pool/ ./www/debian/dists/


SYNC_FLAGS = -aqs --progress
REPO_FLAGS = --ignore=brokenversioncmp

SYNC_CMD = /usr/bin/rsync
REPO_CMD = /usr/bin/reprepro

add-package:
	$(REPO_CMD) $(REPO_FLAGS) -C $(COMPONENT) includedeb $(DISTRIBUTION) $(DEB) || echo -n

sync-to-server:
	$(SYNC_CMD) $(SYNC_FLAGS) ./db/ $(SYNC_TARGET)/db/
	$(SYNC_CMD) $(SYNC_FLAGS) ./www/debian/pool/ $(SYNC_TARGET)/www/debian/pool/
	$(SYNC_CMD) $(SYNC_FLAGS) ./www/debian/dists/ $(SYNC_TARGET)/www/debian/dists/

sync-from-server:
	$(SYNC_CMD) $(SYNC_FLAGS) $(SYNC_TARGET)/www/debian/pool/ ./www/debian/pool/
	$(SYNC_CMD) $(SYNC_FLAGS) $(SYNC_TARGET)/www/debian/dists/ ./www/debian/dists/
	$(SYNC_CMD) $(SYNC_FLAGS) $(SYNC_TARGET)/db/ ./db/

