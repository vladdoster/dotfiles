# Dotfiles

GNU Stow packages. Each top-level dir mirrors `$HOME` (`zsh/.config/zsh` becomes `~/.config/zsh`).

## Commands

- `make install`: restow each package alone. Conflict skips that package only.
- `make help`: list targets. `make update-readme`: regenerate README table.
- `make brew-bundle`: sync Brewfile. Uses `--force-cleanup --zap`: removes unlisted packages.
- `make docker-build` / `make docker-shell`: test dotfiles in container.
- `zsh .github/tests/install.zsh`: regression checks for `install.zsh`, `Makefile`, and `Brewfile`. CI also runs
  `.github/tests/e2e.zsh`: the curl one-liner on a fresh account. It deletes Homebrew; never run it locally.

## Commits and PRs

- Author and committer: name and email of the newest author named Vlad or Vladislav:
  `git log --no-merges --format='%an <%ae>' | grep -i -m1 '^vlad'`. None found: `Vladislav Doster <mvdoster@gmail.com>`.
  Set with `git config --local`.
- Sign off every commit (`git commit -s`) as that identity. No other trailers: no `Co-Authored-By` or session links.
- Commits, PR titles, PR bodies, and PR comments never name the tool or model that wrote them. Edit out any footer a
  tool appends to a PR body.

## Zsh layout (`zsh/.config/zsh`)

- `rc.d/NN-*.zsh`: load in numeric order (env, alias, widget, fzf, clipboard, zinit, completion, prompt, repeat).
- `functions/`: autoloaded, one file per function. Each function needs completion in `completions/`. Helpers exempt.
- `local/` untracked. `*.zwc` gitignored.

## Gotchas

- `git config --global` writes through stow symlink into tracked files. Machine settings go in
  `~/.config/git/config.local`.
- Rebuild `functions.zwc` after deleting a function. Stale digest keeps serving it.
- `zsh -f` sandbox needs `setopt extendedglob` before loading function files.
- `Makefile` sets `SHELL` to zsh. Recipes can use zsh syntax.

Read `zsh/.config/zsh/functions/AGENTS.md` before adding a function.

Project notes: `.serena/memories`. Serena MCP tools: use `read_memory`. Else read files directly.

<!-- agent-docs:start -->
## Documentation

Generated documentation lives in `agent-docs/`.

1. New to the repo? Read `agent-docs/START-HERE.md`; it explains the docs and the system.
2. Have a task? Use `rg -n -i -C 2 -g '*.md'` with task keywords across `agent-docs/`, then open the relevant section. Try related terms if matches are sparse; narrow the pattern or directory if output is large.
3. Have a file or directory? Use `rg` with its repo-relative path on `agent-docs/INDEX.md`; never read it in full.
4. Before changing code, read `agent-docs/reference/style.md` for repository-wide rules and checks.
5. `agent-docs/notes/` records team intent. Source citations describe current behaviour.
6. Verify from cited source anchors before widening the source scan. Check `agent-docs/ISSUES.md` for known gaps.
7. Ask route-changing questions before detailed reading. Return implementation plans as Markdown unless asked otherwise.

Docs may lag the code. `agent-docs/.state/state.json` records the commit each doc was
generated from.
<!-- agent-docs:end -->
