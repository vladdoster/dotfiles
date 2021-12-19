FROM alpine:edge
RUN \
	echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk upgrade --no-cache && \
	apk add --no-cache \
		# System \
		ca-certificates \
		man-pages \
		sudo sudo-doc \
		openssh openssh-doc \
		zsh zsh-doc \
		# Tools \
		bat \
		binwalk \
		cloc cloc-doc \
		curl curl-doc \
		exa \
		gdb gdb-doc \
		graphviz graphviz-doc \
		imagemagick imagemagick-doc \
		jq jq-doc \
		mysql-client \
		nmap nmap-doc \
		p7zip p7zip-doc \
		percona-toolkit percona-toolkit-doc \
		postgresql \
		python2 python3 \
		ripgrep \
		rsync \
		skim skim-doc skim-zsh-completion \
		skopeo \
		speedtest-cli \
		sqlite sqlite-doc \
		sshuttle \
		terraform \
		tmux tmux-doc \
		upx upx-doc \
		xz xz-doc \
		youtube-dl youtube-dl-doc youtube-dl-zsh-completion \
		zstd zstd-doc \
		# Version Control \
		git git-doc \
		hub hub-doc \
		mercurial mercurial-doc \
		# Editors \
		neovim neovim-doc neovim-lang \
    shadow

RUN \
    apk add sudo && \
    NEWUSER='vlad' && \
    echo "${NEWUSER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser -D -G wheel --shell="$(which zsh)" --system "$NEWUSER" && \
    echo "$NEWUSER ALL=(ALL) ALL" > /etc/sudoers.d/${NEWUSER} && chmod 0440 /etc/sudoers.d/${NEWUSER}

USER vlad

RUN \
	git config --global url."https://github.com/".insteadOf git@github.com: && \
	git config --global url."https://".insteadOf git:// && \
	git clone "git@github.com:vladdoster/dotfiles.git" "$HOME/.config/dotfiles"

ENTRYPOINT ["zsh"]

