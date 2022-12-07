# syntax=docker/dockerfile-upstream:master-labs

ARG TARGETPLATFORM=amd64
FROM ubuntu:rolling

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
 && apt-get install -y --no-install-recommends software-properties-common gnupg-agent \
 && add-apt-repository -y ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
  acl apt-utils autoconf automake \
  bsdmainutils bsdutils build-essential bzip2 \
  ca-certificates cmake curl \
  curl \
  debianutils default-jre dialog \
  figlet file fzf \
  g++ gcc git golang gawk \
  jq \
  less libevent-dev libreadline-dev libtree-sitter-dev libz-dev locales lua5.1 luarocks \
  make man-db \
  ncurses-base ncurses-bin ncurses-dev ncurses-term netbase npm \
  openssh-client \
  patch pkg-config python3 python3-dev python3-pip \
  readline-common ripgrep ruby ruby-dev \
  stow subversion sudo \
  tar tree tzdata \
  unzip util-linux-locales uuid-runtime \
  wget \
  xz-utils \
  zsh \
 && if [ "$(. /etc/lsb-release; echo "${DISTRIB_RELEASE}" | cut -d. -f1)" -ge 18 ]; then apt-get install gpg; fi \
 && apt-get remove --purge -y software-properties-common \
 && apt-get autoremove --purge -y \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -f UTF-8 en_US.UTF-8

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

RUN mkdir --parents ${HOME}/.config \
 && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
 && make --directory=${HOME}/.config/dotfiles make install neovim py-update \
 && sudo --user=${USER} --login zsh --interactive --login -c -- '-zinit-scheduler burst' \
 && figlet "user: ${USER}"

ENTRYPOINT ["zsh"]
CMD ["-i", "-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
