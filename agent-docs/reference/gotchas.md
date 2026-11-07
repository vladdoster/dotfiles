---
id: reference/gotchas
title: Gotchas
parent: START-HERE
owns: []
triggers:
  - find out why a line looks wrong before removing it
  - change brew-bundle flags or the Brewfile node entries
  - delete or rename an autoloaded zsh function
  - fix a stale comment in install.zsh or AGENTS.md
  - move machine-specific settings out of the tracked git config
entry_points:
  - Makefile:70
  - Brewfile:37
  - install.zsh:37
  - zsh/.config/zsh/functions/AGENTS.md:13
related:
  - areas/bootstrap
  - areas/zsh
  - areas/cli-tools
  - areas/desktop
  - components/zsh/startup
  - components/zsh/function-tooling
  - components/zsh/everyday-utilities
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---

**Related:** [Bootstrap](../areas/bootstrap.md) · [Zsh](../areas/zsh.md) · [CLI tools](../areas/cli-tools.md) · [Desktop](../areas/desktop.md) · [Startup](../components/zsh/startup.md) · [Function tooling](../components/zsh/function-tooling.md)

Constraints that are not visible from the code's shape, and code that looks wrong. Each entry says what looks wrong, why it is that way, and what breaks if it changes. The sources are the comments in `Makefile`, `install.zsh` and `Brewfile`, the bugfix commit history, the "Gotchas" section of the root `AGENTS.md`, and discrepancies the area docs recorded. The repository has no `TODO`, `FIXME` or `HACK` comments at this commit, and the one revert in history reverts a CI version bump (`6b83a41`).

Entries marked "intentional" have a source comment or commit that states the reason. Entries marked "unexplained" are inconsistencies where no source gives a reason; they are listed so nobody builds on them.

## Install and Homebrew

### `brew-bundle` removes everything not in the Brewfile (intentional)

`brew bundle install ... --force --force-cleanup --zap` (`Makefile:75`) uninstalls every formula, cask and package absent from `Brewfile`, and `--zap` deletes cask support files. The root `AGENTS.md` repeats the warning (`AGENTS.md:9`). A tool installed by hand, or by a package in another area, disappears on the next sync unless it is listed. Dropping `--force-cleanup` stops the removal, and the Brewfile then no longer describes the machine.

### `brew-bundle` has no `--verbose` (intentional)

The comment at `Makefile:70-71` says verbose mode runs npm with Homebrew's stripped `PATH`, so npm's `#!/usr/bin/env node` fails with "env: node: No such file or directory". Adding `--verbose` for debugging breaks the `npm` entries. `.github/tests/install.zsh:49-55` asserts the dry-run recipe contains neither `--verbose` nor `--jobs`.

### `node` is listed twice, with different link modes (intentional)

`brew "node", link: false` and `brew "node@24", link: :overwrite` (`Brewfile:39`, `Brewfile:41`). Brew bundle runs npm with only `$HOMEBREW_PREFIX/opt/node/bin` added to `PATH`, so the plain `node` formula must be installed for the `npm` entries to work, but it stays unlinked so `node@24` provides `node` on `PATH` (`Brewfile:37-38`). `:overwrite` is used because bundle ignores `:force` (`Brewfile:40`). Removing `brew "node"` breaks every `npm` line; linking it makes the two formulae fight over `PATH`. The regression test enforces both the allowed `link:` values and the `node` entry (`.github/tests/install.zsh:60-75`).

### `cargo-update` is a bottle, not a `cargo` package (intentional)

The comment at `Brewfile:10` says `cargo install --locked cargo-update` fails to build against Homebrew's OpenSSL 4. Moving the entry to the `cargo` group in the MISC section reintroduces the build failure. Commit `6ece94b` made this change.

### `brew-install` calls `sudo --validate` before `NONINTERACTIVE=1` (intentional)

`NONINTERACTIVE=1` skips Homebrew's RETURN prompt, but the installer then runs `sudo -n`, which fails on a fresh Mac with no cached credentials (`Makefile:58-60`). The recipe caches credentials first when stdin is a TTY and `sudo` exists (`Makefile:63`). Without the line, a first install on a new Mac stops with "Insufficient permissions to install Homebrew". Commit `7d38c63` introduced it; the test stubs `sudo` and checks the call order (`.github/tests/install.zsh:22-47`).

