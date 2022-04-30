FROM ubuntu:latest
LABEL maintainer="Vladislav Doster <mvdoster@gmail.com>"

ARG _USER="vlad"
ARG _UID="1001"
ARG _GID="100"
ARG _SHELL="/usr/bin/zsh"

ENV USER ${_USER}
ENV GID ${_GID}
ENV HOME /home/${_USER}
ENV UID ${_UID}

ENV SHELL ${_SHELL}
ENV TERM xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt upgrade -y \
  && apt install -y \
  apt-utils automake autoconf \
  bat bash build-essential \
  cmake curl \
  git gdb gcc \
  jq \
  language-pack-en \
  make musl \
  nmap neovim \
  python3 \
  ruby \
  sudo stow subversion \
  tmux \
  zsh \
  && apt-get dist-upgrade \
  --no-install-recommends \
  -o Dpkg::Options::="--force-confold" \
  -y \
  && locale-gen en_US.UTF-8 \
  && useradd -m -s "${SHELL}" -N -u "${UID}" "${USER}" \
  && echo "$USER:p@ssword1" | chpasswd \
  && usermod -aG sudo $USER

# && adduser \
# --quiet \
# --disabled-password \
# --shell $SHELL \
# --home $HOME \
# --gecos "User" \
# $USER \

## Enable Ubuntu Universe, Multiverse, and deb-src for main.
# RUN sed -i 's/^#\s*\(deb.*main restricted\)$/\1/g' /etc/apt/sources.list \
#   && sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list \
#   && sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list \
#   && apt-get update

## See https://github.com/dotcloud/docker/issues/1024
# RUN dpkg-divert --local --rename --add /sbin/initctl \
#   && ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
# RUN dpkg-divert --local --no-rename --add /usr/bin/ischroot \
#   && ln -sf /bin/true /usr/bin/ischroot

RUN locale-gen en_US && update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
# && echo -n en_US.UTF-8 > /etc/container_environment/LANG \
# && echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE

RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && echo "${USER} ALL=(ALL) ALL" > "/etc/sudoers.d/${USER}" \
  && chmod 0440 /etc/sudoers.d/"${USER}"

USER ${USER}

RUN mkdir ${HOME}/.config \
  && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
  && chown -R ${UID}:${GID} ${HOME}
# && make -C ${HOME}/.config/dotfiles install \
# && echo "#!/usr/bin/env zsh" > $HOME/.zshrc

WORKDIR ${HOME}
CMD ["zsh"]
