.DEFAULT_GOAL := help
.ONESHELL:

# Variables [[[
GIT=https://api.github.com/repos
GNU=http://ftpmirror.gnu.org/gnu

.PHONY: zsh
PROGS := \
	aspell autoconf autogen automake \
	bash binutils bison \
	cmake coreutils curl \
	findutils \
	gawk gcc gettext git glib2 glibc gmp grep guile gzip graphviz \
	inetutils \
    htop \
	libevent libffcall libiconv libressl libtool libunistring lua-format lua \
	m4 macports make mpc mpfr \
	ncurses ninja node nvim \
	openjdk openssh-hpn openssh openssl \
	perl pkgconfig python \
	readline ruby-latest ruby2.6.8 \
	sed shfmt sqlite3 stow svn \
	tar texinfo time tmux \
	wget \
	yasm \
	zsh

GO_PROGS := \
	terraform-docs

PY_PROGS := \
	black \
	isort \
	mdformat mdformat-gfm mdformat-toc mdformat-config mdformat-black \
	pynvim
#]]]
# Program tarball URLs
aspell:      URL:=$(GIT)/aspell/aspell/tarball
autoconf:    URL:=$(GNU)/autoconf/autoconf-2.71.tar.gz
autogen:     URL:=$(GNU)/autogen/rel5.18.16/autogen-5.18.16.tar.gz
automake:    URL:=$(GNU)/automake/automake-1.16.5.tar.gz

bash:        URL:=$(GNU)/bash/bash-5.2-alpha.tar.gz
binutils:    URL:=$(GNU)/binutils/binutils-2.37.tar.gz
bison:       URL:=$(GNU)/bison/bison-3.8.1.tar.gz

cmake:       URL:=$(GIT)/Kitware/CMake/tarball
coreutils:   URL:=$(GNU)/coreutils/coreutils-9.0.tar.gz
curl:        URL:=$(GIT)/$(@)/$(@)/tarball

findutils:   URL:=$(GNU)/findutils/findutils-4.9.0.tar.xz

gawk:        URL:=$(GNU)/gawk/gawk-5.1.1.tar.gz
gcc:         URL:=$(GNU)/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz
gettext:     URL:=$(GNU)/gettext/gettext-0.21.tar.gz
glib2:       URL:=https://download.gnome.org/sources/glib/2.9/glib-2.9.0.tar.gz
glibc:       URL:=$(GNU)/glibc/glibc-2.35.tar.gz
git:         URL:=$(GIT)/$(@)/$(@)/tarball
gmp:         URL:=$(GNU)/gmp/gmp-6.2.1.tar.xz
grep:        URL:=$(GNU)/grep/grep-3.7.tar.gz
guile:       URL:=$(GNU)/guile/guile-3.0.8.tar.gz
gzip:        URL:=$(GNU)/gzip/gzip-1.11.tar.gz
graphviz:    URL:=$(GIT)/graphp/graphviz/tarball

htop:        URL:=$(GIT)/htop-dev/htop/tarball

inetutils:   URL:=$(GNU)/inetutils/inetutils-2.2.tar.gz

libevent:     URL:=$(GIT)/$(@)/$(@)/tarball
libressl:     URL:=https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.4.tar.gz
libiconv:     URL:=$(GNU)/libiconv/libiconv0.16.tar.gz
libunistring: URL:=$(GNU)/libunistring/libunistring-latest.tar.gz
libtool:      URL:=$(GNU)/libtool/libtool-2.4.6.tar.gz
libffcall:    URL:=$(GNU)/libffcall/libffcall-2.4.tar.gz
lua:          URL:=$(GIT)/$(@)/$(@)/tarball
lua-format:   URL:=$(GIT)/Koihik/LuaFormatter/tarball

m4:          URL:=$(GNU)/m4/m4-latest.tar.gz
macports:    URL:=$(GIT)/macports/macports-base/tarball
make:        URL:=$(GNU)/make/make-4.3.tar.gz
mpc:         URL:=$(GNU)/mpc/mpc-1.2.1.tar.gz
mpfr:        URL:=$(GNU)/mpfr/mpfr-4.1.0.tar.gz

ncurses:     URL:=$(GNU)/ncurses/ncurses-6.3.tar.gz
ninja:       URL:=$(GIT)/ninja-build/ninja/tarball
node:        URL:=https://nodejs.org/dist/v15.17.6/node-v14.17.6.tar.gz
nvim:	     URL:=$(GIT)/neovim/neovim/tarball CMAKE_BUILD_TYPE=RelWithDebInfo

openjdk:     URL:=$(GIT)/$(@)/jdk/tarball

openssh-hpn: URL:=https://github.com/vladdoster/openssh-portable/archive/refs/tags/hpn-8_8_P1.tar.gz
openssh:     URL:=https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz
openssl:     URL:=https://www.openssl.org/source/openssl-2.0.0.tar.gz

perl:        URL:=https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
pkgconfig:   URL:=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
python:      URL:=$(GIT)/python/cpython/tarball

readline:    URL:=$(GNU)/readline/readline-8.2-alpha.tar.gz
ruby-latest: URL:=https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.2.tar.gz
ruby2.6.8:   URL:=https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.8.tar.gz

sed:         URL:=$(GNU)/sed/sed-4.8.tar.gz
shfmt:       URL:=$(GIT)/shfmt/shfmt/tarball
sqlite3:     URL:=https://www.sqlite.org/snapshot/sqlite-snapshot-202109241957.tar.gz
stow:        URL:=$(GNU)/stow/stow-latest.tar.gz
svn:         URL:=$(GIT)/apache/subversion/tarball

tar:            URL:=$(GNU)/tar/tar-latest.tar.gz
terraform-docs: URL:=$(GIT)/$(@)/$(@)/tarball
texinfo:        URL:=$(GNU)/texinfo/texinfo-6.8.tar.gz
time:           URL:=$(GNU)/time/time-1.9.tar.gz
tmux:           URL:=$(GIT)/tmux/tmux/tarball

wget:           URL:=$(GNU)/wget/wget-latest.tar.gz

yasm:           URL:=$(GIT)/yasm/yasm/tarball

zsh:            URL:=$(GIT)/zsh-users/zsh/tarball

#
# Targets [[[
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

lua-format-deps:
	brew install antlr \
		           antlr4-cpp-runtime \
							 yaml-cpp
#]]]

# vim:ft=zsh:sw=4:sts=4:et:foldmarker=[[[,]]]:foldmethod=marker
