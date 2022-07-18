
ZSH := $(shell command -v zsh 2> /dev/null)
.DEFAULT_SHELL := $(ZSH)
.ONESHELL:

.DEFAULT_GOAL := help

zwc:
	$(or $(ZSH),:) -fc 'for f in *.zsh; do zcompile -R -- $$f.zwc $$f || exit; done'

GIT=https://api.github.com/repos
GNU=http://ftpmirror.gnu.org/gnu

PROGS := \
	aspell autoconf autoconf-2.69 autogen automake \
	ballandpaddle bash binutils bison \
	cmake curl \
	gawk gcc gettext git glib2 glibc gmp graphviz grep guile gzip \
	htop \
	libevent libffcall libiconv libressl libtool libunistring lua lua-format \
	m4 macports make mpc mpfr \
	ncurses ninja node nvim \
	openjdk openssh openssh-hpn openssl \
	perl pkgconfig python \
	readline ruby-latest ruby2.6.8 \
	sed shfmt shtool sqlite3 stow svn \
	tar texinfo time tmux \
	wget \
	yasm \
	zlib zsh

PY_PROGS := \
	black \
	isort \
	mdformat mdformat-black mdformat-config mdformat-gfm mdformat-toc mdformat-web \
	pynvim

# Program tarball URLs
aspell:          URL:=$(GNU)/aspell
autoconf-2.69:   URL:=$(GNU)/autoconf/autoconf-2.69.tar.gz
autoconf: URL:=$(GNU)/autoconf
autogen:         URL:=$(GNU)/autogen/rel5.18.16
automake:        URL:=$(GNU)/automake

ballandpaddle: URL:=$(GNU)/ballandpaddle
bash:      URL:=$(GNU)/bash
binutils:  URL:=$(GNU)/binutils
bison:     URL:=$(GNU)/bison

cmake:     URL:=$(GIT)/Kitware/CMake/tarball
coreutils: URL:=$(GNU)/coreutils
curl:      URL:=$(GIT)/curl/curl

findutils: URL:=$(GNU)/findutils

gawk:      URL:=$(GNU)/gawk
gcc:       URL:=$(GNU)/gcc
gettext:   URL:=$(GNU)/gettext
glib2:     URL:=https://download.gnome.org/sources/glib/2.9/glib-2.9.0.tar.gz
glibc:     URL:=$(GNU)/glibc
git:       URL:=$(GIT)/git/git
gmp:       URL:=$(GNU)/gmp
grep:      URL:=$(GNU)/grep --enable-perl-regexp
guile:     URL:=$(GNU)/guile
gzip:      URL:=$(GNU)/gzip
graphviz:  URL:=$(GIT)/graphp/graphviz

htop:      URL:=$(GIT)/htop-dev/htop

inetutils: URL:=$(GNU)/inetutils

libevent:     URL:=$(GIT)/libevent/libevent
libressl:     URL:=https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.4.tar.gz
libiconv:     URL:=$(GNU)/libiconv
libunistring: URL:=$(GNU)/libunistring
libtool:      URL:=$(GNU)/libtool
libffcall:    URL:=$(GNU)/libffcall
lua:          URL:=$(GIT)/lua/lua
lua-format:   URL:=$(GIT)/Koihik/LuaFormatter

m4:       URL:=$(GNU)/m4
macports: URL:=$(GIT)/macports/macports-base
make:     URL:=$(GNU)/make
mpc:      URL:=$(GNU)/mpc
mpfr:     URL:=$(GNU)/mpfr

ncurses:  URL:=$(GNU)/ncurses
ninja:    URL:=$(GIT)/ninja-build/ninja
node:     URL:=https://nodejs.org/dist/v15.17.6/node-v14.17.6.tar.gz
nvim: URL:=$(GIT)/neovim/neovim

openjdk:     URL:=$(GIT)/openjdk/jdk
openssh-hpn: URL:=https://github.com/vladdoster/openssh-portable/archive/refs/tags/hpn-8_8_P1.tar.gz
openssh:     URL:=https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz
openssl:     URL:=https://www.openssl.org/source/openssl-2.0.0.tar.gz

perl:        URL:=https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz
pkgconfig:   URL:=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
python:      URL:=$(GIT)/python/cpython

readline:    URL:=$(GNU)/readline
ruby/latest: URL:=https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.2.tar.gz
ruby/2.6.8:  URL:=https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.8.tar.gz

sed:     URL:=$(GNU)/sed
shfmt:   URL:=$(GIT)/shfmt/shfmt
sqlite3: URL:=$(GIT)/sqlite/sqlite
stow:    URL:=$(GNU)/stow
svn:     URL:=$(GIT)/apache/subversion
shtool:  URL:=$(GNU)/shtool

tar:     URL:=$(GNU)/tar
tf-docs: URL:=$(GIT)/terraform-docs/terraform-docs
texinfo: URL:=$(GNU)/texinfo
time:    URL:=$(GNU)/time
tmux:    URL:=$(GIT)/tmux/tmux --disable-utf8proc

wget: URL:=$(GNU)/wget
yasm: URL:=$(GIT)/yasm/yasm
zlib: URL:=$(GIT)/madler/zlib

.PHONY: zsh
zsh:  URL:=$(GIT)/zsh-users/zsh

install : $(PROGS)
go-install : $(GO_PROGS)
py-install : $(PY_PROGS)

$(PROGS):
	url:=$(eval$(if $(filter-out "gnu", $(processed_input)), $(GNU)/$(@)/$(shell curl $(GNU)/$(@)/ | grep -oE "$(@)-([0-9\-]+\.){0,3}(\*|[0-9\.]+)\.tar\.gz" | sort -V -t. -r -k1,1 -k2,2 -k3,3 | head -1), $(URL)/tarball))
	$(ZSH) $${PWD}/installer $(@) $(url)

$(PY_PROGS):
	python3 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org $(@)
