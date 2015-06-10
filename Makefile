SOURCES_LIST = digabi.list
APT_KEY = digabi.gpg
KEYID ?= 0x9D3D06EE

all:

clean:
	rm -f $(APT_KEY) $(SOURCES_LIST)

$(SOURCES_LIST):
	cp data/repository/digabi.list $(SOURCES_LIST)

$(APT_KEY):
	gpg --keyring data/gpg/pubring.gpg --no-default-keyring --export $(KEYID) >$(APT_KEY)

install: $(SOURCES_LIST) $(APT_KEY)
	install -D -m 0644 $(SOURCES_LIST) $(DESTDIR)/etc/apt/sources.list.d/$(SOURCES_LIST)
	install -D -m 0644 $(APT_KEY) $(DESTDIR)/etc/apt/trusted.gpg.d/$(APT_KEY)

deb:
	debuild-pbuilder -us -uc -I
