# syntax=docker/dockerfile:1
ARG ARCH=amd64
FROM ${ARCH}/ubuntu:latest

ARG USER

ENV BREW_PREFIX /home/linuxbrew/.linuxbrew
ENV DEBIAN_FRONTEND noninteractive
ENV USER_NAME ${USER:-"docker"}
ENV USER_HOME "/home/${USER_NAME}"

RUN <<SET-LOCALE bash
  apt-get update
  apt-get install -y locales
  rm -rf /var/lib/apt/lists/*
  localedef \
    -i en_US \
    -c \
    -f UTF-8 \
    -A /usr/share/locale/locale.alias \
    en_US.UTF-8
SET-LOCALE

ENV LANG en_US.utf8

RUN <<INSTALL-DEPS bash
  apt-get update
  apt-get -y install --no-install-recommends \
    ca-certificates curl cmake \
    file \
    g++ gcc git \
    less libz-dev locales \
    make \
    stow subversion sudo \
    tar tzdata tree \
    unzip \
    vim \
    xz-utils \
    zsh
INSTALL-DEPS

RUN <<CREATE-USER bash
  useradd \
    --create-home \
    --gid root --groups sudo \
    --home-dir ${USER_HOME} \
    --shell "$(which zsh)" \
    --uid 1001 \
    ${USER_NAME}
  passwd --delete ${USER_NAME}
  chown -R ${USER_NAME} ${USER_HOME}
CREATE-USER
  # mkdir -p -- $USER_HOME/.config

RUN <<INSTALL-HOMEBREW bash
  rm -rf ${BREW_PREFIX}
  mkdir -p ${BREW_PREFIX}
  chown -R ${USER_NAME} ${BREW_PREFIX}
  git clone --depth 1 https://github.com/Homebrew/brew ${BREW_PREFIX}/Homebrew
  mkdir -p ${BREW_PREFIX}/Homebrew/Library/Taps/homebrew
  git clone --depth 1 https://github.com/Homebrew/homebrew-core ${BREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-core
  mkdir ${BREW_PREFIX}/bin
  ln -s ${BREW_PREFIX}/Homebrew/bin/brew ${BREW_PREFIX}/bin
  chown -R ${USER_NAME} ${BREW_PREFIX}
INSTALL-HOMEBREW

USER ${USER_NAME}
WORKDIR "${USER_HOME}/.config"

RUN <<DOTFILES bash
  git clone https://github.com/vladdoster/dotfiles
  make --directory "$(pwd)/dotfiles" dotfiles neovim
DOTFILES

WORKDIR ${USER_HOME}

ENTRYPOINT ["zsh"]
CMD ["-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
