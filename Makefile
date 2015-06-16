NAME = digabi
KEYID ?= 0x9D3D06EE

RELEASE ?= stable
BASE_URL ?= http://dev.digabi.fi/debian

SOURCES_LIST = $(NAME).list
APT_KEY = $(NAME).gpg
APT_KEY_ASCII = $(NAME).asc

ROOT_CA = ytl-root-ca.crt
LOCALCERTSDIR = /usr/local/share/ca-certificates

all:

clean:
	rm -f $(APT_KEY) $(APT_KEY_ASCII) $(SOURCES_LIST)

$(SOURCES_LIST):
	./tools/generate-sources-list.sh $(RELEASE) $(BASE_URL) >$(SOURCES_LIST)

$(APT_KEY):
	gpg --keyring data/gpg/pubring.gpg --no-default-keyring --export $(KEYID) 2>/dev/null >$(APT_KEY)
	gpg -a --keyring data/gpg/pubring.gpg --no-default-keyring --export $(KEYID) 2>/dev/null >$(APT_KEY_ASCII)

$(APT_KEY_ASCII): $(APT_KEY)

install: $(SOURCES_LIST) $(APT_KEY)
	install -D -m 0644 $(SOURCES_LIST) $(DESTDIR)/etc/apt/sources.list.d/$(SOURCES_LIST)
	install -D -m 0644 $(APT_KEY) $(DESTDIR)/etc/apt/trusted.gpg.d/$(APT_KEY)
	install -D -m 0644 data/$(ROOT_CA) $(DESTDIR)/$(LOCALCERTSDIR)/$(ROOT_CA)

setup-server: $(SOURCES_LIST) $(APT_KEY) $(APT_KEY_ASCII)
	

deb:
	dpkg-buildpackage -us -uc -I
