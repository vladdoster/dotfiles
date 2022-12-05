# syntax=docker/dockerfile-upstream:master-labs

ARG TARGETPLATFORM=amd64
FROM --platform=${TARGETPLATFORM} ubuntu:rolling

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="vladdoster/dotfiles"
LABEL org.label-schema.description="Containerized dotfiles environment"
LABEL org.label-schema.url="http://dotfiles.vdoster.com/"
LABEL org.label-schema.vcs-url="https://github.com/vladdoster/dotfiles"
LABEL org.label-schema.docker.cmd="docker run --interactive --mount source=dotfiles-volume,destination=/home/ --tty vladdoster/dotfiles"

ARG USER

ENV USER ${USER:-dotfiles}
ENV HOME /home/${USER}

ENV CLICOLOR 1
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update \
 && apt-get --yes install --no-install-recommends \
  apt-utils autoconf automake \
  bsdmainutils bsdutils build-essential \
  ca-certificates cmake curl \
  debianutils \
  figlet file \
  g++ gcc git golang \
  less libevent-dev libtree-sitter-dev libz-dev locales lua5.1 luarocks \
  make man-db \
  ncurses-base ncurses-bin ncurses-dev ncurses-term \
  pkg-config python3-pip python3 python3-dev \
  stow subversion sudo \
  tar tree tzdata \
  unzip util-linux-locales \
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
 && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers \
 && passwd --delete ${USER}

USER ${USER}
WORKDIR ${HOME}

RUN mkdir --parents ${HOME}/.config \
 && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
 && make --directory=${HOME}/.config/dotfiles make install neovim py-update \
 && chown --recursive ${USER} ${HOME} \
 && sudo --user=${USER} --login zsh --interactive --login -c -- '@zinit-scheduler burst' \
 && figlet "user: ${USER}"

ENTRYPOINT ["zsh"]
CMD ["-i", "-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
