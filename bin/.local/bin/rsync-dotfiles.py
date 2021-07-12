#!/usr/bin/env python3

import argparse
from os import environ as env
import subprocess
import socket
import os

print("--- Syncing dotfiles")


def run_command(command):
    p = subprocess.Popen(
        command.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    return iter(p.stdout.readline, b"")


host = f"{env['USER']}@{socket.getfqdn()}"
hosts = ["anonymous@jupiter.local"]

cli = argparse.ArgumentParser(prog="rsync-dotfiles")
cli.add_argument(
    choices=["push", "pull"], dest="direction", help="Pull or push from a system"
)
cli.add_argument(
    "-s",
    "--system",
    dest="system",
    choices=hosts,
    help="Systems with dotfiles",
    required=True,
)
args = cli.parse_args()

print(f"--- {args.direction}ing dotfiles from {host} to {args.system}")

if args.direction == "pull":
    for line in run_command(
        f"rsync -azP {args.system}:~/.config/dotfiles {env['HOME']}"
    ):
        print(line)

if args.direction == "push":
    for line in run_command(
        f"rsync -azP {env['HOME']}/.config/dotfiles {args.system}:~/"
    ):
        print(line)
