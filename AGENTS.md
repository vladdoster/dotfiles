# Dotfiles

GNU Stow packages. Each top-level dir mirrors `$HOME` (`zsh/.config/zsh` becomes `~/.config/zsh`).

## Commands

- `make install`: restow each package alone. Conflict skips that package only.
- `make help`: list targets. `make update-readme`: regenerate README table.
- `make brew-bundle`: sync Brewfile. Uses `--force-cleanup --zap`: removes unlisted packages.
- `make docker-build` / `make docker-shell`: test dotfiles in container.

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
