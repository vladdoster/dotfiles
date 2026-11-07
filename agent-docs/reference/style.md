---
id: reference/style
title: Code style
parent: START-HERE
owns:
  - editor/.editorconfig
  - luaformatter/.config/luaformatter/config.yaml
  - python/.config/pycodestyle
triggers:
  - fix a lint failure in CI
  - write a commit message that passes commitlint
  - format a shell or Lua file
  - reformat a markdown file for mdformat
  - decide indentation for a new config file
entry_points:
  - .github/workflows/standards.yml
  - editor/.editorconfig
  - git/.config/git/commit-template
  - zsh/.config/zsh/functions/AGENTS.md
related:
  - reference/gotchas
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
commands:
  lint: []
  format: []
  typecheck: []
  test:
    - zsh .github/tests/install.zsh
---

**Related:** [Gotchas](gotchas.md)

Style rules for shell, Make, Lua, Python and markdown files, and for commit messages in this dotfiles repository. CI checks a subset: the `Standards` workflow calls two shared workflows in `vladdoster/.github` that lint markdown, `*.sh`, `*.zsh` and commit messages. Most other rules come from `AGENTS.md`, directory-level `AGENTS.md` files and the habit of the existing files. No company style source is configured, so there is no vendored section.

## Commands

No lint, format or type-check command exists in the repository. The `Makefile` has no lint or format target (`Makefile:36-73` lists the `## ` targets; none lint). commands.lint is `[]` for that reason. CI runs the checks below inside the `ghcr.io/vladdoster/lint` image, which this repository does not contain; to run one locally, install the tool and use the same arguments.

The CI invocations, copied from the shared lint workflow read from `vladdoster/.github` at `master` (commit not recorded):

| Check | Command CI runs |
|---|---|
| Markdown | `mdformat --check --wrap 120` on every `./**/*.md` except `CHANGELOG.md` |
| Shell format | `shfmt -bn -ci -d -i 2 -ln bash -s -sr` on every `./**/*.sh` |
| Shell logic | `shellcheck` on every `./**/*.sh` |
| Zsh syntax | `zsh -n` on every `./**/*.zsh` |
| Zsh compile | `zcompile /tmp/zwc` on every `./**/*.zsh` |
| Commit messages | `commitlint --verbose` on the PR commit range, the pushed range, or `--last` |

The only style-adjacent test is `zsh .github/tests/install.zsh` (`AGENTS.md:10-12`), which checks `install.zsh`, `Makefile` and `Brewfile` behaviour, not formatting. `.github/tests/e2e.zsh` deletes Homebrew; do not run it locally (`AGENTS.md:11-12`).

## Enforced rules

Enforced. Markdown is wrapped at 120 columns and formatted by `mdformat`; `CHANGELOG.md` is skipped. Evidence: the shared lint workflow markdown step above.

Enforced. `*.sh` files must pass `shfmt -bn -ci -d -i 2 -ln bash -s -sr` and `shellcheck`: two-space indent, bash dialect, simplified code, binary operators at the start of the next line, indented `case` bodies, spaces before redirects. Evidence: the shared lint workflow shell steps. The tracked `.sh` file is `docker/init-buildx.sh`.

Enforced. `*.zsh` files must parse (`zsh -n`) and compile (`zcompile`). Evidence: the shared lint workflow zsh steps. The glob matches the `.zsh` extension only. Functions in `zsh/.config/zsh/functions/` and completions in `completions/` have no extension and are not checked by CI.

Enforced. Commits follow Angular Conventional Commits, checked by `commitlint` through the shared commit workflow. Evidence: `.github/workflows/standards.yml:13-15`, `.github/workflows/release.yml:7-9`. The commitlint rule set is in the `ghcr.io/vladdoster/commitlint` image and was not determined; the type list below comes from the commit template.

