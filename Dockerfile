# syntax=docker.io/docker/dockerfile:1
FROM --platform=linux/amd64 amd64/ubuntu:18.04
LABEL maintainer="Vladislav Doster <mvdoster@gmail.com>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "[INFO]: running on $BUILDPLATFORM, building for $TARGETPLATFORM"

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
  bash build-essential \
  cmake curl \
  figlet file \
  git gdb gcc \
  jq \
  locales \
  make musl \
  nmap neovim \
  pkg-config python3 \
  ruby \
  sudo stow subversion \
  tmux \
  unzip \
  zsh \
  && apt-get dist-upgrade \
  --no-install-recommends \
  -o Dpkg::Options::="--force-confold" \
  -y

# Update Locales
RUN apt-get install -y locales \
  && rm -rf /var/lib/apt/lists/* \
  && localedef \
  -A /usr/share/locale/locale.alias \
  -c \
  -f UTF-8 \
  -i en_US \
  en_US.UTF-8
ENV LANG en_US.utf8

RUN useradd -m -s "$(which zsh)" -N -u "${UID}" "${USER}" \
  && echo "$USER:root" | chpasswd \
  && usermod -aG sudo ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && echo "${USER} ALL=(ALL) ALL" > "/etc/sudoers.d/${USER}" \
  && chmod 0440 /etc/sudoers.d/"${USER}" \
  && chsh --shell $(which zsh) ${USER}

USER ${USER}
WORKDIR $HOME

RUN /bin/bash -c " \
  mkdir ${HOME}/.config \
  && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
  && pushd ${HOME}/.config/dotfiles \
  && make \
  && popd"

CMD ["/bin/zsh"]
