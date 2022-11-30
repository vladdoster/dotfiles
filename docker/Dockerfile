# syntax=docker/dockerfile-upstream:master-labs

ARG TARGETPLATFORM=amd64
FROM ubuntu:20.04

ARG USER

ENV DEBIAN_FRONTEND noninteractive
ENV USER ${USER:-"dotfiles"}
ENV HOME "/home/${USER}"
ENV BREW_PREFIX "/home/${USER}/.linuxbrew"

RUN apt-get update \
 && apt-get --yes --fix-missing install --no-install-recommends \
    apt-utils autoconf automake \
    build-essential bsdmainutils bsdutils \
    ca-certificates curl cmake \
    debianutils \
    file figlet \
    g++ gcc git \
    less libz-dev locales libevent-dev \
    make \
    ncurses-base ncurses-bin ncurses-dev \
    pkg-config python3-pip python3.8 python3.8-dev \
    stow sudo subversion \
    tar tzdata tree \
    unzip util-linux-locales \
    vim \
    wget \
    xz-utils \
    zsh

RUN useradd \
   --create-home \
   --gid root --groups sudo \
   --home-dir ${HOME} \
   --shell "$(which zsh)" \
   --uid 1001 \
   ${USER} \
 && passwd --delete ${USER}

# ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/homebrew-core.git#master $BREW_PREFIX/Homebrew/Library/Taps/homebrew/homebrew-core
# ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/brew.git#master $BREW_PREFIX/Homebrew

# ADD --keep-git-dir=true https://github.com/vladdoster/dotfiles.git#master $HOME/dotfiles
# ADD --keep-git-dir=true https://github.com/zdharma-continuum/zinit.git#main $HOME/.local/share/zinit/zinit.git

# RUN <<INSTALL-HOMEBREW bash
#   # ln -s ${BREW_PREFIX}/Homebrew/bin/brew ${BREW_PREFIX}/bin
#   chown -R ${USER} ${HOME}
# INSTALL-HOMEBREW

# COPY . ${HOME}/.config/dotfiles

# RUN <<DOTFILES bash
#   make --directory "${HOME}/dotfiles" dotfiles
# DOTFILES


RUN mkdir --parents ${HOME}/.config \
 && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
 && make --directory ${HOME}/.config/dotfiles make install \
 && chown --recursive "${USER}" "${HOME}" \
 && figlet "user: ${USER}"

USER ${USER}
WORKDIR ${HOME}
ENTRYPOINT ["zsh"]
CMD ["-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
