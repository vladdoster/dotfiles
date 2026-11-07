---
id: areas/cli-tools
level: 1
title: CLI Tool Configuration and Scripts
parent: START-HERE
owns:
  - git/.config/git/commit-template
  - git/.config/git/config
  - git/.config/git/ignore
  - vim/.vimrc
  - python/.config/python/**
  - pip/.config/pip/pip.conf
  - curl/.curlrc
  - ripgrep/.config/ripgrep/config
  - ranger/.config/ranger/rc.conf
  - htop/.config/htop/htoprc
  - topgrade/.config/topgrade.toml
  - bash/.bashrc
  - bin/.local/bin/colors-demo.zsh
  - bin/.local/bin/execute-and-wait.zsh
  - bin/.local/bin/get-gh-release
  - bin/.local/bin/installer
  - bin/.local/bin/Makefile
  - bin/.local/bin/remove-releases
  - bin/.local/bin/rm-git-tags
  - bin/.local/bin/squash-all-commits
  - bin/.local/bin/update-license-headers
triggers:
  - add or change a git alias
  - change the commit message template
  - add a global gitignore pattern
  - change vim plugins or options
  - add a script to ~/.local/bin
  - change curl, pip, or ripgrep defaults
entry_points:
  - git/.config/git/config
  - vim/.vimrc
  - bin/.local/bin/Makefile
  - zsh/.config/zsh/rc.d/00-env.zsh:19
related:
  - areas/zsh
  - areas/bootstrap
  - areas/desktop
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---

**Related:** [Zsh](zsh.md) · [Bootstrap](bootstrap.md) · [Desktop](desktop.md)

Each package here holds the config file of one command-line program (git, vim, curl, pip, ripgrep, ranger, htop, topgrade, bash, the Python REPL) or, for `bin`, a set of standalone scripts and a Makefile that builds programs from source. GNU Stow links the files into `$HOME`. The zsh environment file exports variables that point some programs at these files.

## How it works

`make install` computes `PACKAGES` as every top-level directory (`Makefile:12`) and runs `stow --target=$HOME --verbose=1 --restow <pkg>` for each one separately, so a conflict in one package skips only that package (`Makefile:13`, `Makefile:41`). A file at `<pkg>/<path>` appears at `$HOME/<path>`:

| Repo path | Installed at |
|---|---|
| `git/.config/git/{config,ignore,commit-template}` | `~/.config/git/` |
| `vim/.vimrc` | `~/.vimrc` |
| `curl/.curlrc` | `~/.curlrc` |
| `bash/.bashrc` | `~/.bashrc` |
| `pip/.config/pip/pip.conf` | `~/.config/pip/pip.conf` |
| `ripgrep/.config/ripgrep/config` | `~/.config/ripgrep/config` |
| `python/.config/python/init-repl.py` | `~/.config/python/init-repl.py` |
| `ranger/.config/ranger/rc.conf` | `~/.config/ranger/rc.conf` |
| `htop/.config/htop/htoprc` | `~/.config/htop/htoprc` |
| `topgrade/.config/topgrade.toml` | `~/.config/topgrade.toml` |
| `bin/.local/bin/*` | `~/.local/bin/*` |

`~/.local/bin` is on `PATH` through the `.zprofile` path list (`zsh/.config/zsh/.zprofile:34`). Stow ignore rules for `.local` live in the `stow` package: `stow/.stow-global-ignore:10` lists `\.local/bin/python` and `\.local/share` (`stow/.stow-global-ignore:11`). Commit `c3c23c3` is titled "ignore `.local/` dirs other than `bin/`". The repo-root `.stow-local-ignore:7` also lists `\.local`; whether Stow reads a `.stow-local-ignore` at the repo root, rather than inside a package, was not determined from the code.

Variables that connect programs to these files are set in `zsh/.config/zsh/rc.d/00-env.zsh`:

- `GIT_CONFIG="${XDG_CONFIG_HOME}/git/config"` (`:19`). `install.zsh` unsets it before cloning, because it points at the tracked file (`install.zsh:152-155`), and `Makefile:64` unsets it before the Homebrew installer.
- `RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"` (`:31`).
- `PIP_CONFIG="${XDG_CONFIG_HOME}/pip"` (`:19`), plus `PIP_TRUSTED_HOST`, `PIP_UPGRADE` and `PIP_NO_CACHE_DIR` (`:34-36`). Whether pip reads `PIP_CONFIG` was not determined from the code.
- `EDITOR` and `VISUAL` resolve to `nvim`, then `vim`, then `vi` (`:24-25`).

Nothing in the repo sets `PYTHONSTARTUP` or `CURL_HOME`. `~/.curlrc` is found at its default location, and the REPL script runs only if the user exports `PYTHONSTARTUP` themselves.

## Git

`git/.config/git/config` is the global config. The groups below are in file order.

Identity and commit. `[user]` sets name, email, and a non-standard `username = vladdoster` key (`git/.config/git/config:3-6`). The `clgu` alias reads that key with `git config --get user.username` (`git/.config/git/config:88`). commit.template points at `~/.config/git/commit-template` (`git/.config/git/config:7-8`). `credential.helper = store --file ~/.config/git/credentials` keeps credentials in a plaintext file next to the config (`git/.config/git/config:10`).

Core. `core.editor = nvim`, `core.pager = delta`, `core.excludesfile = ~/.config/git/ignore`, `autocrlf = false`, `eol = lf` (`git/.config/git/config:11-16`). `core.hooksPath = .githooks` (`git/.config/git/config:17`) is a relative path, resolved per repository. This repo has no `.githooks` directory, so in this repo the setting points at nothing.

Pager and diff. interactive.diffFilter runs `delta --color-only --features=interactive` and `add.interactive.useBuiltin = false` selects the Perl `add -i` so that filter applies (`git/.config/git/config:35-38`). The `[delta]` block turns on line numbers and decorations and sets `navigate = true` (`git/.config/git/config:62-74`). `diff.colorMoved = default` and `merge.conflictstyle = diff3` follow (`git/.config/git/config:39-42`).

Workflow defaults. `pull.rebase = true`, `rebase.autoStash = true`, `push.default = current`, `push.followTags = true`, and `rerere` enabled with `autoupdate` (`git/.config/git/config:43-52`). The `[advice]` block silences hints; `detachedHead` appears twice (`git/.config/git/config:21-22`).

Network and fsck. `http` and `https` both set `postBuffer = 524288000` and `sslVerify = false` (`git/.config/git/config:53-58`), which disables TLS certificate checks for every HTTPS remote. The three `zeroPaddedFilemode = ignore` entries for `fsck`, fetch.fsck and receive.fsck relax object checks (`git/.config/git/config:121-126`). `[homebrew]` and `[zinit] remote = upstream` hold settings read by those tools, not by git (`git/.config/git/config:59-61`, `git/.config/git/config:127-128`).

Aliases (`git/.config/git/config:75-120`) fall into short forms of common commands (`s`, `d`, `ds`, `co`, `cob`, `pl`, `ps`, `psf`), commit variants, stash variants, submodule helpers (`sub-add`, `sub-rm`, `sub-up`) and a few shell aliases that use `!sh -c`. Two are worth knowing before use:

- `c = commit --signoff` (`git/.config/git/config:81`) adds the sign-off the repo's `AGENTS.md` requires. `cm` does not.
- `nuke` runs `git reset --hard && git clean -fxd`, which also deletes ignored files (`git/.config/git/config:94`).

`commit-template` is shown in the editor for `git commit` without `-m`. It is all comment lines (`#`), so it carries no default text. It states the Angular Conventional Commits format `<type>(<scope>): <description>`, lists the ten types `build, ci, docs, feat, fix, perf, refactor, revert, style, test` (`git/.config/git/commit-template:16`), and the format rules: imperative mood, lowercase summary, no trailing dot, bullets that start with `- `, and no tool-generated disclaimer (`git/.config/git/commit-template:34-40`). Nothing enforces it; no hook or CI step in this area reads it.

`git/.config/git/ignore` is the global excludes file. Sections cover Linux temp files, zsh artifacts (`*.zwc*`, `zcompdump`, `bin/.local/share`, `bin/.local/man`, `bin/.local/bin/zsh` at `git/.config/git/ignore:16-26`), macOS metadata, Vim swap/undo/session files, virtualenv marker files, and `**/.claude/settings.local.json` (`git/.config/git/ignore:85`). The header and the virtualenv comment record two rules the file follows: a `#` only starts a comment in column 1 (`git/.config/git/ignore:1-2`), and generic names such as `bin` or `lib` are not listed because a global file would match them in every repository (`git/.config/git/ignore:73-76`).