### `GIT_CONFIG` is unset before Git or Homebrew run (intentional)

The stowed zsh environment exports `GIT_CONFIG` pointing at the tracked config (`zsh/.config/zsh/rc.d/00-env.zsh:19`). `install.zsh` unsets it with `GIT_DIR` and `GIT_WORK_TREE`, because inherited it breaks the Homebrew installer and makes `git config` writes edit tracked files (`install.zsh:152-155`). The `Makefile` repeats the unset inside the installer command (`Makefile:64`). Removing either breaks a re-run of the one-liner from a shell that already has the dotfiles loaded.

### macOS preflight probes `xcode-select -p`, not `git` (intentional)

`/usr/bin/git` is a shim that opens a GUI dialog until the Command Line Tools exist, so asking for `git` triggers the dialog on a fresh Mac (`install.zsh:163-166`). Replacing the probe with `$+commands[git]` makes the script hang on that dialog in a non-interactive run.

### The existing-clone check reads the raw origin URL (intentional)

`git remote get-url` applies `url.*.insteadOf` rewrites, so the script reads remote.origin.url with `git config` (`install.zsh:210-212`). `.github/tests/install.zsh:97-134` uses an `insteadOf` rule to redirect GitHub to a local bare repository; switching to `get-url` makes the existing-clone match fail in that test and for any user with a rewrite.

### The whole installer lives inside functions (intentional)

The only top-level command is `main "$@"` (`install.zsh:306-308`). zsh parses the full file before running anything, so a truncated `curl` download fails to parse and executes nothing. A top-level statement added above `main` runs even on a partial download.

### `make install` exits 0 when a package is skipped (intentional)

The loop is `stow ... --restow "$pkg" || echo "==> skipped $pkg" >&2` (`Makefile:41`). A conflict skips only that package, which `AGENTS.md:7` documents. The exit status stays 0, so the stow hint at `install.zsh:261-262` fires only if `make` itself fails. The e2e test therefore greps the transcript for `==> skipped` (`.github/tests/e2e.zsh:72`). Anything that depends on the exit status of `make install` to detect a conflict gets a false success.

### `install.zsh` documents a catch-all `%:` rule that the Makefile lacks (stale comment)

The comment at `install.zsh:37-38` says "the Makefile has a catch-all `%:` rule, so a typo'd target silently succeeds". `grep -n '%:' Makefile` finds no such rule at this commit, so a mistyped target makes `make` fail with "No rule to make target". The advice to use exact target names still holds, and `delegate` counts a failure either way (`install.zsh:41-53`). Do not add a `%:` rule on the strength of the comment: it would hide the failures that `delegate` now reports.

### `update-readme` uses BSD `sed -i ''` (macOS only)

`sed -i '' -e '/^|/d' README.md` (`Makefile:136`) is BSD syntax; GNU sed reads `''` as the input file name. Running the target on Linux fails. The table is built by `uvx --with mdformat-gfm mdformat -` (`Makefile:138`), which needs the `mdformat` entry from the Brewfile's `uv` group.

## Zsh startup and functions

### The root `AGENTS.md` lists an rc.d stage called `repeat` that does not exist (stale)

`AGENTS.md:25` names nine stages ending in `repeat`. zsh/.config/zsh/rc.d holds eight files, `00-env` to `07-prompt`. The only reference is the header comment of `mkrepeat`, which says to call it from rc.d (`zsh/.config/zsh/functions/mkrepeat:8`); no rc.d file does. A new rc.d file needs a numeric prefix and a name ending in `zsh`, because the loop globs rc.d/<->-*zsh(N) (`zsh/.config/zsh/.zshrc:24`). Creating a `repeat` file with no prefix would not load.

### functions.zwc has a stale digest and nothing in the repo builds it

