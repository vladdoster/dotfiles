---
id: components/zsh/startup
level: 2
title: Zsh Startup, zinit, Completion and Prompt
parent: areas/zsh
owns:
  - zsh/.zshenv
  - zsh/.config/zsh/.zshrc
  - zsh/.config/zsh/.zprofile
  - zsh/.config/zsh/rc.d/**
  - zsh/.stow-local-ignore
  - zsh/.config/zsh/completions/_complete_dots_last
triggers:
  - add a new rc.d startup file
  - install or change a zinit plugin
  - change completion styles or the completer list
  - change the shell prompt or git status in the prompt
  - debug slow or broken shell startup
  - skip zinit or rc.d when starting a shell
entry_points:
  - zsh/.config/zsh/.zshrc:23
  - zsh/.config/zsh/rc.d/05-zinit.zsh
  - zsh/.config/zsh/rc.d/06-completion.zsh
  - zsh/.config/zsh/.zprofile:31
related:
  - areas/zsh
  - components/zsh/function-tooling
  - components/zsh/system-maintenance
  - reference/gotchas
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---

**Related:** [Zsh](../../areas/zsh.md) · [Function tooling](function-tooling.md) · [System maintenance](system-maintenance.md) · [Gotchas](../../reference/gotchas.md)

Zsh reads `~/.zshenv`, then `$ZDOTDIR/.zprofile` (login shells) and `$ZDOTDIR/.zshrc` (interactive shells). `.zshrc` sets history and shell options, then sources every numbered file in rc.d in order, then runs `compinit`. The rc.d files set environment variables, aliases, widgets, the fzf theme, clipboard helpers, zinit plugins, completion styles and the prompt. This doc covers the startup chain and the files it loads. Autoloaded functions are in [Function tooling](function-tooling.md).

## How it works

```mermaid
flowchart LR
    zshenv[".zshenv"] --> zprofile[".zprofile"]
    zprofile --> zshrc[".zshrc"]
    zshrc -->|"non-login: source"| zprofile
    zshrc --> env["00-env"]
    env --> alias["01-alias"] --> widget["02-widget"] --> fzf["03-fzf"]
    fzf --> clip["04-clipboard"] --> zinit["05-zinit"]
    zinit --> comp["06-completion"] --> prompt["07-prompt"]
    prompt --> compinit["compinit"]
```

`zsh/.zshenv` is the only file stowed into `$HOME`; the rest live under `~/.config/zsh`. It sets `ZDOTDIR` to `$HOME/.config/zsh` if unset (`zsh/.zshenv:6`) and nothing else, because it runs for every zsh including scripts. Homebrew setup was moved out of it to `.zprofile` (`zsh/.zshenv:5`).

`.zprofile` is read only by login shells. `.zshrc` sources it when the shell is not a login shell, so the PATH, fpath and autoloads exist in every interactive shell before `compinit` runs (`zsh/.config/zsh/.zshrc:14`). A login shell therefore reads it once and a non-login shell reads it once, through that line.

`.stow-local-ignore` contains the pattern `\.zcompdump` (`zsh/.stow-local-ignore:1`), so the generated `.zcompdump` in the package directory is not symlinked into `$HOME`.

## .zprofile

`.zprofile` runs with `local_options`, `extended_glob`, `prompt_subst` and `no_global_rcs` (`zsh/.config/zsh/.zprofile:4`). It does four things.

1. Creates tied scalar/array pairs for `INFOPATH` and `MANPATH` and marks `path` and the other path arrays unique (`zsh/.config/zsh/.zprofile:17-19`).
2. Finds a Homebrew binary under `/opt`, `/usr/local` or the Linuxbrew locations and evals its `shellenv` output. The glob uses the `(N-.)` qualifier, so a missing prefix expands to nothing and only the first hit is used (`zsh/.config/zsh/.zprofile:23-28`).
3. Prepends `~/.local/bin`, `~/.cargo/bin` and the Go bin directory to `path`, keeping only directories that exist (`zsh/.config/zsh/.zprofile:33-38`). The comment ties each entry to a Brewfile package manager (`zsh/.config/zsh/.zprofile:32`).
4. Prepends `functions/` and `completions/` to `fpath` and autoloads every file in `functions/` except `*.md` and `*.zwc` (`zsh/.config/zsh/.zprofile:39-40`). This is the only place functions are autoloaded; the layout rules are in [Function tooling](function-tooling.md).

The last line runs `unsetopt norcs` (`zsh/.config/zsh/.zprofile:43`).

## .zshrc

Options and history come first: `auto_cd`, `extended_glob`, `glob_dots`, `interactive_comments`, `prompt_subst` (`zsh/.config/zsh/.zshrc:4`); 200000 history entries, with `HISTFILE` defaulting to `$ZDOTDIR/zsh_history` (`zsh/.config/zsh/.zshrc:6-8`); and shared, incrementally appended, extended-format history with duplicate removal (`zsh/.config/zsh/.zshrc:9-10`).

An anonymous function registers named directories `~bin`, `~share`, `~config`, `~code` and `~zsh` (`zsh/.config/zsh/.zshrc:16-21`).

The rc.d loop runs only when `NO_RC` is empty (`zsh/.config/zsh/.zshrc:23-27`). It uses the glob `<->-*zsh(N)` on the rc.d directory, so a file needs a numeric prefix and a name ending in `zsh` to load, and numeric order is the load order. Files are sourced into the shell's top level, which is why `local` declarations in the zinit and fzf files are scoped to the sourcing context rather than to a function.

`compinit` runs after the loop (`zsh/.config/zsh/.zshrc:29-30`) with no `-d`, so the dump goes to `$ZDOTDIR/.zcompdump`. `bashcompinit` is autoloaded but its call is commented out (`zsh/.config/zsh/.zshrc:31`). Because `compinit` comes last, any `compdef` call and any `_comps` assignment made in rc.d runs before `_comps` exists; the effect on the zinit completion hook is covered below.

## Skip switches

`NO_RC` set to any non-empty value skips the whole rc.d loop (`zsh/.config/zsh/.zshrc:23`). `NO_ZINIT` set to any non-empty value makes the zinit file unset itself, log a message and `return 0`, so the later rc.d files still load (`zsh/.config/zsh/rc.d/05-zinit.zsh:6-10`). The `zsh::rld` function sets `NO_ZINIT` when it re-execs the shell (`zsh/.config/zsh/functions/zsh::rld:33`, `zsh/.config/zsh/functions/zsh::rld:52`); see [System maintenance](system-maintenance.md).

## rc.d files

The directory holds eight files at HEAD. The root `AGENTS.md` lists a ninth stage called `repeat`; no such file exists at HEAD.

**00-env.zsh** exports `TERM`, `COLORTERM`, XDG directories and tool settings. It locates the checkout by walking up from the resolved path of the sourced file until a `.git` directory appears, falling back to `~/.config/dotfiles`, and exports that as `DOTFILES` unless already set (`zsh/.config/zsh/rc.d/00-env.zsh:12-16`). `EDITOR` is the first of nvim, vim or vi found in `commands`, resolved to a real binary because external tools exec it (`zsh/.config/zsh/rc.d/00-env.zsh:22-25`). Homebrew hint and cleanup suppression, `SHELL_SESSIONS_DISABLE` and pip settings are exported at `zsh/.config/zsh/rc.d/00-env.zsh:27-36`.

**01-alias.zsh** defines suffix aliases, global aliases, helper functions prefixed `_`, and loops that create edit and goto aliases from associative arrays (`zsh/.config/zsh/rc.d/01-alias.zsh:60-79`). `zrc` and `zic` open `.zshrc` and the zinit file in `$EDITOR` (`zsh/.config/zsh/rc.d/01-alias.zsh:60`). Other groups: zmv aliases (`zsh/.config/zsh/rc.d/01-alias.zsh:3-5`), suffix and global aliases (`zsh/.config/zsh/rc.d/01-alias.zsh:6-11`), Claude, wezterm and zinit shortcuts (`zsh/.config/zsh/rc.d/01-alias.zsh:86-97`), network and server helpers (`zsh/.config/zsh/rc.d/01-alias.zsh:99-107`) and `fmt*` formatter wrappers (`zsh/.config/zsh/rc.d/01-alias.zsh:109-113`).

**02-widget.zsh** replaces `accept-line` with `_accept-line-with-url`, which rewrites a pasted https URL that contains git into `git clone <url> && cd <name>` and strips a leading `$ ` from pasted commands (`zsh/.config/zsh/rc.d/02-widget.zsh:6-26`). It also binds alt-s to `git status`, adds `prepend-sudo` and `insert-last-command-output` to vicmd, and adds a `precmd` hook that resets terminal state (`zsh/.config/zsh/rc.d/02-widget.zsh:29-53`). `enable_print_alias` and `disable_print_alias` add and remove a `preexec` hook that prints the expansion of an alias; neither is called in this file (`zsh/.config/zsh/rc.d/02-widget.zsh:94-101`).

**03-fzf.zsh** sets `FZF_DEFAULT_OPTS` from a colour table, only when `fzf` is on `PATH` (`zsh/.config/zsh/rc.d/03-fzf.zsh:3-18`). fzf itself is installed by zinit later, so on a first start `fzf` is not yet found and the options are not set until the next shell. This follows from the order of files; it was not tested.

**04-clipboard.zsh** defines lazy `clipcopy` and `clippaste`. The first call runs `detect-clipboard`, which redefines both for pbcopy, wl-clipboard, xsel, xclip, lemonade, doitclient or tmux (`zsh/.config/zsh/rc.d/04-clipboard.zsh:51-95`).

## zinit (05-zinit.zsh)

The file keeps zinit under `~/.local/share/zinit` and fills the `ZINIT` associative array with its directories and source organisation `zdharma-continuum` (`zsh/.config/zsh/rc.d/05-zinit.zsh:12-21`). If the zinit entry script is missing it clones the repository (branch `main` unless `ZINIT[BRANCH]` is set), tightens the directory mode and compiles it, logging through `log::info` and `log::error` (`zsh/.config/zsh/rc.d/05-zinit.zsh:23-36`). Those two functions are autoloaded from `functions/`. A missing install after that point logs an error and `return 1` (`zsh/.config/zsh/rc.d/05-zinit.zsh:42-45`).

After sourcing the zinit entry script, the file autoloads `_zinit` and sets `_comps[zinit]` only if `_comps` already exists (`zsh/.config/zsh/rc.d/05-zinit.zsh:37-41`). `_comps` is created by `compinit`, which `.zshrc` runs after rc.d, so whether this assignment ever runs on a first pass was not determined from the code.

Plugins are declared with `zi id-as for` and ice modifiers, with `@owner/repo` shorthand. Active groups at HEAD:

- Annexes `zinit-annex-binary-symlink` (pinned to branch `fix/binary-selection-glob`), `bin-gem-node` and `linkman` (`zsh/.config/zsh/rc.d/05-zinit.zsh:49-52`).
- The `@vladdoster/zsh-aliases` and `zinit-aliases` plugin files (`zsh/.config/zsh/rc.d/05-zinit.zsh:54`).
- `dandavison/delta` from GitHub releases with `lbin'!'`, plus a `zdharma-continuum/null` entry whose `atload` defines `l`, `la`, `ll` and `ls` as eza commands with `no_aliases` set (`zsh/.config/zsh/rc.d/05-zinit.zsh:56-60`).
- Release binaries StyLua, fzf, bat, fd, hyperfine and topgrade, installed from `gh-r` with `lbin'!'` and `lman` (`zsh/.config/zsh/rc.d/05-zinit.zsh:91-96`).
- Source builds of `Koihik/LuaFormatter` and `thewtex/tmux-mem-cpu-load` with `cmake` (`zsh/.config/zsh/rc.d/05-zinit.zsh:114-116`).
- `NICHOLAS85/z-a-eval`, loaded before the group that uses the `eval` ice (`zsh/.config/zsh/rc.d/05-zinit.zsh:132`).
- A `lucid` group: the Claude Code completion as `as"completion"`, zsh-autosuggestions (binds `^_` to execute and `^ ` to accept), zsh-patina (`eval"zsh-patina activate"`), zshelldoc, zsh-vim-mode (binds `^v` in vicmd to `edit-command-line`), zunit, zsh-history-substring-search (binds the up and down arrows) and `trapd00r/LS_COLORS`, whose `atload` sets the `list-colors` style from `LS_COLORS` (`zsh/.config/zsh/rc.d/05-zinit.zsh:133-156`).

The `zi if'(())' ... for` lines at 91 and 114 use an `if` ice that evaluates an empty arithmetic expression. The per-entry `if'((1))'` at `zsh/.config/zsh/rc.d/05-zinit.zsh:92` overrides it for the first group; how the ice list distributes over the remaining entries was not determined from the code. Line 47 evals a `MODE_CURSOR_*` assignment for the vim-mode plugin's cursor shapes (`zsh/.config/zsh/rc.d/05-zinit.zsh:47`).

The rest of the file (lines 63-89, 98-130, 158-209) is commented-out experiments and former plugin lists. They are not active, but they show retired choices such as `zsh-completions`, `fast-syntax-highlighting` and an nvim build. `zinstall` in the alias file opens the zinit install script and `zireset` clears completion variables then runs `ziprune` and `zrld` (`zsh/.config/zsh/rc.d/01-alias.zsh:67`, `zsh/.config/zsh/rc.d/01-alias.zsh:73`).

## Completion (06-completion.zsh)

This file runs before `compinit`. It sets up bracketed paste with `bracketed-paste-magic` restricted to `self-*` widgets (`zsh/.config/zsh/rc.d/06-completion.zsh:2-5`), a block of `setopt` and `unsetopt` calls (`zsh/.config/zsh/rc.d/06-completion.zsh:8-14`), and loads `zsh/complist` early so the `menuselect` keymap exists for the hjkl bindings (`zsh/.config/zsh/rc.d/06-completion.zsh:16-22`). `correct` and `correct_all` are turned off, `noclobber` and `autopushd` are on.

The completer list is `_expand _complete_dots_last _ignored _approximate` (`zsh/.config/zsh/rc.d/06-completion.zsh:25`). Other styles:

- Completion caching is on, in `${XDG_CACHE_HOME}/zsh/zcompcache` (`zsh/.config/zsh/rc.d/06-completion.zsh:28-29`).
- `rehash true`, `squeeze-slashes true`, menu selection, and a group order of functions, builtins, commands for command position (`zsh/.config/zsh/rc.d/06-completion.zsh:31-36`).
- The matcher list tries exact, case-insensitive, partial-word on `._-`, then substring (`zsh/.config/zsh/rc.d/06-completion.zsh:57`).
- `approximate` allows one error per three typed characters (`zsh/.config/zsh/rc.d/06-completion.zsh:45`).
- ssh, scp, rsync and sftp take host names from `Host` lines in `~/.ssh/config`, skipping wildcard entries (`zsh/.config/zsh/rc.d/06-completion.zsh:69-70`).
- Completion function names starting with `_` are hidden until the `_ignored` completer (`zsh/.config/zsh/rc.d/06-completion.zsh:76`).

`special-dirs` is `false` so zsh does not offer `./` and `../` ahead of other matches (`zsh/.config/zsh/rc.d/06-completion.zsh:34`). `completions/_complete_dots_last` restores them at the end. It calls `_complete`, then, if the typed word's last component is `.` or `..` and the directory prefix exists, adds `./ ../` (or `../`) to a group named `dots-last` with `compadd -V`, which keeps the group's order and places it last (`zsh/.config/zsh/completions/_complete_dots_last:11-21`). It rewrites the context from `complete-dots-last` to `complete` so existing `:completion:*:complete:*` styles still apply (`zsh/.config/zsh/completions/_complete_dots_last:6`). This is the one file in `completions/` that is a completer, not a per-command completion.

## Prompt (07-prompt.zsh)

`vcs_info` is enabled for git only and runs from a `precmd` hook (`zsh/.config/zsh/rc.d/07-prompt.zsh:3-7`). With `check-for-changes` on, `%u` expands to a red `*` for unstaged changes and `%c` to a green `+` for staged ones (`zsh/.config/zsh/rc.d/07-prompt.zsh:10-14`). The format is `[branch*+] `, and `[branch|action*+] ` during a merge or rebase (`zsh/.config/zsh/rc.d/07-prompt.zsh:17-18`). `PROMPT` is the last two path components in bold cyan, the `vcs_info_msg_0_` text, then `$ ` (`zsh/.config/zsh/rc.d/07-prompt.zsh:20`). `prompt_subst` is set so the variable re-expands each prompt. There is no `RPROMPT`.

## Where to look

- `zsh/.config/zsh/.zshrc` holds the options, the rc.d loop and the `compinit` call; start here for load-order questions.
- `zsh/.config/zsh/.zprofile` holds PATH, fpath, Homebrew env and the function autoload line.
- `zsh/.config/zsh/rc.d/05-zinit.zsh` holds every plugin and binary installed through zinit.
- `zsh/.config/zsh/rc.d/06-completion.zsh` holds all `zstyle ':completion:*'` settings; `zsh/.config/zsh/completions/_complete_dots_last` is the custom completer it names.
- `zsh/.config/zsh/rc.d/07-prompt.zsh` holds the prompt and git status format.
- `zsh/.config/zsh/rc.d/00-env.zsh` holds exported variables and `DOTFILES` discovery.
