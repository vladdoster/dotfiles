#!/usr/bin/env python3
import argparse
import sys
import tarfile
import tempfile

import requests


def log(msg):
    print(f"[INFO] {msg}")


def err(msg):
    print(f"[ERROR] {msg}")
    sys.exit(0)


def cli():
    cli = argparse.ArgumentParser(prog="installer")
    cli.add_argument("name", help="the program name")
    cli.add_argument("-s", "--source", help="URL of program source code")
    cli.add_argument("-c", "--configure", default="", help="Options passed to configure")
    cli.add_argument("-m", "--make", default="", help="Options passed to make")
    return cli.parse_args()


args = cli()


def download_tarball(tmp):
    response = requests.get(args.source, stream=True)
    if response.status_code == 200:
        tar = tarfile.open(fileobj=response.raw, mode="r:*")
        tar.extractall(path=f"{tmp}")


log(f"installing {args.name}")
with tempfile.TemporaryDirectory() as tmp_dir:
    log(f"temporary directory: {tmp_dir}")
    download_tarball(tmp=tmp_dir)


#  if command -v curl &> /dev/null; then
#  DL_CMD="curl -k --output $PROGRAM_TARBALL"
#  elif command -v wget &> /dev/null; then
#  DL_CMD="wget --output-document $PROGRAM_TARBAL:"
#  else
#  _err "cURL & wget not found, exiting"
#  fi

#  pushd "$PROGRAM_SRC"
#  ls -al
#  _log "configuring $PROGRAM_SRC"
#  if autoconf; then
#  _log "autoconf ran successfully, continuing"
#  elif autoreconf -iv; then
#  _log "autoreconf successful, continuing"
#  elif sh autogen.sh; then
#  _log "ran autogen.sh successfully, continuing"
#  elif AUTOCONF=autoconf2.69 sh ./autogen.sh; then
#  _log "ran autogen.sh successfully, continuing"
#  elif cmake .; then
#  _log "ran cmake successfully, continuing"
#  else
#  _log "failed $PROGRAM_SRC configuration"
#  fi
#  if ./configure; then
#  _log "configure file present, executing "
#  elif ./Configure; then
#  _log "Configure file present, executing "
#  else
#  _log "failed $PROGRAM_SRC configuration"
#  fi
#  if make -j8; then
#  _log "make sucessful, continuing"
#  if sudo make -j8 install; then
#  _log "$PROGRAM_SRC installed"
#  exit 0
#  fi
#  fi
#  _err "failed to install $PROGRAM_SRC"
#  exit 1
