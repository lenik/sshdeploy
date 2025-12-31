PREFIX ?= /usr/local
DESTDIR ?=
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
BASHCOMPDIR = $(PREFIX)/share/bash-completion/completions

.PHONY: all install install-symlinks clean

all:
	@echo "deployweb - nothing to build"

install: deployweb deployweb.1 deployweb.bash-completion
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(MANDIR)/man1
	install -d $(DESTDIR)$(BASHCOMPDIR)
	install -m 755 deployweb $(DESTDIR)$(BINDIR)/deployweb
	install -m 644 deployweb.1 $(DESTDIR)$(MANDIR)/man1/deployweb.1
	install -m 644 deployweb.bash-completion $(DESTDIR)$(BASHCOMPDIR)/deployweb

install-symlinks:
	@if [ -z "$(DESTDIR)" ]; then \
		sudo ln -sf $(shell pwd)/deployweb /usr/bin/deployweb; \
		sudo ln -sf $(shell pwd)/deployweb.1 /usr/share/man/man1/deployweb.1; \
		sudo ln -sf $(shell pwd)/deployweb.bash-completion /usr/share/bash-completion/completions/deployweb; \
		echo "Symlinks installed in /usr"; \
	else \
		echo "DESTDIR is set, skipping install-symlinks (use install instead)"; \
	fi

clean:
	rm -f *.deb *.buildinfo *.changes
	rm -rf debian/deployweb debian/.debhelper