### Machine-specific git settings

`AGENTS.md:31-32` says `git config --global` writes through the Stow symlink into the tracked file, and that machine settings belong in ~/.config/git/config.local. The tracked `git/.config/git/config` has no `[include]` or `[includeIf]` section, and no file in the repo other than `AGENTS.md` mentions config.local. Whether git loads ~/.config/git/config.local is therefore not determined from the code: a reader of this repo cannot see the include that would make it take effect. Check `git config --show-origin --list` before relying on it. The exported `GIT_CONFIG` variable affects `git config` invocations that read or write a file without `--global` or `--local`, which is why `install.zsh` unsets it first.

## Vim

`vim/.vimrc` is a single file in four commented sections: Plugins, Options, Visual Settings, Abbreviations plus plugin settings (`vim/.vimrc:1-150`).

Plugin bootstrap. If `~/.vim/autoload/plug.vim` is missing, the file downloads it with `curl -fLo ... --create-dirs` from the `junegunn/vim-plug` master branch, sets `g:not_finish_vimplug`, and registers an `autocmd VimEnter * PlugInstall` (`vim/.vimrc:4-16`). If `curl` is absent it prints an error and quits (`vim/.vimrc:7-10`). Plugins install under `~/.vim/plugged`: NERDTree, vim-commentary, vim-fugitive, vim-sensible, vim-gitgutter, grep.vim, indentLine, delimitMate, vim-bootstrap-updater and the `codedark` colour scheme (`vim/.vimrc:18-29`).

