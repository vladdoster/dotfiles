FROM ubuntu:latest

ARG _USER="vlad"
ARG _UID="1001"
ARG _GID="100"
ARG _SHELL="/usr/local/bin/zsh"

RUN useradd -m -s "${_SHELL}" -N -u "${_UID}" "${_USER}"

ENV USER ${_USER}
ENV UID ${_UID}
ENV GID ${_GID}
ENV HOME /home/${_USER}
ENV SHELL ${_SHELL}
ENV DEBIAN_FRONTEND=noninteractive

RUN export INITRD=no \
 && mkdir -p /etc/container_environment \
 && echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe, Multiverse, and deb-src for main.
RUN sed -i 's/^#\s*\(deb.*main restricted\)$/\1/g' /etc/apt/sources.list \
 && sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list \
 && sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list \
 && apt-get update

## See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl \
 && ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot \
 && ln -sf /bin/true /usr/bin/ischroot

RUN apt update \
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
 && apt-get dist-upgrade -y --no-install-recommends -o Dpkg::Options::="--force-confold"

RUN locale-gen en_US \
 && update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 \
 && echo -n en_US.UTF-8 > /etc/container_environment/LANG \
 && echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE

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
CMD ["zsh", "--no-rcs"]
