NAME = digabi
SIGNING_KEY_ID ?= 0x9D3D06EE
RELEASE ?= stable
BASE_URL ?= http://dev.digabi.fi/debian

# APT configuration
SOURCES_LIST = $(NAME).list
APT_KEY = $(NAME).gpg
APT_KEY_ASCII = $(NAME).asc

# GPG Configuration
GPG_BIN = /usr/bin/gpg
GNUPGHOME ?= data/gpg
GPG_FLAGS = --homedir=$(GNUPGHOME)
GPG = $(GPG_BIN) $(GPG_FLAGS)

ARCHIVE_KEYRING = $(NAME)-archive-keyring
ARCHIVE_KEYRING_FILENAME = $(ARCHIVE_KEYRING).gpg

# CA configuration
ROOT_CA = ytl-root-ca.crt
LOCALCERTSDIR = /usr/local/share/ca-certificates

all:

clean:
	rm -f $(APT_KEY) $(APT_KEY_ASCII) $(SOURCES_LIST)

$(SOURCES_LIST):
	./tools/generate-sources-list.sh $(RELEASE) $(BASE_URL) >$(SOURCES_LIST)

$(APT_KEY):
	$(GPG) --export $(SIGNING_KEY_ID) 2>/dev/null >$(APT_KEY)

$(APT_KEY_ASCII):
	$(GPG) -a --export $(SIGNING_KEY_ID) 2>/dev/null >$(APT_KEY_ASCII)

install: $(SOURCES_LIST) $(APT_KEY)
	install -D -m 0644 $(SOURCES_LIST) $(DESTDIR)/etc/apt/sources.list.d/$(SOURCES_LIST)
	install -D -m 0644 $(APT_KEY) $(DESTDIR)/etc/apt/trusted.gpg.d/$(APT_KEY)
	install -D -m 0644 data/$(ROOT_CA) $(DESTDIR)/$(LOCALCERTSDIR)/$(ROOT_CA)

setup-server: $(SOURCES_LIST) $(APT_KEY) $(APT_KEY_ASCII)
	

deb:
	dpkg-buildpackage -us -uc -I
