.PHONY: new-installer
new-installer:
	echo $(CURDIR)
	cp $(CURDIR)/TEMPLATE $(CURDIR)/$(NEW).sh

.PHONY: install-tarball
install-tarball:
	./install-tarball.sh "$(@)"

binutils:
	$(install-tarball) "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz"
