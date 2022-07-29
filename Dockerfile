# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM ubuntu:latest as builder

ARG TARGETOS TARGETARCH TARGETPLATFORM USERNAME

ENV BUILDPLATFORM ${BUILDPLATFORM}
ENV CFG_DIR ${HOME}/.config
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/${USER}
ENV TARGETPLATFORM ${TARGETPLATFORM}
ENV USER ${USERNAME:-docker}

RUN <<EOF
  echo -e "\n--- ${BUILDPLATFORM} building target platform ${TARGETPLATFORM}\n" \
  apt-get update
  apt-get install -y --no-install-recommends \
    apt-transport-https automake 
    ca-certificates cmake curl \
    file \
    git g++ grep \
    make \
    ncurses-base ncurses-bin \
    perl \
    stow subversion sudo \
    tar \
    unzip \
    wget \
    xz-utils \
    zsh \
  rm -rf /var/lib/apt/lists/*
EOF

# RUN <<EOF
#   useradd --create-home --home-dir ${HOME} ${USER}
#   chown -R ${USER}:${USER} ${HOME}
#   usermod -aG sudo,root ${USER}
#   passwd --delete ${USER}
# EOF

# USER ${USER}
# WORKDIR ${CFG_DIR}
#
# RUN <<EOF
#   git clone https://github.com/vladdoster/dotfiles
#   zsh -ilc "make -C ${PWD}/dotfiles install"
# EOF

ENTRYPOINT ["zsh"]
CMD ["-il"]

FROM builder as dev-envs

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /


