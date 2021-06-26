FROM archlinux:latest

MAINTAINER Vlad Doster <me@$username.com>

ARG username

#- DEPENDENCIES ----------------------------------
RUN \
  pacman -Syyu --noconfirm && \
  pacman -S --needed --noconfirm \
    base-devel \
    git

#- LOCALE -----------------------------------------
RUN \
  echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
  locale-gen en_US.UTF-8

# USER RELATED -----------------------------------
USER root
WORKDIR /home/$username

RUN useradd --create-home --user-group $username && \
    usermod -aG wheel $username && \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    newgrp wheel

VOLUME /home/$username/.ssh
VOLUME /home/$username/.credentials/
VOLUME /home/$username/persistent/

COPY . /home/$username/.config/dotfiles

WORKDIR /home/$username/.config/dotfiles
RUN chown --recursive $username:$username /home/$username

USER $username
WORKDIR /home/$username

RUN \
  git clone https://aur.archlinux.org/yay-git.git /tmp/yay-git && \
  cd /tmp/yay-git && \
  yes 'Y' | makepkg -si

RUN \
  yes 'Y' | yay && \
  yes 'Y' | yay -S --noconfirm \
    neovim-git \
    pod2man \
    python \
    python-pip \
    stow-git \
    tmux-git \
    topgrade \
    zsh-git && \
    chsh --shell /usr/bin/zsh $username

CMD ["zsh"]
