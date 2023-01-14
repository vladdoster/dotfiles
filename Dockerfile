# syntax=docker/dockerfile:1

FROM ubuntu:latest

LABEL org.label-schema.name="vladdoster/dotfiles"
LABEL org.opencontainers.image.title="dotfiles"
LABEL org.opencontainers.image.source="http://dotfiles.vdoster.com/"
LABEL org.opencontainers.image.description="Containerized dotfiles environment"

ARG USER

ENV USER ${USER:-dotfiles}
ENV HOME /home/${USER}

ENV CLICOLOR 1
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends \
  acl apt-utils autoconf automake \
  bsdmainutils bsdutils build-essential bzip2 \
  ca-certificates cmake cpanminus curl \
  debianutils default-jre delta dialog \
  exa \
  figlet file fzf \
  g++ gawk gcc gettext git gnupg golang gosu \
  iproute2 \
  jq \
  less libevent-dev libreadline-dev libtool libtool-bin libz-dev locales lua5.4 luajit luarocks \
  make man-db meson \
  ncurses-base ncurses-bin ncurses-dev ncurses-term netbase npm \
  patch pkg-config python3 python3-dev python3-pip python3-setuptools python3-bdist-nsi perl \
  readline-common ripgrep ruby ruby-dev \
  stow subversion sudo software-properties-common \
  tar texinfo texlive tree tzdata \
  unzip util-linux-locales uuid-runtime \
  wget \
  xz-utils \
  zsh

RUN add-apt-repository ppa:neovim-ppa/unstable \
 && apt update \
 && apt-get install --assume-yes neovim

# configure locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN useradd \
  --create-home \
  --gid root --groups sudo \
  --home-dir ${HOME} \
  --shell "$(which zsh)" \
  --uid 1001 \
  ${USER} \
 && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers \
 && passwd --delete ${USER} \
 && chown --recursive ${USER} ${HOME}

USER ${USER}
WORKDIR ${HOME}

RUN mkdir --parents code .config/dotfiles
COPY --chown=${USER}:1001 . ${HOME}/.config/dotfiles/
RUN make --directory=.config/dotfiles --jobs=1 install neovim \
 && sudo --user=${USER} --login zsh --interactive --login -c -- '@zinit-scheduler burst'

 # && git clone https://github.com/vladdoster/dotfiles .config/dotfiles \
CMD ["zsh", "--login"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
