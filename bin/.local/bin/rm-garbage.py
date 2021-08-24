#!/usr/bin/env python3
"""Remove the garbage file."""

import os
import shutil


GARBAGE_FILES = [
    "~/.QtWebEngineProcess/",
    "~/.asy/",
    "~/.bazaar/",
    "~/.bzr.log",
    "~/.cmake/",
    "~/.config/enchant",
    "~/.dbus",
    "~/.distlib/",
    "~/.dropbox-dist",
    "~/.esd_auth",
    "~/.gconf",
    "~/.gconfd",
    "~/.gnome/",
    "~/.gstreamer-0.10",
    "~/.java/",
    "~/.jssc/",
    "~/.local/share/gegl-0.2",
    "~/.local/share/recently-used.xbel",
    "~/.npm/",
    "~/.nv/",
    "~/.oracle_jre_usage/",
    "~/.parallel",
    "~/.pulse",
    "~/.pylint.d/",
    "~/.qute_test/",
    "~/.qutebrowser/",
    "~/.recently-used",
    "~/.spicec",
    "~/.texlive/",
    "~/.thumbnails",
    "~/.tox/",
    "~/.viminfo",
    "~/.w3m/",
]


def yes_or_no(question, default="n"):
    """Asks user for yes or no."""
    prompt = "%s (y/[n]) " % question

    answer = input(prompt).strip().lower()

    if not answer:
        answer = default

    if answer == "y":
        return True
    return False


def rm_garbage():
    """Recursively remove"""
    print("Found garbage files:")
    found = []
    for garbage_files in GARBAGE_FILES:
        expandfile = os.path.expanduser(garbage_files)
        if os.path.exists(expandfile):
            found.append(expandfile)
            print("    %s" % garbage_files)

    if len(found) == 0:
        print("No garbage files found")
        return

    if yes_or_no("Remove all?", default="n"):
        for found_file in found:
            if os.path.isfile(found_file):
                os.remove(found_file)
            else:
                shutil.rmtree(found_file)
        print("All cleaned")
    else:
        print("No file removed")


if __name__ == "__main__":
    rm_garbage()