Guards. The fzf block adds `/opt/homebrew/opt/fzf` to `runtimepath` when `fzf` is not executable (`vim/.vimrc:32-35`), which matches its purpose. One condition is reversed: the shell block sets `shell=zsh` when `zsh` is not executable and `shell=/bin/bash` when it is (`vim/.vimrc:55-60`), so Vim uses bash on machines that have zsh.

Options. Two-space indent via `shiftwidth=2` and `expandtab`, `tabstop=4`, `ignorecase` with `smartcase`, `hlsearch`, `incsearch`, `hidden`, `autoread` (`vim/.vimrc:39-54`, `vim/.vimrc:150`). Leader is `,` (`vim/.vimrc:39`). `n` and `N` recentre the screen (`vim/.vimrc:90-91`). A custom statusline shows path, file format, filetype, line and column, plus the fugitive status when that plugin is loaded (`vim/.vimrc:87`, `vim/.vimrc:92-94`).

Mappings and commands. `<C-n>` toggles NERDTree (`vim/.vimrc:118`), `<leader>f` runs `:Rgrep` (`vim/.vimrc:120`), `<leader>sh` opens a terminal (`vim/.vimrc:125`), and `:FixWhitespace` strips trailing whitespace (`vim/.vimrc:127`). `cnoreabbrev` entries correct capitalised `:W`, `:Q`, `:Wq`, `:WQ` (`vim/.vimrc:99-108`).

Autocommands. Syntax sync is set to 3000 lines on every `BufEnter` (`vim/.vimrc:136-139`), the cursor returns to its last position on read (`vim/.vimrc:141-144`), and `*.txt` buffers get wrapping at `textwidth=79` through `s:setupWrapping` (`vim/.vimrc:128-134`, `vim/.vimrc:146-149`).

The neovim config is a separate package installed by the `neovim` Makefile target to `~/.config/nvim` (`Makefile:8`, `Makefile:48`), and is outside this doc.

## Small program configs

