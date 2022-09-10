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
    elif [[ $BUFFER =~ ^([[:space:]]|)$ .* .*git ]]
    then
        echo $BUFFER >> $HISTFILE
        fc -R
        BUFFERz="git clone $BUFFER && cd $(basename $BUFFER .git)"
        zle .kill-whole-line
        BUFFER=$BUFFERz
        zle .accept-line
    else
        zle .accept-line
    fi
}
zle -N accept-line _accept-line-with-url

# vim:ft=zsh:sw=2:sts=2
