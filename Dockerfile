FROM debian:latest AS build
# ARG TARGETPLATFORM
# ARG BUILDPLATFORM
# RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

ARG USERNAME
ENV DEBIAN_FRONTEND noninteractive
ENV USER=${USERNAME:-docker}
ENV HOME /home/${USER}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-transport-https automake \
  ca-certificates cmake curl \
  file \
  git g++ \
  make \
  ncurses-base ncurses-bin \
  subversion sudo \
  tar \
  unzip \
  wget \
  xz-utils \
  zsh \
  && rm -rf /var/lib/apt/lists/*

RUN useradd \
  --create-home \
  --home-dir ${HOME} ${USER} \
  && chown -R ${USER}:${USER} ${HOME} \
  && usermod -a -G sudo,root ${USER} \
  && passwd --delete ${USER}

USER ${USER}
WORKDIR ${HOME}

RUN mkdir ${HOME}/.config \
  && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
 && make -C ${HOME}/.config/dotfiles install/gnu-stow \
 && make -C ${HOME}/.config/dotfiles install \

# WORKDIR ${HOME}/.config/dotfiles

# RUN make -C ${HOME}/.config/dotfiles install/gnu-stow \
#  && make -C ${HOME}/.config/dotfiles install \

USER "$USER"

CMD ["zsh"]
