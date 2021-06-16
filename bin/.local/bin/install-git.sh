#!/usr/bin/env bash

PROGRAM="git"
URL="https://github.com/git/git"

temp_dir() {
    temp_prefix=$(basename "$0")
    mktemp -d /tmp/${temp_prefix}.${PROGRAM}.XXXXXX
}

INSTALL_DIR=$(temp_dir)

trap 'catch' ERR
catch() {
  echo "--- ERROR: An error has occurred while running $0"
}

trap 'catch' EXIT
catch() {
  rm -rf "$temp_dir"
  echo "--- Removed tmp files"
}

echo "--- Removing git installed via a package manager"
sudo yum remove -y git || echo "--- Removed previous git installations"
echo "--- Installing dependencies"
sudo yum install -y dh-autoreconf \
                    curl-devel \
                    expat-devel \
                    gettext-devel \
                    openssl-devel \
                    perl-devel \
                    zlib-devel
  || echo "--- yum is not available, skipping"
echo "--- Cloning $PROGRAM repository"
# git clone "${URL}" "${INSTALL_DIR}"
# wget --output-document https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
# tar -xvf
pushd "$INSTALL_DIR"
echo -e "--- Configuring $PROGRAM install"
if [[ -e autogen.sh ]]; then
  echo "--- Found an autogen.sh file"
    sh autogen.sh
elif [[ -e configure ]]; then 
  echo "--- Found a ./configure file"
  ./configure
else
  echo "--- No configuration files found"
fi
echo -e "\n--- Configured $PROGRAM install"
make
PS3="Select an install type: "
select opt in "global" "user"; do
    case $REPLY in
        1)
            echo "--- Updating $opt $PROGRAM install"
            sudo make install
            break
            ;;
        2)
            echo "--- Updating $opt $PROGRAM install"
            make install 
            break
            ;;
        *)
          echo "--- Invalid selection"
          exit 1
          ;;
    esac
done
pushd
if ! command -v "$PROGRAM" &> /dev/null; then
  echo "--- Install completed but $PROGRAM isn't on $USER path"
  exit 1
fi
echo "--- Successfully installed $PROGRAM"
