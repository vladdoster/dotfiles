# syntax=docker/dockerfile:1

FROM bitnami/minideb:buster

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
  openssh-client openssh-server openssh-sftp-server \
  patch pkg-config python3 python3-dev python3-pip python3-setuptools \
  readline-common ripgrep ruby ruby-dev \
  stow subversion sudo ssh \
  tar tree tzdata \
  unzip util-linux-locales uuid-runtime \
  wget \
  xz-utils \
  zsh \
 && localedef -i en_US -f UTF-8 en_US.UTF-8

RUN apt install openssh-server \
 && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
 && service ssh start \
 && figlet "$(service ssh status)"

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

COPY id_rsa.pub ${HOME}/.ssh/authorized_keys

RUN mkdir --parents code .config \
 && sudo chown --recursive ${USER}:root .ssh \
 && sudo chmod 600 .ssh/authorized_keys

RUN git clone https://github.com/neovim/neovim \
 && make --directory=neovim --jobs=4 \
 && sudo make --directory=neovim --jobs=4 install \
 && rm -rf neovim

RUN git clone https://github.com/vladdoster/dotfiles .config/dotfiles \
 && make --directory=.config/dotfiles install neovim \
 && sudo --user=${USER} --login zsh --interactive --login -c -- '@zi::scheduler burst'

RUN printf "\n %s \n" '------------------------' \
 && printf "user: %s \n" ${USER} \
 && printf "host: %s \n" $(hostname -f) \
 && printf "\n %s \n" '------------------------' \

EXPOSE 22

ENTRYPOINT ["zsh", "-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
