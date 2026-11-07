---
id: reference/glossary
title: Glossary
parent: START-HERE
owns: []
triggers:
  - look up what an rc.d stage or zinit ice means
  - check what autoload pairing or the helper exemption requires
  - "find out what :: or + in a function name signals"
  - look up what a package or section means in the install flow
entry_points:
  - AGENTS.md
  - zsh/.config/zsh/.zshrc:23
  - zsh/.config/zsh/functions/AGENTS.md
related:
  - areas/zsh
  - areas/bootstrap
  - components/zsh/startup
  - components/zsh/function-tooling
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---

**Related:** [Zsh](../areas/zsh.md) · [Bootstrap](../areas/bootstrap.md) · [Startup](../components/zsh/startup.md) · [Function tooling](../components/zsh/function-tooling.md)

Terms in this repository that mean something other than their usual sense, or that the repo coined. Ordinary shell and git vocabulary is left out.

## Packaging

**package.** A top-level directory that mirrors `$HOME` and is symlinked by GNU Stow, for example `zsh/.config/zsh` becomes `~/.config/zsh` (`AGENTS.md:3`). The Makefile builds its package list from every directory in the repo root, so any new top-level directory is stowed automatically, including `agent-docs` once it exists (`Makefile:12`). It does not mean a Homebrew formula or a zinit plugin; those are called formulae and plugins.

**restow.** `make install` runs `stow --restow` once per package, so a conflict skips that package and prints `==> skipped <pkg>` while the rest continue (`Makefile:39-41`). `make uninstall` is different: it passes all packages to one `stow --delete` (`Makefile:44`).

**stow ignore files.** `.stow-local-ignore` inside a package lists patterns Stow leaves unlinked; `zsh/.stow-local-ignore` excludes the generated `.zcompdump` (`zsh/.stow-local-ignore:1`). `stow/.stow-global-ignore` is a package whose only job is to be linked as Stow's global ignore list (`stow/.stow-global-ignore:1`).

**section.** One stage of `install.zsh`: `clone brew bundle stow shell extras`. `--only` selects sections; the default is the first four (`install.zsh:62-63`). Apart from the clone and preflight work, each section calls a Makefile target through `delegate`, so running a section matches running its target by hand (`install.zsh:12-14`, `install.zsh:41`). The `stow` section runs `make install` (`install.zsh:260-261`).

**delegate.** The `install.zsh` helper `delegate <label> <make-target>...` that runs targets from the clone's Makefile. The name is local to that script and is not an autoloaded function (`install.zsh:37-41`).

**`DOTFILES`.** The path of the checkout. The env stage finds it by walking up from the sourced file until a `.git` directory appears, falling back to `$XDG_CONFIG_HOME/dotfiles` (`zsh/.config/zsh/rc.d/00-env.zsh:12-16`). Functions such as `dotfiles::make` use it to run `make` there (`zsh/.config/zsh/functions/dotfiles::make:8`).

## Shell startup

**rc.d stage.** A file in the rc.d directory named NN-name, where `NN` is a number. `.zshrc` globs `rc.d/<->-*zsh` and sources the matches in numeric order, so the prefix is the load order (`zsh/.config/zsh/.zshrc:24-26`). Eight stages exist: env, alias, widget, fzf, clipboard, zinit, completion, prompt. The root `AGENTS.md` also lists `repeat` as a ninth stage (`AGENTS.md:25`); no such file exists at HEAD. A new stage needs a numeric prefix and a name ending in `zsh`, or the glob skips it.

**`NO_RC`.** When set to any non-empty value, `.zshrc` skips the whole rc.d loop and goes straight to `compinit` (`zsh/.config/zsh/.zshrc:23`, `zsh/.config/zsh/.zshrc:29-30`).

**`NO_ZINIT`.** When set to a non-empty value, the zinit stage unsets it, logs a message and returns, so later stages still load (`zsh/.config/zsh/rc.d/05-zinit.zsh:6-10`). `zsh::rld --no-zinit` sets it for you (`zsh/.config/zsh/functions/zsh::rld:33`, `zsh/.config/zsh/functions/zsh::rld:52`). Unlike `NO_RC`, it disables only plugin loading.

