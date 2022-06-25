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

RUN bash -c "mkdir ${HOME}/.config \
  && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
  && pushd ${HOME}/.config/dotfiles \
  && make stow/install \
  && make install \
  && popd \
  && zsh"

USER ${USER}

CMD ["zsh"]
