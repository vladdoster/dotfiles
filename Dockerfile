# syntax=docker/dockerfile:1

FROM bitnami/minideb:latest

LABEL org.label-schema.name="vladdoster/dotfiles" \
 org.label-schema.description="Containerized dotfiles environment" \ 
 org.label-schema.docker.cmd="docker run --interactive --mount source=dotfiles-volume,destination=/home/ --tty vladdoster/dotfiles" \
 org.label-schema.schema-version="1.0" \
 org.label-schema.url="http://dotfiles.vdoster.com/" \
 org.label-schema.vcs-url="https://github.com/vladdoster/dotfiles"

ARG USER

ENV USER ${USER:-dotfiles}
ENV HOME /home/${USER}

ENV CLICOLOR 1
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  acl apt-utils autoconf automake \
  bsdmainutils bsdutils build-essential bzip2 \
  ca-certificates cmake curl \
  curl \
  debianutils default-jre dialog \
  figlet file fzf \
  g++ gawk gcc gettext git golang gosu \
  iproute2 \
  jq \
  less libevent-dev libreadline-dev libtool libtool-bin libz-dev locales lua5.1 luarocks \
  make man-db meson \
  ncurses-base ncurses-bin ncurses-dev ncurses-term netbase npm \
  patch pkg-config python3 python3-dev python3-pip python3-setuptools python3-bdist-nsi \
  readline-common ripgrep ruby ruby-dev \
  stow subversion sudo \
  tar tree tzdata \
  unzip util-linux-locales uuid-runtime \
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
 && passwd --delete ${USER} \
 && chown --recursive ${USER} ${HOME}

USER ${USER}
WORKDIR ${HOME}

RUN mkdir --parents code .config \
 && git clone https://github.com/neovim/neovim \
 && make --directory=neovim --jobs=4 \
 && sudo make --directory=neovim --jobs=4 install \
 && rm -rf neovim

RUN git clone https://github.com/vladdoster/dotfiles .config/dotfiles \
 && make --directory=.config/dotfiles --jobs=1 py-pkgs install neovim \
 && sudo --user=${USER} --login zsh --interactive --login -c -- '@zi::scheduler burst'

CMD ["zsh", "--login"]

# FROM build AS ssh_build

# COPY id_rsa.pub ${HOME}/.ssh/authorized_keys

# RUN chown --recursive ${USER}:root .ssh \
#  && chmod 600 .ssh/authorized_keys \
#  && apt install openssh-server \
#  && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
#  && service ssh start \
#  && figlet "$(service ssh status)"

# EXPOSE 22

# CMD ["sudo", "service", "ssh", "start"]
# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
