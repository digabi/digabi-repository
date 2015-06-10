all:

install:
	install -D -m 0644 data/repository/digabi.list $(DESTDIR)/etc/apt/sources.list.d/digabi.list
	install -D -m 0644 data/repository/digabi.gpg $(DESTDIR)/etc/apt/trusted.gpg.d/digabi.gpg

deb:
	debuild-pbuilder -us -uc