Team (configured, not run by CI). `editor/.editorconfig` sets UTF-8, LF line endings, a final newline and space indentation for all files, tab indentation for `Makefile`, and two-space indentation for `*.sh` (`editor/.editorconfig:1-12`). Nothing in CI reads `.editorconfig`. The file also carries shfmt keys (`shell_variant = posix`, `binary_next_line`, `switch_case_indent`, `space_redirects`, `keep_padding`, `function_next_line`, `never_split`; `editor/.editorconfig:14-20`) and an `ignore = true` stanza for `third_party/**` (`editor/.editorconfig:22-23`). These differ from the CI shfmt flags: CI uses `-ln bash`, the editorconfig `posix`, and CI does not pass `-kp -fn -ns`.

Team (configured, not run by CI). `luaformatter/.config/luaformatter/config.yaml` sets two-space indent, a 100-column limit, no tabs, quotes left as written, and `chop_down_kv_table: true` (`luaformatter/.config/luaformatter/config.yaml:14-26`). No CI step or Makefile target runs a Lua formatter, and no wrapper in the repository references this file. Treat it as the editor-side formatter setting for `wezterm/.config/wezterm/*.lua`.

Team (configured, not run by CI). `python/.config/pycodestyle` sets `max-line-length = 160` and ignores `E226`, `E302`, `E41` (`python/.config/pycodestyle:3-4`). No CI step runs pycodestyle. Python files are `python/.config/python/init-repl.py` and `.github/tests/terminal.py`.

## Team rules

Team. Commit author and committer are the newest author named Vlad or Vladislav, found with the `git log ... | grep -i -m1 '^vlad'` command; fall back to `Vladislav Doster <mvdoster@gmail.com>`. Set with `git config --local`. Evidence: `AGENTS.md:16-18`.

Team. Sign off every commit with `git commit -s` as that identity. No other trailers: no `Co-Authored-By`, no session links. Evidence: `AGENTS.md:19`.

Team. Commits, PR titles, PR bodies and PR comments never name the tool or model that wrote them; delete any footer a tool appends. Evidence: `AGENTS.md:20-21`, `git/.config/git/commit-template:39`.

Team. Commit subjects use `<type>(<scope>): <description>` with a type from `build`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`; the scope is optional and names the area (`zsh`, `make`, `brew`, `git`). Use the imperative present tense, a lowercase first letter, and no trailing period. A multiline body is a list of `- ` bullets; post-review fixes use that form with a first bullet starting with the summary. Evidence: `git/.config/git/commit-template:4-40`. Recent history follows it, for example `fix(install): resume over an existing clone` and `perf(sys-report): run slow probes concurrently`.

Team. Machine-specific git settings go in `~/.config/git/config.local`, because `git config --global` writes through the stow symlink into tracked files. Evidence: `AGENTS.md` Gotchas section.

Team. Every function in `zsh/.config/zsh/functions/` has a completion file in `completions/` named `_<function-name>`, committed in the same commit as the function. Evidence: `zsh/.config/zsh/functions/AGENTS.md:3-8`. Internal helpers are exempt and are listed in that file; the one named is `wezterm::_pane` (`zsh/.config/zsh/functions/AGENTS.md:12`).

Team. Completions begin with `#compdef <function-name>`, cover every option the function parses with `zparseopts`, and offer only `-h` and `--help` for a no-argument function. `_sys-report` and `_mkrepeat` are the templates. Evidence: `zsh/.config/zsh/functions/AGENTS.md:5-11`.

Team. Rebuild the compiled-function digest after adding or deleting a function. Evidence: `zsh/.config/zsh/functions/AGENTS.md:13`. `*.zwc` is gitignored (`.gitignore:11`).

Team. Completion function rules: run `_arguments -C` unconditionally, use `-C` on nested `_arguments`, read the subcommand from `line[1]` not `$words[2]`, cache expensive lookups with `_store_cache` and a caching policy, and redirect external command stderr to `/dev/null`. Evidence: `zsh/.config/zsh/completions/AGENTS.md:209-218`, `427-432`.

## Naming and layout