`zsh/.config/zsh/functions/AGENTS.md:13` says to rebuild ../functions.zwc after adding or deleting a function, and `AGENTS.md:33` says a stale digest keeps serving a deleted function. `*.zwc` is gitignored (`.gitignore:11`) and the autoload globs skip it (`zsh/.config/zsh/.zprofile:40`, `zsh/.config/zsh/functions/r:29`). Deleting a function file without rebuilding the digest leaves the old function callable. `r` does not touch the digest, and `zsh-clean` deletes every `*.zwc` below `$ZDOTDIR` (`zsh/.config/zsh/functions/zsh-clean:33`), which clears a stale one. The command that creates the digest is not determined from the code.

### `zsh -f` sandboxes need `setopt extendedglob`

`AGENTS.md:34` says function files do not load under `zsh -f` without it. The autoload line uses the `~` exclusion and `(N-.:t)` qualifiers (`zsh/.config/zsh/.zprofile:40`), which need `extended_glob`. `.zshrc` sets the option (`zsh/.config/zsh/.zshrc:4`); `-f` skips `.zshrc`.

### `fzf` colours apply one shell late on a first install

03-fzf.zsh sets `FZF_DEFAULT_OPTS` only when `fzf` is on `PATH` (`zsh/.config/zsh/rc.d/03-fzf.zsh:3`). zinit installs `fzf` later, in 05-zinit.zsh (`zsh/.config/zsh/rc.d/05-zinit.zsh:94`). On the first shell after a fresh install `fzf` is absent when `03` runs. This follows from file order and was not tested. Moving the check after `05` changes the order guarantee other stages rely on.

### The zinit `if'(())'` ice and the first-entry `if'((1))'`

`zi if'(())' from'gh-r' lbin'!' lman for` (`zsh/.config/zsh/rc.d/05-zinit.zsh:91`) applies an `if` ice that evaluates an empty arithmetic expression, and the first entry overrides it with `if'((1))'` (`zsh/.config/zsh/rc.d/05-zinit.zsh:92`). A source comment explaining the intent was not found. How the ice list distributes to the remaining entries (fzf, bat, fd, hyperfine, topgrade) was not determined from the code, so changing either ice can silently stop those binaries from installing.

### The `zinit-annex-binary-symlink` annex is pinned to a feature branch

`ver'fix/binary-selection-glob'` (`zsh/.config/zsh/rc.d/05-zinit.zsh:50`) pins the annex to a branch, not a release. If that branch is deleted or force-pushed upstream, a fresh zinit install fails at this entry. The reason for the pin is not recorded in the file.

### `compinit` runs after rc.d, so `_comps` does not exist yet

`.zshrc` calls `compinit` after the rc.d loop (`zsh/.config/zsh/.zshrc:29-30`). The zinit stage guards its `_comps[zinit]=_zinit` assignment with `((${+_comps}))` (`zsh/.config/zsh/rc.d/05-zinit.zsh:40-41`), so it may never execute on a first pass. Commits `bbdd81c`, `b1a251e` and `a91cda2` reordered `compinit` for this reason. Adding a `compdef` call to rc.d has the same problem. A second `compinit` call fixes the symptom and costs shell start time.

### `NO_RC` and `NO_ZINIT` are tested for non-empty values

`NO_RC=0` still skips rc.d, because the test is `(( ! $#NO_RC ))` (`zsh/.config/zsh/.zshrc:23`). `NO_ZINIT` follows the same rule and also unsets itself when it fires (`zsh/.config/zsh/rc.d/05-zinit.zsh:6-8`). To enable a stage again, unset the variable.

### `c` hard-codes `$HOME/code` although `CODEDIR` exists

`local dest=$HOME/code/$1` (`zsh/.config/zsh/functions/c:28`), while 00-env.zsh exports `CODEDIR="$HOME/code"` (`zsh/.config/zsh/rc.d/00-env.zsh:10`). Setting `CODEDIR` to another path changes the `~code` named directory and anything reading the variable, but not `c`. Commit `6335111` last reworked its logic and left the path. The `topgrade` config also assumes `~/code/*` (`topgrade/.config/topgrade.toml:10`). Unexplained.

### `extract` matches .tar.zstd, but zstd archives are normally named .tar.zst

The `case` branch is `(*.tar.zstd)` (`zsh/.config/zsh/functions/extract:63`) and the completion's file glob lists `zstd` (`zsh/.config/zsh/completions/_extract:5`). A file named archive.tar.zst matches neither `*.tar.zstd` nor any other branch that handles zstd, so `extract` does not unpack it. Adding a `*.tar.zst` branch next to the existing one, and its completion glob, is the fix; the behaviour change has not been made here. Unexplained.

