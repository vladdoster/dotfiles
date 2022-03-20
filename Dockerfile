FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apk upgrade \
 && apk add \
      automake autoconf \
      bat bash build-base \
      cmake curl \
      git gdb gcc gcompat \
      jq \
      make musl \
      nmap neovim \
      python3 \
      ruby \
      sudo stow subversion \
      tmux \
      xz \
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
