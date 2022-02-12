#!/bin/bash
# sudo apt install jq wget curl
# usage: github-install user/repo
set -e

repo=$1
tmp="/tmp/.github-install"
binpath="$HOME/.local/bin"

rm -rf $tmp
mkdir -p $tmp
url="https://api.github.com/repos/$1/releases/latest"
echo "Reading... $url"

PS3="Select download file: "
select filename in $(curl -s $url | jq -r '.assets[].name'); do break; done
echo "Downloading... $filename"
curl -s $url | jq -r --arg filename "$filename" '.assets[] | select(.name == $filename) | .browser_download_url' | wget -i- -q --show-progress -P "$tmp"

# extract
extract () {
    for arg in $@ ; do
        if [ -f $arg ] ; then
            case $arg in
                *.tar.bz2)  tar xjf $arg      ;;
                *.tar.gz)   tar xzf $arg      ;;
                *.tar.xz)   tar xzf $arg      ;;
                *.bz2)      bunzip2 $arg      ;;
                *.gz)       gunzip $arg       ;;
                *.tar)      tar xf $arg       ;;
                *.tbz2)     tar xjf $arg      ;;
                *.tgz)      tar xzf $arg      ;;
                *.zip)      unzip $arg        ;;
                *.Z)        uncompress $arg   ;;
                *.rar)      rar x $arg        ;;  # 'rar' must to be installed
                *.jar)      jar -xvf $arg     ;;  # 'jdk' must to be installed
                *)          echo "'$arg' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$arg' is not a valid file"
        fi
    done
}

pushd $tmp
extract $filename
PS3="Select binary: "
select bin in $(find . -type f); do break; done
popd

# install
basename=$(basename $bin)
read -p "Choose an alias (empty to leave: $basename): " alias
target="$binpath/${alias:-$basename}"
mv "$tmp/$bin" "$target"
chmod +x "$target"
echo "Success!"
echo "Saved in: $target"
