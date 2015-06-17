NAME ?= digabi
RELEASE ?= stable
BASE_URL ?= http://dev.digabi.fi/debian

ROOT_CA = ytl-root-ca.crt
LOCALCERTSDIR = /usr/local/share/ca-certificates
SOURCES_LIST = $(NAME).list
APT_KEY = $(NAME).asc

TRUSTED-LIST := $(patsubst active-keys/add-%,trusted.gpg/$(NAME)-archive-%.gpg,$(wildcard active-keys/add-*))
TMPRING := trusted.gpg/build-area

GPG_OPTIONS := --no-options --no-default-keyring --no-auto-check-trustdb --trustdb-name ./trustdb.gpg

build: init verify-indices keyrings/$(NAME)-archive-keyring.gpg keyrings/$(NAME)-archive-removed-keys.gpg verify-results $(TRUSTED-LIST)

init:
	mkdir -p keyrings

sign-keyring: keyrings/$(NAME)-archive-keyring.gpg
	gpg -a --detach-sign keyrings/$(NAME)-archive-keyring.gpg
	gpg -a --detach-sign keyrings/$(NAME)-archive-removed-keys.gpg

verify-indices: keyrings/team-members.gpg
	gpg ${GPG_OPTIONS} --keyring keyrings/team-members.gpg --verify active-keys/index.gpg active-keys/index
	gpg ${GPG_OPTIONS} --keyring keyrings/team-members.gpg --verify removed-keys/index.gpg removed-keys/index

verify-results: keyrings/team-members.gpg keyrings/$(NAME)-archive-keyring.gpg keyrings/$(NAME)-archive-removed-keys.gpg
	gpg ${GPG_OPTIONS} --keyring keyrings/team-members.gpg --verify keyrings/$(NAME)-archive-keyring.gpg.asc keyrings/$(NAME)-archive-keyring.gpg
	gpg ${GPG_OPTIONS} --keyring keyrings/team-members.gpg --verify keyrings/$(NAME)-archive-removed-keys.gpg.asc keyrings/$(NAME)-archive-removed-keys.gpg

keyrings/$(NAME)-archive-keyring.gpg: active-keys/index
	jetring-build -I $@ active-keys

keyrings/$(NAME)-archive-removed-keys.gpg: removed-keys/index
	jetring-build -I $@ removed-keys

keyrings/team-members.gpg: team-members/index
	jetring-build -I $@ team-members

$(TRUSTED-LIST) :: trusted.gpg/$(NAME)-archive-%.gpg: active-keys/add-% active-keys/index
	mkdir -p $(TMPRING) trusted.gpg
	grep -F $(shell basename $<) -- active-keys/index > $(TMPRING)/index
	cp $< $(TMPRING)
	jetring-build -I $@ $(TMPRING)
	rm -rf $(TMPRING)

clean:
	rm -f keyrings/$(NAME)-archive-keyring.gpg keyrings/$(NAME)-archive-keyring.gpg~ keyrings/$(NAME)-archive-keyring.gpg.lastchangeset
	rm -f keyrings/$(NAME)-archive-removed-keys.gpg keyrings/$(NAME)-archive-removed-keys.gpg~ keyrings/$(NAME)-archive-removed-keys.gpg.lastchangeset
	rm -f keyrings/team-members.gpg keyrings/team-members.gpg~ keyrings/team-members.gpg.lastchangeset
	rm -rf $(TMPRING) trusted.gpg trustdb.gpg
	rm -f keyrings/*.cache
	rm -f $(SOURCES_LIST) $(APT_KEY)

purge: clean
	rm -rf trusted.gpg

$(APT_KEY): keyrings/$(NAME)-archive-keyring.gpg
	gpg -a --keyring=keyrings/$(NAME)-archive-keyring.gpg --no-default-keyring --export >$(APT_KEY)

$(SOURCES_LIST):
	./tools/generate-sources-list.sh $(RELEASE) $(BASE_URL) >$(SOURCES_LIST)

install-repository.sh: build $(SOURCES_LIST)
	./tools/generate-install-repository.sh >install-repository.sh

sign-install-repository.sh: install-repository.sh
	sha256sum install-repository.sh >install-repository.sh.sha256
	gpg -a --detach-sign install-repository.sh.sha256

install: build $(SOURCES_LIST) install-repository.sh
	# digabi-archive-keyring
	install -d $(DESTDIR)/usr/share/keyrings/
	cp keyrings/$(NAME)-archive-keyring.gpg $(DESTDIR)/usr/share/keyrings/
	cp keyrings/$(NAME)-archive-removed-keys.gpg $(DESTDIR)/usr/share/keyrings/
	install -d $(DESTDIR)/etc/apt/trusted.gpg.d/
	cp $(shell find trusted.gpg/ -name '*.gpg' -type f) $(DESTDIR)/etc/apt/trusted.gpg.d/
	
	# digabi-repository
	install -D -m 0644 $(SOURCES_LIST) $(DESTDIR)/etc/apt/sources.list.d/$(SOURCES_LIST)
	
	# digabi-certificates
	install -D -m 0644 data/$(ROOT_CA) $(DESTDIR)/$(LOCALCERTSDIR)/$(ROOT_CA)
	
	# digabi-repository-server
	install -D -m 0644 conf/options $(DESTDIR)/etc/digabi-repository/options
	install -D -m 0644 conf/distributions $(DESTDIR)/etc/digabi-repository/distributions
	install -D -m 0644 conf/pulls $(DESTDIR)/etc/digabi-repository/pulls
	install -D -m 0644 conf/updates $(DESTDIR)/etc/digabi-repository/updates
	install -D -m 0644 other-keys/geogebra.asc $(DESTDIR)/etc/digabi-repository/trusted.gpg.d/geogebra.gpg
	install -d -m 0755 $(DESTDIR)/etc/digabi-repository/packages
	install -D -m 0644 conf/packages/* $(DESTDIR)/etc/digabi-repository/packages
	
	install -D -m 0755 tools/management.sh $(DESTDIR)/usr/bin/digabi-repository-management
	install -D -m 0755 tools/generate-sources-list.sh $(DESTDIR)/usr/lib/digabi-repository/digabi-sources-list
	install -d -m 0755 $(DESTDIR)/var/log/digabi-repository
	install -D -m 0644 digabi-repository-server.logrotate $(DESTDIR)/etc/logrotate.d/digabi-repository-server
	
	install -D -m 0644 install-repository.sh $(DESTDIR)/usr/share/digabi-repository/install-repository.sh
	install -D -m 0644 install-repository.sh.sha256 $(DESTDIR)/usr/share/digabi-repository/install-repository.sh.sha256
	install -D -m 0644 install-repository.sh.sha256.asc $(DESTDIR)/usr/share/digabi-repository/install-repository.sh.sha256.asc

initialize:
	@echo TODO

deb:
	dpkg-buildpackage -us -uc

.PHONY: verify-indices verify-results clean build install	