### `extract -r` only works as the first argument

`extract` checks `$1` for `-h` and `-r` by hand and does not use `zparseopts` (`zsh/.config/zsh/functions/extract:13-25`). `extract file.zip -r` treats `-r` as a file name.

## Git, curl and other tool config

### `git config --global` writes through the stow symlink

`~/.config/git/config` is a symlink into the tracked `git/.config/git/config`, so `git config --global` edits a tracked file (`AGENTS.md:31-32`). The root instructions send machine settings to ~/.config/git/config.local. The tracked config has no `[include]` or `[includeIf]` section (`grep -n include git/.config/git/config` returns nothing), so a reader of this repo cannot see what loads config.local. Confirm with `git config --show-origin --list` before relying on it. Use `git config --local` inside this repository (`AGENTS.md:18`).

### `core.hooksPath = .githooks` points at a directory this repo lacks

`git/.config/git/config:17` sets a relative hooks path, resolved per repository. This repository has no `.githooks` directory, so Git runs no hooks here; `ls .githooks` fails. Adding a directory with that name in this repo activates every hook in it.

### TLS verification is disabled in git and curl

`sslVerify = false` under `[http]` and `[https]` (`git/.config/git/config:55`, `git/.config/git/config:58`) and `insecure` in `curl/.curlrc:10` apply to every remote and every plain `curl` run. Treat them as intentional defaults until a security file says otherwise. The credential helper stores credentials in a plaintext file (`git/.config/git/config:10`). Details belong in the separate security findings, not here.

### `htop` rewrites its own config

`htop/.config/htop/htoprc:1` warns that htop rewrites the file when settings change in its UI. Changing a meter or a column in htop shows up as a repo diff.

### `vim/.vimrc` selects bash when zsh exists

`if !executable(zsh) | set shell=zsh | else | set shell=/bin/bash` (`vim/.vimrc:56-60`). The condition is inverted relative to its apparent purpose, so Vim uses bash on machines that have zsh and zsh on machines that do not. No source gives a reason. Unexplained.

### `tmux` copy mode pipes to `xclip`, which is not installed

`bind-key -T copy-mode-vi y ... "xclip -selection clipboard -in"` (`tmux/.config/tmux/tmux.conf:43`). `xclip` is not in the Brewfile, so `y` copies nothing on macOS unless it is installed another way. `status-interval` is set to 1 at `tmux/.config/tmux/tmux.conf:47` and again to 2 at `tmux/.config/tmux/tmux.conf:69`; the later value applies.

### `bin/.local/bin/Makefile` has targets that cannot run

`.DEFAULT_GOAL := help` with no `help` target (`bin/.local/bin/Makefile:6`), `go-install : $(GO_PROGS)` where `GO_PROGS` is never defined (`bin/.local/bin/Makefile:126`), and `.DEFAULT_SHELL`, which is not a GNU make variable (`bin/.local/bin/Makefile:3`). A bare `make` in that directory fails.

### `installer` uses `$$PWD`, a Makefile escape, inside a zsh script

the test on `$$PWD` for the autogen script (`bin/.local/bin/installer:57`) expands to the shell PID followed by `PWD` in zsh, so the autogen.sh branch never finds its file. Configure failures log and the script continues to `sudo make install`.

### `remove-releases` quotes the tag list as a single word

`for tag in "$tags"` (`bin/.local/bin/remove-releases:15`) iterates once with every tag joined. A repository with more than one tag gets one malformed delete call. The script deletes tags and releases on `origin`, so run it only when you accept that.

## Where to look

- `Makefile:58-79`, `Brewfile:10-41`, `install.zsh:37-38`, `install.zsh:152-166`: the commented workarounds above.
- `AGENTS.md:29-35`: the maintainers' own gotchas list, which this page extends.
- `zsh/.config/zsh/functions/AGENTS.md:13`: the functions.zwc rule.
- [Bootstrap](../areas/bootstrap.md) and [Function tooling](../components/zsh/function-tooling.md): the surrounding mechanisms.
