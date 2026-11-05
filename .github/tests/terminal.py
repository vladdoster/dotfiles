#!/usr/bin/env python3
"""Run a command on a pseudo-terminal, like a person typing into Terminal.app.

usage: terminal.py <transcript> <cmd> [args...]

Streams the session to stdout and <transcript>. Answers sudo and chsh password prompts with
$PTY_PASSWORD; with no password set, a prompt kills the command instead of hanging. Answers a
Homebrew "Press RETURN" prompt too, but counts it: NONINTERACTIVE should suppress it. Prints
"prompts: <name>=<count> ..." to stderr and exits with the command's exit status.
"""
import fcntl
import os
import pty
import re
import select
import signal
import struct
import sys
import termios

PROMPTS = [
    ("sudo", re.compile(rb"\[sudo\] password for \S+: ?$"), True),
    ("password", re.compile(rb"^Password(?: for \S+)?: ?$"), True),
    ("press-return", re.compile(rb"Press RETURN/ENTER to continue.*$"), False),
]


def main() -> int:
    transcript, *cmd = sys.argv[1:]
    password = os.environ.pop("PTY_PASSWORD", None)
    pid, fd = pty.fork()
    if pid == 0:
        os.execvp(cmd[0], cmd)
    fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 50, 160, 0, 0))
    answered: dict[str, int] = {}
    line = b""
    with open(transcript, "wb") as log:
        while True:
            if not select.select([fd], [], [], 1.0)[0]:
                continue
            try:
                data = os.read(fd, 65536)
            except OSError:
                break
            if not data:
                break
            log.write(data)
            log.flush()
            sys.stdout.buffer.write(data)
            sys.stdout.flush()
            line = (line + data).rsplit(b"\n", 1)[-1].replace(b"\r", b"")[-512:]
            for name, pattern, secret in PROMPTS:
                if not pattern.search(line):
                    continue
                if secret and password is None:
                    print(f"\nterminal.py: {name} prompt but PTY_PASSWORD is unset", file=sys.stderr)
                    os.kill(pid, signal.SIGKILL)
                    break
                os.write(fd, (password if secret else "").encode() + b"\n")
                answered[name] = answered.get(name, 0) + 1
                line = b""
                break
    _, status = os.waitpid(pid, 0)
    summary = " ".join(f"{name}={count}" for name, count in sorted(answered.items()))
    print(f"prompts: {summary}", file=sys.stderr)
    return os.waitstatus_to_exitcode(status)


if __name__ == "__main__":
    sys.exit(main())
