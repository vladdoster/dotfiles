FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt update \
 && apt upgrade -y \
 && apt install -y \
      automake autoconf \
      bat bash \
      cmake curl \
      git gdb gcc \
      jq \
      make musl \
      nmap neovim \
      python3 \
      ruby \
      sudo stow subversion \
      tmux \
      zsh

RUN \
    NEWUSER="vlad" \
 && echo "${NEWUSER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser \
   --ingroup root \
   --shell="$(which zsh)" \
   --system "${NEWUSER}" \
 && echo "${NEWUSER} ALL=(ALL) ALL" > /etc/sudoers.d/"${NEWUSER}" \
 && chmod 0440 /etc/sudoers.d/${NEWUSER}

USER vlad

RUN \
	git config --global url."https://github.com/".insteadOf git@github.com: \
 && git config --global url."https://".insteadOf git:// \
 && git clone "git@github.com:vladdoster/dotfiles.git" "${HOME}/.config/dotfiles"

WORKDIR /home/vlad/.config/dotfiles

RUN make

ENTRYPOINT ["zsh"]
