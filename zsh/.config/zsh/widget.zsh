#!/usr/bin/env zsh
function _accept-line-with-url {
    if  [[ $BUFFER =~ ^https.*git ]]
    then
        echo $BUFFER >> $HISTFILE
        fc -R
        BUFFERz="git clone $BUFFER && cd $(basename $BUFFER .git)"
        zle .kill-whole-line
        BUFFER=$BUFFERz
        zle .accept-line
      elif [[ $BUFFER =~ ^[[:space:]]?\$[[:space:]] ]]
    then
        echo $BUFFER >> $HISTFILE
        fc -R
	BUFFERz="$(echo ${BUFFER/\$/} | xargs)"
        # zle .kill-whole-line
        BUFFER=$BUFFERz
        zle .accept-line
    else
        zle .accept-line
    fi
}
zle -N accept-line _accept-line-with-url

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
