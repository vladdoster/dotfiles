# syntax=docker/dockerfile-upstream:master-labs
# ARCH
#
ARG ARCH=amd64
ARG TARGETPLATFORM
FROM ${ARCH}/debian:stable-slim
# FROM --platform=$BUILDPLATFORM debian:stable-slim AS build
# ARG TARGETPLATFORM
# ARG BUILDPLATFORM
# ARG ARCH=amd64
# ARG TARGETPLATFORM
# FROM ${ARCH}/ubuntu:latest

ARG USER

ENV DEBIAN_FRONTEND noninteractive
ENV USER ${USER:-"docker"}
ENV HOME "/home/${USER}"
ENV BREW_PREFIX "/home/$USER/.linuxbrew"

RUN <<INSTALL-DEPS bash
  apt-get update
  apt-get -y install --no-install-recommends \
    ca-certificates curl cmake \
    file figlet \
    g++ gcc git \
    less libz-dev locales \
    make \
    stow sudo subversion \
    tar tzdata tree \
    unzip \
    vim \
    wget \
    xz-utils \
    zsh
INSTALL-DEPS

RUN <<CREATE-USER bash
  useradd \
    --create-home \
    --gid root --groups sudo \
    --home-dir ${HOME} \
    --shell "$(which zsh)" \
    --uid 1001 \
    ${USER}
  passwd --delete ${USER}
CREATE-USER

ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/homebrew-core.git#master $BREW_PREFIX/Homebrew/Library/Taps/homebrew/homebrew-core
ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/brew.git#master $BREW_PREFIX/Homebrew

ADD --keep-git-dir=true https://github.com/vladdoster/dotfiles.git#master $HOME/dotfiles
ADD --keep-git-dir=true https://github.com/zdharma-continuum/zinit.git#main $HOME/.local/share/zinit/zinit.git

RUN <<INSTALL-HOMEBREW bash
  # ln -s ${BREW_PREFIX}/Homebrew/bin/brew ${BREW_PREFIX}/bin
  chown -R ${USER} ${HOME}
INSTALL-HOMEBREW


RUN <<DOTFILES bash
  make --directory "${HOME}/dotfiles" dotfiles
  figlet "user: ${USER}"
  chown -R "${USER}" "${HOME}"
DOTFILES

USER ${USER}
WORKDIR ${HOME}
ENTRYPOINT ["zsh"]
CMD ["-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