**zinit ice.** A modifier written before a plugin name in `zi` calls, such as `from'gh-r'`, `lbin'!'`, `atload"..."` or `ver'...'`. `id-as` gives the entry a fixed name. `@owner/repo` is shorthand for a GitHub repository. See `zsh/.config/zsh/rc.d/05-zinit.zsh:49-60` for the forms used here; these are zinit's terms, not the repo's, but they are the only plugin syntax in the tree.

**`zi if'(())'`.** An `if` ice whose condition is an empty arithmetic expression. It is used as a group-level switch and overridden per entry with `if'((1))'` (`zsh/.config/zsh/rc.d/05-zinit.zsh:91-92`). How the ice list distributes over later entries was not determined from the code; see [Startup](../components/zsh/startup.md).

## Functions and completions

**autoloaded function.** A file in `zsh/.config/zsh/functions/` that holds a bare function body with `#autoload` on its first line. `.zprofile` adds the directory to `fpath` and runs `autoload -Uz` on every file except `*.md` and `*.zwc` (`zsh/.config/zsh/.zprofile:39-40`). The file name is the function name, so there is no `name() {}` wrapper. This is the only place functions are autoloaded.

**autoload pairing.** The rule that every function has a completion at `completions/_<name>`, beginning `#compdef <name>`, added in the same commit and covering each option parsed with `zparseopts` (`zsh/.config/zsh/functions/AGENTS.md:3-9`). A function with no arguments completes only `-h` and `--help` (`zsh/.config/zsh/functions/AGENTS.md:11`). `mkfn` creates the function file but not the completion, so the author adds it (`zsh/.config/zsh/functions/mkfn:43-67`). Three no-argument completions call `_message 'no arguments'` instead (`zsh/.config/zsh/completions/_rld::file:3`).

**helper exemption.** Internal helpers do not need a completion. The helpers are listed by name in `zsh/.config/zsh/functions/AGENTS.md`, and only `wezterm::_pane` is named (`zsh/.config/zsh/functions/AGENTS.md:12`). A new helper must be added to that list; being underscore-prefixed does not exempt it by itself.

**`::` function naming.** A `::` in a function name separates a namespace from a command: `log::info`, `edit::function`, `zsh::rld`, `wezterm::_pane`, `docker::shell`. Each is still one file whose name contains the colons. `::` carries no syntax meaning to zsh here. No document in the repo defines the convention, so whether it is a rule beyond grouping by prefix was not determined from the code.

**`+` prefix.** `+brew-link-keg` is the one function whose name begins with `+` (`zsh/.config/zsh/functions/+brew-link-keg:1`). The meaning of the prefix is not determined from the code.

**`_` prefix (alias helpers).** Helper functions in the alias stage (`_edit`, `_goto`) are prefixed `_` (`zsh/.config/zsh/rc.d/01-alias.zsh:17`, `zsh/.config/zsh/rc.d/01-alias.zsh:31`). A `_` prefix in `completions/` instead means a completion file, which is a different convention.

**repeat function.** A function made by `mkrepeat NAME COMMAND...` that runs the command and then pushes `NAME ` onto the next prompt with `print -z` (`zsh/.config/zsh/functions/mkrepeat:36-37`). `--write` saves it as a file in the functions directory (`zsh/.config/zsh/functions/mkrepeat:71-82`). Created names are tracked in `_mkrepeat_names` (`zsh/.config/zsh/functions/mkrepeat:45-67`).

**compiled-function digest (functions.zwc).** The compiled digest of the functions directory. The rules file `zsh/.config/zsh/functions/AGENTS.md` says to rebuild it after adding or deleting a function, and the root `AGENTS.md` adds that a stale digest keeps serving a deleted function (`zsh/.config/zsh/functions/AGENTS.md:13`). No file in the repo builds it; `*.zwc` is gitignored and the autoload glob skips it (`.gitignore:11`, `zsh/.config/zsh/.zprofile:40`).

## Where to look

- `AGENTS.md` holds the agent rules these terms come from.
- `zsh/.config/zsh/functions/AGENTS.md` holds the pairing and helper rules.
- `zsh/.config/zsh/.zshrc` and `zsh/.config/zsh/rc.d/` hold the stage loop and the skip switches.
- `Makefile` and `install.zsh` hold the package and section definitions.