- `curl/.curlrc`: follows redirects (`location`), shows a progress bar and errors, sets `connect-timeout = 30`, `max-time = 90`, `referer = ";auto"`, and `insecure` (`curl/.curlrc:4-10`). `insecure` disables TLS verification for every plain `curl` run by this user, including inside scripts.
- `ripgrep/.config/ripgrep/config`: one setting, `--engine=auto`, which uses the default engine and falls back to PCRE2 when a pattern needs it (`ripgrep/.config/ripgrep/config:1-2`). It takes effect through `RIPGREP_CONFIG_PATH`.
- `pip/.config/pip/pip.conf`: `download_cache = ~/.cache/pip`, `no-warn-script-location`, `timeout = 15`, and `list` output as columns (`pip/.config/pip/pip.conf:1-7`). The environment file also sets `PIP_NO_CACHE_DIR=true`, so the two cache settings point in different directions.
- `ranger/.config/ranger/rc.conf`: image previews via the `kitty` protocol (`ranger/.config/ranger/rc.conf:1-2`).
- `htop/.config/htop/htoprc`: htop rewrites this file when settings change in its UI (`htop/.config/htop/htoprc:1-2`), so edits made in htop show up as repo diffs. It records `htop_version=3.2.1`, tree view on, colour scheme 5, a 1.5 second refresh (`delay=15`, in tenths of a second), and meters in two columns (`htop/.config/htop/htoprc:4`, `:28-36`).
- `topgrade/.config/topgrade.toml`: runs non-interactively (`assume_yes`, `no_retry`, `cleanup`), updates every git repo matching `~/code/*` with concurrency 10, enables composer self-update and greedy Homebrew casks (`topgrade/.config/topgrade.toml:1-16`).
- `bash/.bashrc`: sets a coloured `PS1` with user, host, time, working directory, current branch via `parse_git_branch`, and a stash count via `git_stashes_count` (`bash/.bashrc:3-20`). `RED` is assigned twice, and the second value wins (`bash/.bashrc:15`, `bash/.bashrc:17`). It is a fallback shell setup; the primary shell is zsh.

## Python REPL startup

`python/.config/python/init-repl.py` is a startup script for the interactive interpreter. It is not loaded unless `PYTHONSTARTUP` points at it (docstring at `python/.config/python/init-repl.py:4-7`). It does, in order:

1. Builds a `TermColors` dict of ANSI codes, empty for `TERM` values outside a fixed list (`python/.config/python/init-repl.py:29-74`).
2. Reads and writes `~/.pyhistory` with a 1000-line limit and tab completion (`python/.config/python/init-repl.py:79-94`).
3. Sets a coloured `❯❯❯` prompt and a `pprint`-based sys.displayhook (`python/.config/python/init-repl.py:99-118`).
4. Defines `SECRET_KEY()` and, when `DJANGO_SETTINGS_MODULE` is set, imports the Django test client and models and enables `DEBUG_PROPAGATE_EXCEPTIONS` (`python/.config/python/init-repl.py:148-199`). The import django.db.models.loading (`python/.config/python/init-repl.py:164`) does not exist in current Django releases; that was not tested here.
5. Sets up Salt clients when `SALT_CLIENT_CONFIG` or `SALT_MINION_CONFIG` is set (`python/.config/python/init-repl.py:204-244`).
6. Starts `EditableBufferInteractiveConsole`, where typing `\e` opens the last statement in `$EDITOR` (`python/.config/python/init-repl.py:250-281`), then calls `sys.exit()` when the console closes (`python/.config/python/init-repl.py:284`).

`python/.config/pycodestyle` is tracked in the same package but is not owned by this doc's plan entry.

## Scripts in bin/.local/bin

Scripts are linked into `~/.local/bin`. Only the files with a shebang have the executable bit; `Makefile` does not.

### Make-driven source builds

`bin/.local/bin/Makefile` builds programs from release tarballs. `PROGS` lists about 60 names (`bin/.local/bin/Makefile:14-30`) and each has a `<name>: URL:=` target-specific variable pointing at a GNU mirror, a GitHub API path, or a fixed tarball (`bin/.local/bin/Makefile:39-120`). The shared rule `$(PROGS):` computes a download URL, using GNU directory listings fetched with `curl` for names without a fixed URL, and then runs `installer <name> <url>` through zsh (`bin/.local/bin/Makefile:129-131`). `install` depends on all of `PROGS` (`bin/.local/bin/Makefile:125`). `py-install` runs `python3 -m pip install --trusted-host ...` for each name in `PY_PROGS` (`bin/.local/bin/Makefile:127`, `bin/.local/bin/Makefile:133-134`). The `zwc` target compiles each `*.zsh` in the directory to `.zwc` (`bin/.local/bin/Makefile:8-9`).

Defects visible in the file:

- `.DEFAULT_GOAL := help` (`bin/.local/bin/Makefile:6`), but no `help` target exists, so a bare `make` fails.
- `go-install` depends on `$(GO_PROGS)`, which is never defined (`bin/.local/bin/Makefile:126`).
- `node:` points at a v15.17.6 directory with a v14.17.6 file name (`bin/.local/bin/Makefile:89`).
- Several URLs pin old tarballs, for example libressl-2.3.4 and openssh-7.8p1 (`bin/.local/bin/Makefile:73`, `bin/.local/bin/Makefile:94`).
- `.DEFAULT_SHELL` is not a GNU make variable, so the `ZSH` assignment on line 3 has no effect on recipe shells.

