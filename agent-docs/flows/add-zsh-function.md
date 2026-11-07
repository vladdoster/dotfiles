---
id: flows/add-zsh-function
parent: START-HERE
title: Add or change a zsh function
exemplars: [58, 59, 61]
prescribed_files:
  - zsh/.config/zsh/functions/*
  - zsh/.config/zsh/completions/_*
  - zsh/.config/zsh/functions/AGENTS.md
owns: []
triggers:
  - add a zsh function
  - add a zsh function and its completion
entry_points:
  - zsh/.config/zsh/functions/AGENTS.md
  - zsh/.config/zsh/functions/mkfn:43
  - zsh/.config/zsh/completions/_mkrepeat
  - zsh/.config/zsh/functions/r:29
related:
  - components/zsh/function-tooling
  - areas/zsh
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---

**Related:** [Function and completion tooling](../components/zsh/function-tooling.md) · [Zsh](../areas/zsh.md)

A zsh function in this repo is two files committed together: a function body in `zsh/.config/zsh/functions/NAME` and a completion in `zsh/.config/zsh/completions/_NAME`. This flow covers creating, extending, renaming and deleting that pair, reloading it into a running shell, and what to run before opening a PR.

## How the pair is wired

`.zprofile` adds `functions` and `completions` to `fpath` and runs `autoload -Uz` on every file in `functions/` that is not `*.md` or `*.zwc` (`zsh/.config/zsh/.zprofile:39-40`). A new file is therefore autoloaded in each new login shell with no registration step. Completion files are picked up from `fpath` by `compinit` through their `#compdef` line.

`zsh/.config/zsh/functions/AGENTS.md` makes the completion mandatory (`zsh/.config/zsh/functions/AGENTS.md:3`). Two of the three exemplar PRs carry it in the same diff. PR 60 did not: it added `mkrepeat` and `help-zshglob` with no `_mkrepeat`, and PR 61 added the completion afterwards. That gap is why the rule is now written down.

## Step 1: create the function file

Run `mkfn NAME` (add `-e` to open it in `$EDITOR`). It writes `zsh/.config/zsh/functions/NAME` from a skeleton and refuses to overwrite an existing file (`zsh/.config/zsh/functions/mkfn:38-41`, skeleton at `zsh/.config/zsh/functions/mkfn:43-67`). The skeleton gives you:

- `#autoload` on the first line and the repo vim modeline on the second.
- A header comment describing the function.
- `emulate -L zsh`, `setopt extendedglob` and `zmodload zsh/zutil`.
- `zparseopts -D -F -K` for `-h/--help` and `-d/--debug`, a usage block printed by `--help`, and `(( $#opt_debug )) && setopt xtrace`.

The file is a bare body, not `name() { ... }`. Edit the `zparseopts` line and the usage block to match the options the function really takes. Report problems with `log::error` and progress with `log::info` (`zsh/.config/zsh/functions/add-to-path:32,46`).

PR 61 shows a new function written in that shape: `functions/sys-report` starts with `#autoload`, the modeline and a one-line description, then `emulate -L zsh`, `zparseopts` with long and short forms, and a `--help` block that lists every option.

To define a function that runs a command and refills the prompt with its own name, use `mkrepeat NAME COMMAND...` instead. By default it defines the function in the current shell only; `--write` also saves it as `functions/NAME` (`zsh/.config/zsh/functions/mkrepeat:71-82`). A function saved this way still needs a completion.

Helpers that only other functions call may use a `::` name such as `wezterm::_pane`. They need no completion, and they are listed by name in `zsh/.config/zsh/functions/AGENTS.md` (`zsh/.config/zsh/functions/AGENTS.md:12`). Add a new helper to that line in the same commit.

## Step 2: change an existing function

Edit the file in place. If the change adds, renames or removes an option, change the completion in the same commit. Example from PR 58 (`feat(zsh): accept multiple dirs in add-to-path`):

- `functions/add-to-path` changed from exactly one argument to `<directory>...`. The usage text, the argument check and the `-p` help line changed together.
- `completions/_add-to-path` changed `'1:directory:_directories'` to `'*:directory:_directories'` and updated the `-p` description to match the function (`zsh/.config/zsh/completions/_add-to-path:6-7`).

Example from PR 59 (`dkr nuke --volumes`): the function added `--volumes` to its `zparseopts` call and usage text, and `completions/_dkr` gained the matching `'--volumes[Also remove all docker volumes]'` line under the `nuke` subcommand. Subcommand-style functions such as `dkr` keep all their completion in one `_dkr` file.

## Step 3: write the completion

Create `zsh/.config/zsh/completions/_NAME`. `zsh/.config/zsh/functions/AGENTS.md` sets the rules (`zsh/.config/zsh/functions/AGENTS.md:5-11`):

- The first line is `#compdef NAME`.
- The last line is the modeline `# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:`.
- Cover every option the function passes to `zparseopts`, long and short, with a description.
- A function with no arguments completes only `-h` and `--help`.
- Use `_sys-report` and `_mkrepeat` as templates.

`_mkfn` is the smallest complete example (`zsh/.config/zsh/completions/_mkfn:1-8`). `_mkrepeat` shows two techniques: `-A '-*'` stops option parsing at the first non-option word, and `'*:::command:_normal'` completes the wrapped command (`zsh/.config/zsh/completions/_mkrepeat:6-11`). It also changes the first argument's completer when `-f` is on the line (`zsh/.config/zsh/completions/_mkrepeat:3-4`). Mutually exclusive options use the `'(-c --color -n --no-color)'` exclusion prefix, as in `_sys-report` (PR 61).

Read `zsh/.config/zsh/completions/AGENTS.md` before writing anything beyond a flat option list. It covers `_arguments` syntax, state-based and nested-subcommand completion (inner `_arguments` calls need `-C`; read the subcommand from `line[1]`), and the `_store_cache` API.

## Step 4: rename or delete

PR 59 renamed `zsh::load-completion` to `load-comp`. Both files were renamed in the diff, and the `#compdef` line inside the completion changed to the new name (`zsh/.config/zsh/completions/_load-comp:1`). A rename that leaves the old `#compdef` line behind produces a completion for a command that no longer exists.

After a delete or rename, rebuild functions.zwc (Step 5). A stale digest keeps serving the old function. Search the repo for callers of the old name before removing it.

## Step 5: rebuild functions.zwc

`zsh/.config/zsh/functions/AGENTS.md` says to rebuild the digest functions.zwc after adding or deleting a function (`zsh/.config/zsh/functions/AGENTS.md:13`), and the root `AGENTS.md` gives the symptom: a stale digest keeps serving a deleted function. The digest is gitignored (`.gitignore:11`), and the autoload globs skip it (`zsh/.config/zsh/.zprofile:40`, `zsh/.config/zsh/functions/r:29`). No script in the repo builds it. The command that creates it is not determined from the code. If a functions.zwc file exists in `zsh/.config/zsh`, either recompile it or delete it (`zsh-clean` removes every `*.zwc` below `$ZDOTDIR`, `zsh/.config/zsh/functions/zsh-clean:33`).

Check for a digest before blaming the code when a deleted function still runs:

```zsh
ls $ZDOTDIR/functions.zwc
```

## Step 6: reload and try it

`r` re-autoloads every file in `functions/`. It unfunctions each name and runs `autoload -Uz` again, so edits to existing bodies take effect without a new shell (`zsh/.config/zsh/functions/r:29-34`). `r --trace` autoloads with tracing and `r --debug` turns on xtrace.

`r` does not reload completions. For a changed completion, run `unfunction _NAME; autoload -U _NAME`, or open a new shell. A brand-new completion file also needs `compinit` to see it, which a new shell does. For a full check, `zsh::rld --dry-run` starts `zsh -ilc exit` and fails if the exit status is non-zero or anything prints (`zsh/.config/zsh/functions/zsh::rld:33-45`); without `--dry-run` it then restarts the shell.

When you need an isolated run, `zsh -f` needs `setopt extendedglob` before the function file is loaded (root `AGENTS.md`, Gotchas). PR 59's test used `zsh -f` with a stub `docker` to check `--help`, a bad option and call order. PR 61's description lists `zsh -n` on each changed function and loading each completion in a clean zsh.

## Step 7: verify before the PR

Run these from the repo root:

```zsh
zsh -n zsh/.config/zsh/functions/NAME        # syntax
NAME --help                                  # usage lists every option
zsh -f -c 'setopt extendedglob; ...'         # isolated run of the new behaviour
zsh .github/tests/install.zsh                # regression checks for install.zsh, Makefile, Brewfile
```

`zsh .github/tests/install.zsh` does not exercise anything under `zsh/.config/zsh/functions` or `completions`; it checks the installer, the `Makefile` and the `Brewfile` (`.github/tests/install.zsh:1-4`). Run it when the change touches those or rc.d. CI runs it in `.github/workflows/install.yml:47-48`. Never run the end-to-end test script locally; it deletes Homebrew.

Then check the pairing by hand:

- `completions/_NAME` exists, starts with `#compdef NAME` and ends with the modeline.
- Each option in `zparseopts` appears in the completion and in the `--help` text.
- `zsh/.config/zsh/functions/AGENTS.md` lists any new internal helper.
- No stale functions.zwc is left over a deleted or renamed function.
- A fresh `zsh -il` starts without errors, then `NAME <TAB>` and `NAME -<TAB>` offer the expected words.
- `rg` finds no remaining use of a removed or renamed function name.

## Commit and PR conventions

Subjects use Conventional Commits with the `zsh` scope: `feat(zsh): accept multiple dirs in add-to-path`, `feat(zsh): add mkrepeat function generator`, `docs(agents): add AGENTS.md guides`. The `Standards` workflow runs the commit and lint checks from `vladdoster/.github` (`.github/workflows/standards.yml:13-18`); the release workflow publishes, and merged PRs get a release comment from the bot. The checks in the shared workflows were not read.

Sign off every commit and set the author as described in the root `AGENTS.md`. Do not name the tool or model in commits or PR text. The PR body follows the repo template used by PRs 58, 59 and 61: a summary, `Related issue(s)`, `Usage examples` as a zsh block, `How has this been tested?` and `Types of changes` checkboxes.

PRs 58, 59 and 61 have no human review comments, so no extra reviewer requirements beyond the `AGENTS.md` rules were found.

## Variations seen in the exemplars

- PR 58 and 59 change one function and one completion. PR 61 adds several functions and a completion in one PR; it also bundles the rules files, which is why the pairing rule now reads as a single list.
- PR 59 marks the rename as a breaking change in its checklist, because the old command name stops working.
- A function that wraps subcommands (`dkr`) keeps the usage text per subcommand and puts all subcommand options in one completion file.
