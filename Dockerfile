# syntax=docker/dockerfile-upstream:master-labs

ARG TARGETPLATFORM=amd64
FROM --platform=${TARGETPLATFORM} ubuntu:20.04

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="vladdoster/dotfiles"
LABEL org.label-schema.description="Containerized dotfiles environment"
LABEL org.label-schema.url="http://dotfiles.vdoster.com/"
LABEL org.label-schema.vcs-url="https://github.com/vladdoster/dotfiles"
LABEL org.label-schema.docker.cmd="docker run --interactive --mount source=dotfiles-volume,destination=/home/ --tty vladdoster/dotfiles"

ARG USER

ENV DEBIAN_FRONTEND noninteractive
ENV USER ${USER:-"dotfiles"}
ENV HOME "/home/${USER}"
ENV BREW_PREFIX "/home/${USER}/.linuxbrew"

# RUN apt-get update \
#  && apt-get --yes --fix-missing install --no-install-recommends \
#     apt-utils autoconf automake \
#     bsdmainutils bsdutils build-essential \
#     ca-certificates cmake curl \
#     debianutils \
#     figlet file \
#     g++ gcc git \
#     less libevent-dev libz-dev locales \
#     make \
#     ncurses-base ncurses-bin ncurses-dev \
#     pkg-config python3-pip python3.8 python3.8-dev \
#     stow subversion sudo \
#     tar tree tzdata \
#     unzip util-linux-locales \
#     vim \
#     wget \
#     xz-utils \
#     zsh
#

RUN apt-get update \
 && apt-get --yes --fix-missing install --no-install-recommends \
    bsdmainutils bsdutils build-essential \
    ca-certificates cmake curl \
    figlet \
    git \
    make \
    ncurses-base ncurses-bin ncurses-dev \
    sudo stow \
    tar tree tzdata \
    wget \
    zsh

RUN useradd \
  --create-home \
  --gid root --groups sudo \
  --home-dir ${HOME} \
  --shell "$(which zsh)" \
  --uid 1001 \
  ${USER} \
 && passwd --delete ${USER}

WORKDIR ${HOME}
RUN mkdir --parents ${BREW_PREFIX} \
 && git clone --progress https://github.com/Homebrew/brew ${BREW_PREFIX}/Homebrew \
 && git -C "${BREW_PREFIX}/Homebrew" remote set-url origin https://github.com/Homebrew/brew \
 && mkdir --parents ${BREW_PREFIX}/bin \
 && ln -s ${BREW_PREFIX}/Homebrew/bin/brew ${BREW_PREFIX}/bin \
 && eval $(${BREW_PREFIX}/bin/brew shellenv) \
 && rm -rf "${BREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-core" \
 && brew tap --repair --verbose homebrew/core \
 && brew help

#== WIP ==
# ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/homebrew-core.git#master $BREW_PREFIX/Homebrew/Library/Taps/homebrew/homebrew-core
# ADD --keep-git-dir=true --chown=${USER}:${USER} https://github.com/Homebrew/brew.git#master $BREW_PREFIX/Homebrew

# ADD --keep-git-dir=true https://github.com/vladdoster/dotfiles.git#master $HOME/dotfiles
# ADD --keep-git-dir=true https://github.com/zdharma-continuum/zinit.git#main $HOME/.local/share/zinit/zinit.git

# RUN <<INSTALL-HOMEBREW bash
#   # ln -s ${BREW_PREFIX}/Homebrew/bin/brew ${BREW_PREFIX}/bin
#   chown -R ${USER} ${HOME}
# INSTALL-HOMEBREW
#== WIP ==

RUN mkdir --parents ${HOME}/.config \
 && git clone https://github.com/vladdoster/dotfiles ${HOME}/.config/dotfiles \
 && make --directory ${HOME}/.config/dotfiles make install \
 && chown --recursive "${USER}" "${HOME}" \
 && figlet "user: ${USER}"

USER ${USER}
WORKDIR ${HOME}
ENTRYPOINT ["zsh"]
CMD ["-l"]

# vim:syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2
