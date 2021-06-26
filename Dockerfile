FROM ubuntu:20.04

MAINTAINER Vlad Doster <me@$username.com>

ARG DEBIAN_FRONTEND=noninteractive
ARG username

#- DEPENDENCIES ----------------------------------
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
      cmake \
      git \
      make \
      python3 python3-dev python3-pip \
      stow \
      sudo \
      tmux \
      zsh

#- LOCALE -----------------------------------------
RUN apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

# USER ENV ----------------------------------------
USER root

RUN useradd --create-home --shell /bin/zsh $username
RUN usermod -aG sudo $username
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown --recursive $username:$username /home/$username

VOLUME /home/$username/.ssh
VOLUME /home/$username/.credentials
VOLUME /home/$username/persistent

RUN chsh --shell /usr/bin/zsh $username \
 && chown --recursive $username:$username /home/$username

USER $username
WORKDIR /home/$username

RUN git config --global http.sslverify "false" \
 && git clone https://github.com/vladdoster/dotfiles.git .dotfiles 

CMD ["zsh"]
