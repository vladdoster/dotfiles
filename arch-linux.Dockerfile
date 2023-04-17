FROM archlinux:base-devel
LABEL org.label-schema.name="vladdoster/dotfiles"
LABEL org.opencontainers.image.title="dotfiles"
LABEL org.opencontainers.image.source="http://dotfiles.vdoster.com/"
LABEL org.opencontainers.image.description="Containerized dotfiles environment"

ARG USER

ENV USER ${USER:-dotfiles}
ENV HOME /home/${USER}

ENV CLICOLOR 1
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

ENV \
    UID="1000" \
    GID="1000" \
    UNAME="$USER" \
    SHELL="/bin/zsh"

RUN pacman -Syu --noprogressbar --noconfirm --needed \
  cmake clang unzip ninja git curl wget openssh zsh reflector sudo \
  && reflector -p https -c us --score 20 --connection-timeout 1 --sort rate --save /etc/pacman.d/mirrorlist \
  && wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
  -o /usr/share/ca-certificates/trust-source/rds-combined-ca-bundle.pem \
  && update-ca-trust

  RUN sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    && pacman -Sy --noprogressbar --noconfirm --needed archlinux-keyring \
    && pacman -Scc \
    && rm -Rf /etc/pacman.d/gnupg \
    && pacman-key --init \
    && pacman-key --populate archlinux

RUN useradd \
  --create-home \
  --gid root --groups wheel \
  --home-dir ${HOME} \
  --shell "$(which zsh)" \
  --uid 1001 \
  ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers \
  && passwd --delete ${USER} \
  && chown --recursive ${USER} ${HOME}

USER $USER
WORKDIR $HOME

RUN git clone --depth 1 -- https://aur.archlinux.org/yay.git \
 && cd yay \
 && makepkg -si --noprogressbar --noconfirm \
 && cd - \
 && rm --force --recursive -- yay

RUN yay -Syu --noprogressbar --noconfirm --needed \
  acl autoconf automake \
  bzip2 \
  ca-certificates cmake cpanminus curl \
  git-delta dialog \
  exa \
  figlet file fzf \
  gawk gcc gettext git gnupg gosu \
  iproute2 \
  jq \
  less libtool luajit luarocks \
  make man-db meson \
  ncurses neovim npm \
  patch pkg-config python3 perl \
  ripgrep ruby \
  stow subversion \
  tar texinfo tree tzdata \
  unzip   \
  wget \
  xz \
  zsh
# I don't know why I have to set this again, but I do...
RUN sudo sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen \
 && sudo locale-gen

# RUN git clone --depth 1 --quiet https://github.com/neovim/neovim \
#  && make --directory=neovim -j16 --quiet --silent \
#  && sudo make --directory=neovim -j16 --quiet --silent install \
#  && sudo rm -rf neovim

# COPY --chown=${USER}:1001 . ${HOME}/.config/dotfiles/

RUN mkdir -p $HOME/.config \
 && git clone --quiet -- https://github.com/vladdoster/dotfiles $HOME/.config/dotfiles

# COPY --chown=${USER}:1001 . ${HOME}/.config/dotfiles/

RUN zsh --interactive --login -c "make --directory=$HOME/.config/dotfiles --jobs=1 install neovim" \
 && zsh --interactive --login -c -- '@zinit-scheduler burst'

ENV TERM="xterm-256color"

CMD ["zsh","--login","--interactive"]

# vim: syn=dockerfile:ft=dockerfile:fo=croql:sw=2:sts=2:
