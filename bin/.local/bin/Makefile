.DEFAULT_GOAL := help
.ONESHELL:

GIT_URL=https://api.github.com/repos
GNU_FTP=http://ftpmirror.gnu.org
RIT_URL=http://mirror.rit.edu/gnu

PROGS := \
	aspell autogen autoconf automake \
	bash binutils bison \
	cmake coreutils \
	findutils \
	gawk gcc gettext grep glib2 glibc guile gmp gzip \
	inetutils \
	libevent libiconv libtool libressl lua lua-format \
	m4 macports make mpc mpfr \
	ncurses node nvim \
	openjdk openssl openssh openssh-hpn \
	perl pkgconfig \
	readline ruby \
	sed stow sqlite3 svn \
	tar texinfo \
	wget \
	zsh

GO_PROGS := \
	shfmt terraform-docs

PY_PROGS := \
	black \
	isort \
	mdformat mdformat-gfm mdformat-toc mdformat-config mdformat-black \
	pynvim

aspell:      URL:=$(GIT_URL)/aspell/aspell-0.60.8.tar.gz
autoconf:    URL:=$(RIT_URL)/autoconf/autoconf-2.71.tar.gz
autogen:     URL:=$(RIT_URL)/autogen-5.18.7.tar.gz
automake:    URL:=$(RIT_URL)/automake/automake-1.16.4.tar.gz

bash:        URL:=$(RIT_URL)/bash/bash-5.1.8.tar.gz
binutils:    URL:=$(GNU_FTP)/binutils/binutils-2.37.tar.gz
bison:       URL:=$(GNU_FTP)/bison/bison-3.8.1.tar.gz

cmake:       URL:=$(GIT_URL)/Kitware/CMake/tarball
coreutils:   URL:=$(RIT_URL)/coreutils/coreutils-8.32.tar.gz
curl:        URL:=$(GIT_URL)/curl/curl/tarball

findutils:   URL:=$(RIT_URL)/findutils/findutils-4.6.0.tar.gz

gawk:        URL:=$(GNU_FTP)/gawk/gawk-5.1.0.tar.gz
gcc:         URL:=$(GNU_FTP)/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz
gettext:     URL:=$(RIT_URL)/gettext/gettext-0.21.tar.gz
glib2:       URL:=https://download.gnome.org/sources/glib/2.9/glib-2.9.0.tar.gz
glibc:       URL:=$(RIT_URL)/glibc/glibc-2.34.tar.gz
git:         URL:=$(GIT_URL)/git/git/tarball
gmp:         URL:=$(GNU_FTP)/gmp/gmp-6.2.1.tar.xz
grep:        URL:=$(GNU_FTP)/grep/grep-3.7.tar.gz
guile:       URL:=$(RIT_URL)/guile/guile-3.0.7.tar.gz
gzip:        URL:=$(GNU_FTP)/gzip/gzip-1.11.tar.gz

inetutils:   URL:=$(RIT_URL)/inetutils/inetutils-2.2.tar.gz

libevent:    URL:=$(GIT_URL)/libevent/libevent/tarball
libressl:    URL:=https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.3.4.tar.gz
libiconv:    URL:=$(GNU_FTP)/libiconv/libiconv-1.16.tar.gz
libtool:     URL:=$(RIT_URL)/libtool/libtool-2.4.6.tar.gz
lua:         URL:=$(GIT_URL)/lua/lua/tarball
lua-format:  URL:=$(GIT_URL)/Koihik/LuaFormatter/tarball

m4:          URL:=$(RIT_URL)/$(@)/m4-1.4.19.tar.gz
macports:    URL:=$(GIT_URL)/macports/macports-base/tarball
make:        URL:=$(RIT_URL)/$(@)/make-4.3.tar.gz
mpc:         URL:=$(RIT_URL)/$(@)/mpc-1.2.1.tar.gz
mpfr:        URL:=$(GNU_FTP)/$(@)/mpfr-4.1.0.tar.gz

ncurses:     URL:=$(RIT_URL)/ncurses/ncurses-6.2.tar.gz
ninja:       URL:=$(GIT_URL)/ninja-build/ninja/tarball
node:        URL:=https://nodejs.org/dist/v14.17.6/node-v14.17.6.tar.gz
nvim:	       URL:=https://api.github.com/repos/neovim/neovim/tarball

openjdk      URL:=$(GIT_URL)/openjdk/jdk/tarball
openssh-hpn: URL:=https://mirror.esc7.net/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz
openssh:     URL:=https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz
openssl:     URL:=https://www.openssl.org/source/openssl-3.0.0.tar.gz

perl:        URL:=https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
pkgconfig:   URL:=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
python:      URL:=$(GIT_URL)/python/cpython/tarball

readline:    URL:=$(RIT_URL)/readline/readline-8.1.tar.gz
ruby:        URL:=https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.2.tar.gz

sed:         URL:=$(RIT_URL)/sed/sed-4.8.tar.gz
shfmt:       URL:=mvdan.cc/sh/v3/cmd/shfmt@latest
sqlite3:     URL:=https://www.sqlite.org/snapshot/sqlite-snapshot-202109241957.tar.gz
stow:        URL:=$(GNU_FTP)/stow/stow-2.3.1.tar.gz
svn:         URL:=$(GIT_URL)/apache/subversion/tarball

tar:            URL:=$(RIT_URL)/tar/tar-1.34.tar.gz
terraform-docs: URL:=$(GIT_URL)/terraform-docs/terraform-docs/tarball
texinfo:        URL:=$(RIT_URL)/texinfo/texinfo-6.8.tar.gz
tmux:           URL:=$(GIT_URL)/tmux/tmux/tarball

wget:           URL:=$(RIT_URL)/wget/wget-1.21.2.tar.gz

zsh:            URL:=$(GIT_URL)/zsh-users/zsh/tarball

install : $(PROGS)
go-install : $(GO_PROGS)
py-install : $(PY_PROGS)

.PHONY: help # Generate list of targets
help:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null \
	| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
	| sort \
	| egrep -v -e '^[^[:alnum:]]' -e '^$@$$' \
	| column

$(PROGS):
	bash tarball-installer.sh $(@) $(URL) $(OPTS)

$(GO_PROGS):
	go install $(URL)

$(PY_PROGS):
	python3 -m pip install \
		--trusted-host pypi.org --trusted-host files.pythonhosted.org \
		$(@)
