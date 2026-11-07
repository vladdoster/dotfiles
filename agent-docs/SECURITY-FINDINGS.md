# Security findings

Recorded during documentation init at commit 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec on 2026-11-07. This is a snapshot of findings
noticed during source reading, not a security audit. The team maintains this file; edit or
delete entries as needed. Documentation updates do not refresh or recreate it.

## Git disables TLS verification for all HTTP and HTTPS remotes

- Confidence: confirmed. The setting is in the tracked config.
- Evidence: `git/.config/git/config:55` and `git/.config/git/config:58` set `sslVerify = false` under `[http]` and `[https]`.
- Potential impact: once stowed to `~/.config/git/config`, every git fetch, clone and push over HTTPS accepts any certificate. A network attacker can serve altered repository content or capture credentials sent to the remote.
- Follow-up: remove both settings, or scope `sslVerify = false` to the one host that needs it with `http.<url>.sslVerify`.

## curl disables TLS verification for every run

- Confidence: confirmed.
- Evidence: `curl/.curlrc:10` sets `insecure`.
- Potential impact: every curl invocation by this user, including `install.zsh`'s documented `curl | zsh` one-liner when run on a machine where this file is already stowed and the Homebrew installer downloads in `Makefile`, accepts any certificate. A network attacker can substitute the downloaded script, which is then executed.
- Follow-up: remove `insecure` from the global config and pass `-k` only on commands that need it.

## installer script downloads source tarballs without TLS verification and installs them with sudo

- Confidence: confirmed.
- Evidence: `bin/.local/bin/installer:31` runs `curl -Lk` (`-k` skips certificate checks) and `bin/.local/bin/installer:76` runs `sudo make --jobs 8 install` on the extracted source.
- Potential impact: a network attacker who can intercept the download gets root code execution on the machine running the script.
- Follow-up: drop `-k`, and verify a checksum or signature before building.

## Git credentials are stored in plaintext

- Confidence: confirmed.
- Evidence: `git/.config/git/config:10` sets `helper = store --file ~/.config/git/credentials`. `.gitignore` excludes `git/**/credentials`, so the file is not committed.
- Potential impact: tokens and passwords for every remote git has authenticated against sit unencrypted in `~/.config/git/credentials`. Any process or backup with read access to the user's home exposes them.
- Follow-up: use the macOS keychain helper or `gh auth git-credential`.

## Workflows call shared workflows pinned to the moving `master` branch

- Confidence: suspected. The shared repository's contents were read through the GitHub API, not from this repository.
- Evidence: `.github/workflows/release.yml:9`, `.github/workflows/release.yml:12`, `.github/workflows/release.yml:16`, `.github/workflows/release.yml:22`, `.github/workflows/standards.yml:15`, `.github/workflows/standards.yml:18` and `.github/workflows/cleanup-runs.yml:11` use `vladdoster/.github/...@master`. The shared release workflow downloads its release configuration from `master` and installs plugins without version pins.
- Potential impact: a push to the shared repository, or a compromised plugin, runs code with the caller's `GITHUB_TOKEN`, which has `contents: write` during release.
- Follow-up: pin shared workflows to a tag or commit SHA, and pin the plugin and image versions the shared release job uses.

## arch-linux.Dockerfile passes the CA bundle download to wget's log option

- Confidence: suspected. The Dockerfile is not built by any workflow in this repository.
- Evidence: `arch-linux.Dockerfile:25-26` runs `wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /usr/share/ca-certificates/trust-source/rds-combined-ca-bundle.pem`. wget's `-o` writes the log file; the bundle itself goes to the working directory.
- Potential impact: the bundle is probably never installed as a trust anchor, so the step does nothing. If the intent was `-O`, the image would trust the AWS RDS CA bundle.
- Follow-up: confirm the intent and either remove the step or fix the option.

## Container images grant the user passwordless sudo

- Confidence: suspected. Likely intended for a test image.
- Evidence: `Dockerfile:55` and `arch-linux.Dockerfile:44` append `${USER} ALL=(ALL) NOPASSWD:ALL` to `/etc/sudoers`. The shared release workflow publishes the root `Dockerfile` image to ghcr.io (`.github/workflows/release.yml:22`).
- Potential impact: anyone running the published image, or any process inside it, has root without a password.
- Follow-up: confirm the image is meant for local development only, and say so in the README or drop `NOPASSWD`.