`installer` takes `<name> <url> [configure options]` (`bin/.local/bin/installer:10-13`). It creates a temp dir, downloads with `curl -Lk` or `wget` (`bin/.local/bin/installer:30-36`), unpacks with `tar --strip-components 1` (`bin/.local/bin/installer:42`), tries `autoupdate`/`autoconf`/`autoreconf`/`cmake` when no `Makefile` exists (`bin/.local/bin/installer:49-66`), runs `configure`, then `sudo make --jobs 8 install` (`bin/.local/bin/installer:76`). An `EXIT` trap runs `sudo rm -rf "$WORK_DIR"` (`bin/.local/bin/installer:23-28`). `$$PWD` on lines 57 and 68 expands to the shell PID followed by `PWD` in zsh, so the autogen.sh branch and the first `configure` attempt cannot find their files; the script then tries `sh $PWD/Configure` (`bin/.local/bin/installer:70`). Failures in the configure steps only log and do not exit, so the script continues to `make install`.

### Release and tag helpers

- `get-gh-release <user/repo>` lists the assets of the latest GitHub release with `curl` and `jq`, lets the user pick one with `select`, downloads it with `wget` to `/tmp/.github-install`, extracts it with an inline `extract` function, asks for a binary and an alias, and moves it into `~/.local/bin` (`bin/.local/bin/get-gh-release:6-58`). The `*.tar.xz` case runs `tar xzf` (`bin/.local/bin/get-gh-release:27`).
- `remove-releases` deletes every tag on `origin` and locally, then every GitHub release through `gh` (`bin/.local/bin/remove-releases:3-36`). Its loops quote the variable (`for tag in "$tags"`), so a repository with several tags runs one iteration with all names joined (`bin/.local/bin/remove-releases:15`, `bin/.local/bin/remove-releases:32`).
- `rm-git-tags` deletes local tags, fetches, deletes remote tags, then deletes local tags again (`bin/.local/bin/rm-git-tags:4-7`); its inline comments on lines 4 and 5 are swapped relative to the commands.
- `squash-all-commits` removes all tags locally and on `origin`, creates an orphan branch `develop`, commits everything as `(init): creating <repo> repository`, force-moves `master` to it and deletes `develop` (`bin/.local/bin/squash-all-commits:3-20`). It does not push, but it does delete remote tags. It assumes the default branch is named `master`.
- `update-license-headers` inserts a GPL header, built from the `license` template and the `author`, `year`, `project_name` variables, at line offset 2 of each `*.zsh` file given on the command line (`bin/.local/bin/update-license-headers:20-47`, `bin/.local/bin/update-license-headers:68-89`). With no arguments it runs `find "${cwd}"-name`, which has no space before `-name` and so finds nothing useful (`bin/.local/bin/update-license-headers:96-97`). The file keeps an Apache 2.0 notice for its own origin (`bin/.local/bin/update-license-headers:3-15`).

### Terminal utilities

- execute-and-wait.zsh runs a command (`$1`) in the background with output to `/tmp/execute-and-wait.log`, animates a braille spinner with title `$2` until the process exits, prints `+` or `X`, and returns the exit status (`bin/.local/bin/execute-and-wait.zsh:18-61`). It uses `local` and `return` at top level, so it is written to be sourced or called inside a function. `${YELLOW}`, `${GREEN}` and `${NC}` must already be set by the caller (`bin/.local/bin/execute-and-wait.zsh:36`). Which scripts call it was not determined from the code.
- colors-demo.zsh prints every background, foreground and attribute combination of ANSI SGR codes (`bin/.local/bin/colors-demo.zsh:8-18`).

## Where to look

- `git/.config/git/config`: aliases, pager, TLS and workflow defaults.
- `zsh/.config/zsh/rc.d/00-env.zsh`: variables that point programs at these files.
- `vim/.vimrc`: plugin bootstrap and editor options.
- `bin/.local/bin/Makefile` and `bin/.local/bin/installer`: source-build pipeline.
- `Makefile:12-41`: how Stow links each package.
