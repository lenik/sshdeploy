PREFIX ?= /usr
DESTDIR ?=
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
BASHCOMPDIR = $(PREFIX)/share/bash-completion/completions

.PHONY: all install install-symlinks uninstall-symlinks clean

all:
	@echo "sshdeploy - nothing to build"

install: deployweb deployweb.1 deployweb.bash-completion runon runon.1 runon.bash-completion cdrun cdrun.1 cdrun.bash-completion push-to push-to.1 push-to.bash-completion
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(MANDIR)/man1
	install -d $(DESTDIR)$(BASHCOMPDIR)
	install -m 755 cdrun $(DESTDIR)$(BINDIR)/cdrun
	install -m 644 cdrun.1 $(DESTDIR)$(MANDIR)/man1/cdrun.1
	install -m 644 cdrun.bash-completion $(DESTDIR)$(BASHCOMPDIR)/cdrun
	install -m 755 deployweb $(DESTDIR)$(BINDIR)/deployweb
	install -m 644 deployweb.1 $(DESTDIR)$(MANDIR)/man1/deployweb.1
	install -m 644 deployweb.bash-completion $(DESTDIR)$(BASHCOMPDIR)/deployweb
	install -m 755 push-to $(DESTDIR)$(BINDIR)/push-to
	install -m 644 push-to.1 $(DESTDIR)$(MANDIR)/man1/push-to.1
	install -m 644 push-to.bash-completion $(DESTDIR)$(BASHCOMPDIR)/push-to
	install -m 755 runon $(DESTDIR)$(BINDIR)/runon
	install -m 644 runon.1 $(DESTDIR)$(MANDIR)/man1/runon.1
	install -m 644 runon.bash-completion $(DESTDIR)$(BASHCOMPDIR)/runon

install-symlinks:
	@sudo ln -vsnf $(shell pwd)/cdrun /usr/bin/cdrun
	@sudo ln -vsnf $(shell pwd)/cdrun.1 /usr/share/man/man1/cdrun.1
	@sudo ln -vsnf $(shell pwd)/cdrun.bash-completion /usr/share/bash-completion/completions/cdrun
	@sudo ln -vsnf $(shell pwd)/deployweb /usr/bin/deployweb
	@sudo ln -vsnf $(shell pwd)/deployweb.1 /usr/share/man/man1/deployweb.1
	@sudo ln -vsnf $(shell pwd)/deployweb.bash-completion /usr/share/bash-completion/completions/deployweb
	@sudo ln -vsnf $(shell pwd)/push-to /usr/bin/push-to
	@sudo ln -vsnf $(shell pwd)/push-to.1 /usr/share/man/man1/push-to.1
	@sudo ln -vsnf $(shell pwd)/push-to.bash-completion /usr/share/bash-completion/completions/push-to
	@sudo ln -vsnf $(shell pwd)/runon /usr/bin/runon
	@sudo ln -vsnf $(shell pwd)/runon.1 /usr/share/man/man1/runon.1
	@sudo ln -vsnf $(shell pwd)/runon.bash-completion /usr/share/bash-completion/completions/runon

uninstall-symlinks:
	@sudo rm -vf /usr/bin/cdrun
	@sudo rm -vf /usr/share/man/man1/cdrun.1
	@sudo rm -vf /usr/share/bash-completion/completions/cdrun
	@sudo rm -vf /usr/bin/deployweb
	@sudo rm -vf /usr/share/man/man1/deployweb.1
	@sudo rm -vf /usr/share/bash-completion/completions/deployweb
	@sudo rm -vf /usr/bin/push-to
	@sudo rm -vf /usr/share/man/man1/push-to.1
	@sudo rm -vf /usr/share/bash-completion/completions/push-to
	@sudo rm -vf /usr/bin/runon
	@sudo rm -vf /usr/share/man/man1/runon.1
	@sudo rm -vf /usr/share/bash-completion/completions/runon

clean:
	rm -f *.deb *.buildinfo *.changes
	rm -rf debian/deployweb debian/.debhelper

