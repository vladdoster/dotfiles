FILES := stow binutils tmux libevent automake coreutils make

automake: URL:=http://mirror.rit.edu/gnu/automake/automake-1.16.4.tar.gz
binutils: URL:=https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz
coreutils: URL:=http://mirror.rit.edu/gnu/coreutils/coreutils-8.32.tar.gz
libevent: URL:=https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
make: URL:=http://mirror.rit.edu/gnu/make/make-4.3.tar.gz
stow: URL:=https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz
tmux: URL:=https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz

main : $(FILES)
	echo "--- Installing "

$(FILES):
	./install-tarball.sh $(URL)

# .PHONY: new-installer
# new-installer:
# 	echo $(CURDIR)
# 	cp $(CURDIR)/TEMPLATE $(CURDIR)/$(NEW).sh
