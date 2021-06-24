FROM debian:stretch-slim

MAINTAINER Vlad Doster <me@$username.com>

ARG username

# System setup

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get clean && \
  apt-get -y install curl

RUN \
  apt-get -y install tmux && \
  apt-get -y install git && \
  apt-get -y install neovim && \
  apt-get -y install locales && \
  apt-get -y install zsh && \
  apt-get -y install stow && \
  apt-get -y install make

# locale

RUN \
  echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
  locale-gen en_US.UTF-8

# Create the user and copy over files

RUN useradd -ms /bin/zsh $username
RUN chown -R $username:$username /home/$username

# SSH keys, credentials, persistent directory TBD at container run time

VOLUME /home/$username/.ssh
VOLUME /home/$username/.credentials/
VOLUME /home/$username/persistent/

COPY . /home/$username/dotfiles/

# Install oh-my-zsh and vim plug

USER $username
WORKDIR /home/$username/dotfiles

# Override the .zshrc that oh-my-zsh gives us in favor of our own
# make stow will link everthing in dotfiles/

RUN make stow

# Change the shell to zsh

USER root
RUN chsh -s /usr/bin/zsh $username

USER $username
WORKDIR /home/$username

CMD ["zsh"]
