function dcb() {
  docker-compose exec -it $1 /bin/bash
}
function cdd() {
  cd $(dirname $1)
}
#function zipdir() {
#  zip -r "$1.zip" $1
#}
#compdef _dirs zipdir
function unzipall() {
  for x in *.zip; do
    unar -d $x
    rm $x
  done
}
function ssh() {
  if [[ $TERM =~ "kitty" ]]; then
    kitty +kitten ssh $@
  else
    ssh $@
  fi
}
function removeds() {
  find . \
    -type f \
    -name '*.DS_Store' \
    -ls -delete
}
function add-ssh-host() {
  if [[ $# -gt 0 ]]; then
    echo "ERROR: add-ssh-host takes no arguments"
    exit 1
  else
    echo -n "Enter host nickname: " && read HOST
    echo -n "Enter hostname: " && read HOSTNAME
    echo -n "Enter user: " && read USER
    echo -n "Enter port: " && read PORT
  fi
  cat >> "${HOME:-~}/.ssh/config" <<- END
		Host $HOST  
		  HostName $HOSTNAME
		  User $USER
		  Port $PORT

	END
}
function reload-shell() {
  exec $SHELL -l
}

