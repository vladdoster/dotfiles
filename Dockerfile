# syntax=docker/dockerfile:1

ARG UBUNTU_VERSION=26.04

FROM ubuntu:${UBUNTU_VERSION} AS base

# Keep downloaded packages so the apt cache mounts below can reuse them.
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' >/etc/apt/apt.conf.d/keep-cache

FROM base AS nvim-build

ARG NVIM_VERSION=v0.12.6

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update --quiet=2 \
 && DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends --quiet=2 \
  build-essential ca-certificates cmake curl gettext git ninja-build unzip

RUN git clone --quiet --depth=1 --branch=${NVIM_VERSION} https://github.com/neovim/neovim /neovim \
 && make --directory=/neovim --jobs="$(nproc)" --silent CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/nvim install

FROM base AS runtime

LABEL org.opencontainers.image.title="dotfiles"
LABEL org.opencontainers.image.source="https://github.com/vladdoster/dotfiles"
LABEL org.opencontainers.image.url="http://dotfiles.vdoster.com/"
LABEL org.opencontainers.image.description="Containerized dotfiles environment"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"

ARG USER
ARG USER_ID=1001

ENV USER=${USER:-dotfiles}
ENV HOME=/home/${USER}

ENV CLICOLOR=1
ENV TERM=xterm-256color

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update --quiet=2 \
 && DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends --quiet=2 \
  acl apt-utils autoconf automake \
  bsdmainutils bsdutils build-essential bzip2 \
  ca-certificates cmake cpanminus curl \
  debianutils dialog \
  eza \
  figlet file fzf \
  g++ gawk gcc gettext git git-delta gnupg golang gosu \
  iproute2 \
  jq \
  less libevent-dev libreadline-dev libtool libtool-bin libz-dev locales lua5.4 luajit luarocks \
  make man-db meson \
  ncurses-base ncurses-bin ncurses-dev ncurses-term netbase npm \
  patch pkg-config python3 python3-dev python3-pip python3-setuptools perl \
  readline-common ripgrep ruby ruby-dev \
  stow subversion sudo software-properties-common \
  tar texinfo tree tzdata \
  unzip util-linux-locales uuid-runtime \
  wget \
  xz-utils \
  zsh

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Passwordless sudo lets the interactive shell install packages.
RUN groupadd --gid ${USER_ID} ${USER} \
 && useradd \
  --create-home \
  --gid ${USER_ID} --groups sudo \
  --home-dir ${HOME} \
  --shell "$(which zsh)" \
  --uid ${USER_ID} \
  ${USER} \
 && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers \
 && passwd --delete ${USER} \
 && chown --recursive ${USER} ${HOME}

USER ${USER}
WORKDIR ${HOME}

COPY --link --from=nvim-build --chown=${USER_ID}:${USER_ID} /opt/nvim/ ${HOME}/.local/
COPY --link --chown=${USER_ID}:${USER_ID} . ${HOME}/.config/dotfiles/

RUN zsh --interactive --login -c 'make --directory=.config/dotfiles --jobs=1 install neovim'
 # && zsh --interactive --login -c -- '@zinit-scheduler burst'

CMD ["zsh","--login"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
