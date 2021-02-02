kitty-ssh() {
  case $TERM in
  *kitty*) alias ssh="kitty +kitten ssh " ;;
  *) echo "You arent using the Kitty terminal" && exit 0 ;;
  esac
}

shell_fmt() {
  SHFMT_OPTS="-i 4 -ln bash 1 -ci -sr -kp -s -w"
  sudo docker run --rmi \
    --volume "${PWD}":/work \
    tmknom/shfmt "${SHFMT_OPTS}" \
    "${@}"
}

set_zsh_as_default_sh() {
  sudo sh --command "echo $(which zsh) >> /etc/shells"
  chsh -s $(which zsh)
  echo "Set zsh as default sh"
}

remove_ds() {
  find "${PWD}" \
    -type f \
    -name "*.DS_Store" \
    -ls -delete
}

add_ssh_host() {
  if [ $# -gt 0 ]; then
    echo "ERROR: add-ssh-host takes no arguments" && exit 1
  else
    echo -n "Enter host nickname: " && read HOST
    echo -n "Enter hostname: " && read HOSTNAME
    echo -n "Enter user: " && read USER
    echo -n "Enter port: " && read PORT
  fi
  cat >>"${HOME}"/.ssh/config <<-END
    Host ${HOST}
      HostName ${HOSTNAME}
      User ${USER}
      Port ${PORT}

END
}