Established. Zsh function files have no extension, are named for the function, and use `::` as a namespace separator for grouped functions (`docker::shell`, `dotfiles::make`, `edit::file`, `log::error`, `wezterm::send-pane`). Examples: `zsh/.config/zsh/functions/docker::shell`, `zsh/.config/zsh/functions/log::error`, `zsh/.config/zsh/functions/wezterm::send-pane`. Other functions use a flat hyphenated name (`sys-report`, `check-for-updates`) or a short name (`c`, `h`, `r`, `v`).


Established. Every function file carries the modeline `# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:` on line 2, and every completion file carries it last, 66 of 66 each. Examples: `zsh/.config/zsh/functions/has`, `zsh/.config/zsh/functions/log::error`, `zsh/.config/zsh/completions/_has`, `zsh/.config/zsh/completions/_sys-report`. Other files use modelines for their own filetype with different settings (`Makefile:140`, `bash/.bashrc:22`, `vim/.vimrc:204`), so no single modeline applies repository-wide.


Established. `rc.d/` startup files are named `NN-<topic>.zsh` and load in numeric order. Examples: `zsh/.config/zsh/rc.d/00-env.zsh` through the prompt file; `AGENTS.md` lists the order.

Established. Makefile targets carry a `## ` comment that `make help` prints. Examples: `Makefile:36`, `Makefile:40`, `Makefile:73`. The Makefile sets `SHELL := $(ZSH) -o pipefail` (`Makefile:5`), so recipes may use zsh syntax. Indent recipes with tabs (`editor/.editorconfig:6-7`).

## Imports and boundaries

Team. Each top-level directory is a stow package that mirrors `$HOME`; a file's path inside a package is its install path (`AGENTS.md`, first line). Put new configuration under the package for the tool, not at the repository root.

## Errors, logging and configuration

Established. Functions start with `emulate -L zsh` so options set inside do not leak to the caller. 66 of 66 function files contain it. Examples: `zsh/.config/zsh/functions/has`, `zsh/.config/zsh/functions/sys-report`, `zsh/.config/zsh/functions/log::error`. `log::error` uses `builtin emulate -L zsh -o EXTENDED_GLOB`.

Established. Functions print with `print -r --` and send errors to stderr. Examples: `zsh/.config/zsh/functions/log::error:15` (`print -r -- ... >&2`), `zsh/.config/zsh/functions/sys-report:25` (`print -u2 -r --`), `zsh/.config/zsh/functions/has`. Use `log::error` and `log::info` for user-visible messages where a function needs the shared prefix.

Team. Machine-local configuration is kept in untracked files: `zsh/.config/zsh/local/` is untracked (`AGENTS.md`), and git uses `~/.config/git/config.local`.

## Tests

Team. The repository keeps one regression suite, `.github/tests/install.zsh`, plus `.github/tests/e2e.zsh` and a helper `.github/tests/terminal.py`. The suite uses `emulate -L zsh`, `setopt extended_glob pipe_fail`, a temporary working directory removed in a `trap ... EXIT`, stand-ins for `sudo` and `curl`, and `ok`/`bad` counters (`.github/tests/install.zsh:5-23`). It isolates git with `GIT_CONFIG_GLOBAL=/dev/null` (`.github/tests/install.zsh:15-16`). Add new regression checks in this file when a change touches `install.zsh`, `Makefile` or `Brewfile`. There are no tests for zsh functions or completions.

## Exceptions

- `CHANGELOG.md` is excluded from markdown linting and is written by the shared release workflow in `ci: vX -> vY` commits.
- `help-zshglob` has no `#autoload` first line (`zsh/.config/zsh/functions/help-zshglob:1`).
- `docker/init-buildx.sh` carries a Kubernetes copyright header and uses `bash`, unlike the rest of the repository's zsh (`docker/init-buildx.sh:1-3`).
- CI shell checks cover `*.sh` and `*.zsh` only, so extensionless zsh functions and completions are never linted in CI.
