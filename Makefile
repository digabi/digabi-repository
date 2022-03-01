NAME ?= digabi
RELEASE ?= stable
BASE_URL ?= http://dev.digabi.fi/debian

ROOT_CA = ytl-net-root-ca.crt
LOCALCERTSDIR = /usr/share/ca-certificates/digabi

install:
	# digabi-certificates
	install -D -m 0644 other-keys/$(ROOT_CA) $(DESTDIR)/$(LOCALCERTSDIR)/$(ROOT_CA)

deb:
	dpkg-buildpackage -us -uc

.PHONY: clean build install
