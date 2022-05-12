# FROM debian:latest
FROM ubuntu:18.04

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
  figlet \
  git gdb gcc \
  jq \
  locales \
  make musl \
  nmap neovim \
  python3 \
  ruby \
  unzip \
  sudo stow subversion \
  tmux \
  zsh \
  && apt-get dist-upgrade \
  --no-install-recommends \
  -o Dpkg::Options::="--force-confold" \
  -y

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

RUN useradd -m -s "$(which zsh)" -N -u "${UID}" "${USER}" \
  && echo "$USER:root" | chpasswd \
  && usermod -aG sudo ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && echo "${USER} ALL=(ALL) ALL" > "/etc/sudoers.d/${USER}" \
  && chmod 0440 /etc/sudoers.d/"${USER}"

USER ${USER}
WORKDIR $HOME

RUN /bin/bash -c "\
  mkdir ${HOME}/.config \
  && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
  && pushd ${HOME}/.config/dotfiles \
  && make brew-install \
  && make install \
  && popd"

CMD ["/bin/zsh"]
