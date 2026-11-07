---
id: components/zsh/everyday-utilities
level: 2
title: Everyday zsh utilities
parent: areas/zsh
owns:
  - zsh/.config/zsh/functions/c
  - zsh/.config/zsh/completions/_c
  - zsh/.config/zsh/functions/v
  - zsh/.config/zsh/completions/_v
  - zsh/.config/zsh/functions/vd
  - zsh/.config/zsh/completions/_vd
  - zsh/.config/zsh/functions/h
  - zsh/.config/zsh/completions/_h
  - zsh/.config/zsh/functions/df
  - zsh/.config/zsh/completions/_df
  - zsh/.config/zsh/functions/xcah
  - zsh/.config/zsh/completions/_xcah
  - zsh/.config/zsh/functions/xcoh
  - zsh/.config/zsh/completions/_xcoh
  - zsh/.config/zsh/functions/xdah
  - zsh/.config/zsh/completions/_xdah
  - zsh/.config/zsh/functions/xsth
  - zsh/.config/zsh/completions/_xsth
  - zsh/.config/zsh/functions/dotfiles::edit
  - zsh/.config/zsh/completions/_dotfiles::edit
  - zsh/.config/zsh/functions/dotfiles::make
  - zsh/.config/zsh/completions/_dotfiles::make
  - zsh/.config/zsh/functions/edit::file
  - zsh/.config/zsh/completions/_edit::file
  - zsh/.config/zsh/functions/edit::find-replace
  - zsh/.config/zsh/completions/_edit::find-replace
  - zsh/.config/zsh/functions/extract
  - zsh/.config/zsh/completions/_extract
  - zsh/.config/zsh/functions/extract-images
  - zsh/.config/zsh/completions/_extract-images
  - zsh/.config/zsh/functions/mkbak
  - zsh/.config/zsh/completions/_mkbak
  - zsh/.config/zsh/functions/mkfile
  - zsh/.config/zsh/completions/_mkfile
  - zsh/.config/zsh/functions/fzfp
  - zsh/.config/zsh/completions/_fzfp
  - zsh/.config/zsh/functions/ls-path
  - zsh/.config/zsh/completions/_ls-path
  - zsh/.config/zsh/functions/add-to-path
  - zsh/.config/zsh/completions/_add-to-path
  - zsh/.config/zsh/functions/watch::file-count
  - zsh/.config/zsh/completions/_watch::file-count
  - zsh/.config/zsh/functions/zpgrep
  - zsh/.config/zsh/completions/_zpgrep
  - zsh/.config/zsh/functions/acme
  - zsh/.config/zsh/completions/_acme
  - zsh/.config/zsh/functions/banner
  - zsh/.config/zsh/completions/_banner
  - zsh/.config/zsh/functions/clock
  - zsh/.config/zsh/completions/_clock
  - zsh/.config/zsh/functions/emoji
  - zsh/.config/zsh/completions/_emoji
  - zsh/.config/zsh/functions/mock
  - zsh/.config/zsh/completions/_mock
triggers:
  - change how extract handles an archive type
  - add a flag to add-to-path or another utility
  - add a new text emoji to emoji
  - fix a completion for one of the small utility functions
  - change the file preview used by fzfp
entry_points:
  - zsh/.config/zsh/functions/c
  - zsh/.config/zsh/functions/extract
  - zsh/.config/zsh/functions/add-to-path
  - zsh/.config/zsh/completions/_dotfiles::make
related:
  - components/zsh/function-tooling
  - components/zsh/startup
  - components/zsh/dev-and-terminal
  - components/zsh/system-maintenance
generated: 2026-11-07
source_commit: 9c21e6b541ae7d4d867a6da32efbbf71b43d67ec
---
**Related:** [Zsh](../../areas/zsh.md) · [Startup](startup.md) · [Function tooling](function-tooling.md) · [System maintenance](system-maintenance.md) · [Dev and terminal](dev-and-terminal.md)

Small interactive functions, each an autoloaded file in `zsh/.config/zsh/functions/` with a same-named completion in `zsh/.config/zsh/completions/`. They cover jumping to directories, opening files in the editor, unpacking archives, changing `PATH`, and printing text. Most are 5 to 60 lines with no state. This doc covers the mechanisms they share and what each group does.

## How it works

Every function starts with `#autoload` and `emulate -L zsh`, which resets options for the call only (`zsh/.config/zsh/functions/vd:1-6`). Functions that glob also set `extendedglob` (`zsh/.config/zsh/functions/c:7`). Functions that parse options load `zsh/zutil` first and return 1 if it fails (`zsh/.config/zsh/functions/c:8`).

Errors go through `log::error`, and status messages through `log::info`, both separate autoloaded functions. `log::error` writes to stderr and colours the `Error:` prefix only when stderr is a terminal (`zsh/.config/zsh/functions/log::error:9-13`). Its owner is outside this doc.

Four rules from the directory guides apply to every file here: each function needs a completion named `_<function>` starting with `#compdef <function>` and ending with the vim modeline; the completion must cover every option the function parses; a function with no arguments offers only `-h` and `--help`; and the compiled-function digest is rebuilt after adding or deleting a function (`zsh/.config/zsh/functions/AGENTS.md`).

### The zparseopts pattern

Option parsing follows one form:

```zsh
local -a opt_help
zparseopts -D -F -K -- {h,-help}=opt_help || return 1
if (( $#opt_help )); then print -r -- "Usage: ..."; return 0; fi
```

`-D` removes parsed options from `$@`, `-F` fails on unknown options, and `-K` keeps the array empty when the flag is absent, so `$#opt_help` works as a boolean (`zsh/.config/zsh/functions/xcoh:9-17`). The help text is hand-written `print -r --` lines. Variations:

- `-d/--debug` turns on `setopt xtrace` and is present in `c`, `v`, `add-to-path` and `mock` (`zsh/.config/zsh/functions/c:21`). In `v` it instead prints the editor command without running it (`zsh/.config/zsh/functions/v:26-27`).
- `add-to-path` and `emoji` add `-E`, which lets options appear after positional arguments (`zsh/.config/zsh/functions/add-to-path:14`, `zsh/.config/zsh/functions/emoji:11`). `mock` uses `-E` as well (`zsh/.config/zsh/functions/mock:10`).
- `mkfile` takes a value with `{e,-extension}:=arg_extension` and reads `${arg_extension[-1]}` (`zsh/.config/zsh/functions/mkfile:14,27`).
- `ls-path` accepts the long-only `--fpath` (`zsh/.config/zsh/functions/ls-path:13`).
- `extract` does not use `zparseopts`. It checks `$1` against `-h|--help` and `-r|--remove` by hand (`zsh/.config/zsh/functions/extract:13-25`), so `-r` must come first.

### Completion conventions

Completions are short `_arguments` calls. Functions with flags use `-A '-*'`, which stops option completion at the first non-option word, and the mutual-exclusion form `'(-h --help)'{-h,--help}'[...]'` (`zsh/.config/zsh/completions/_extract:3-4`). Argument-less functions use `_message 'no arguments'` (`zsh/.config/zsh/completions/_fzfp:3`). Value hints use an inline list for closed sets, as in `mkfile` extensions and `emoji` names (`zsh/.config/zsh/completions/_mkfile:5`, `zsh/.config/zsh/completions/_emoji:7`).

Two completions are not obvious. `_dotfiles::make` rewrites `words` to `make -C $DOTFILES ...`, adds 2 to `CURRENT`, and calls `_make`, so target and variable completion works against the dotfiles Makefile (`zsh/.config/zsh/completions/_dotfiles::make:3-9`). The jump helpers use `_files -W <base> -g '*(/N:t)'`, which lists directory names under the base without the base prefix (`zsh/.config/zsh/completions/_h:3`). Two exceptions to that glob: `c` lists only directories with `_files -/` (`zsh/.config/zsh/completions/_c:6`), and `xcoh` globs files and directories with `*(N:t)` (`zsh/.config/zsh/completions/_xcoh:5`).

## Directory jumpers

`h`, `vd`, `df`, `xcah`, `xdah` and `xsth` are one-line `builtin cd -- <base>/$1` functions with no option parsing. The bases are `$HOME`, `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`, `${DOTFILES:-$HOME/.config/dotfiles}`, and the XDG cache, data and state directories, each with a hard-coded fallback (`zsh/.config/zsh/functions/h:8`, `zsh/.config/zsh/functions/vd:8`, `zsh/.config/zsh/functions/df:10`, `zsh/.config/zsh/functions/xcah:8`, `zsh/.config/zsh/functions/xdah:8`, `zsh/.config/zsh/functions/xsth:8`). With no argument they go to the base itself.

`df` shadows `df(1)`; its header says to use `command df` for disk usage (`zsh/.config/zsh/functions/df:6`). The env rc file exports `XDG_CACHE_HOME`, `XDG_CONFIG_HOME` and `XDG_DATA_HOME` and finds `DOTFILES` by walking up to a `.git` directory (`zsh/.config/zsh/rc.d/00-env.zsh:6-15`). It sets no `XDG_STATE_HOME`, so `xsth` uses its fallback of `~/.local/state`.

`c` is the longer jumper. It changes to `$HOME/code/<arg>` and then runs `command ls -A`. It rejects more than one argument and a missing directory with `log::error` (`zsh/.config/zsh/functions/c:23-35`). The base is hard-coded as `$HOME/code`, although the env rc file also sets `CODEDIR` to the same path (`zsh/.config/zsh/rc.d/00-env.zsh:10`). `xcoh` takes a path under `$XDG_CONFIG_HOME` and opens it with `${EDITOR:-vi}` if it is a file, `cd`s if it is a directory, and errors otherwise (`zsh/.config/zsh/functions/xcoh:19-28`).

## Editing

`v` and `edit::file` both run the editor on their arguments. `v` calls `$EDITOR` directly because the env rc file resolves it to an absolute binary (nvim, then vim, then vi) so that tools that exec the editor without a shell can find it (`zsh/.config/zsh/rc.d/00-env.zsh:23-24`, `zsh/.config/zsh/functions/v:25-29`). `edit::file` uses `${EDITOR:-vi} -- "$@"` (`zsh/.config/zsh/functions/edit::file:8`).

`dotfiles::edit` globs every regular file below `$DOTFILES` (`**/*(.N)`, which skips dotfiles and so excludes `.github/` and similar), pipes the list through `fzfp`, and opens the choice in the editor. It returns 1 on an empty selection (`zsh/.config/zsh/functions/dotfiles::edit:9-20`). `fzfp` runs `fzf` with a preview toggled by `?`: binary files print a message, text goes through `highlight` and falls back to `head -500` (`zsh/.config/zsh/functions/fzfp:8-12`). `dotfiles::make` runs `command make -C $DOTFILES "$@"` (`zsh/.config/zsh/functions/dotfiles::make:8`).

`edit::find-replace old new` globs regular files below the current directory without dotfiles, then runs `gsed -i "s/old/new/g"` over them in batches through `zargs` (`zsh/.config/zsh/functions/edit::find-replace:19-28`). It needs GNU sed installed as `gsed`, and the arguments are interpolated into the sed expression unescaped, so a `/` in either breaks it. `mkbak` copies each argument to `<name>.bak` and returns 1 if any copy failed (`zsh/.config/zsh/functions/mkbak:27-35`). `mkfile -e <ext> name...` writes `name.<ext>` with a shebang, a header comment and a vim modeline, sets mode 755, and skips names that already exist (`zsh/.config/zsh/functions/mkfile:37-56`). `zpgrep` loads `zsh/pcre`, compiles the first argument, and prints matching lines from the named files or stdin. Its exit status is 0 only if some line matched (`zsh/.config/zsh/functions/zpgrep:27-51`).

## Archives

`extract [-r] file...` dispatches on file name through one `case` statement, and each branch sets `failed=1` on error (`zsh/.config/zsh/functions/extract:46-95`). Tar variants use `tar` flags directly, except tar.xz and tar.zma/`.tlz`, which test whether `tar` supports `--xz`/`--lzma` and otherwise pipe through `xzcat`/`lzcat` (`zsh/.config/zsh/functions/extract:49-62`). `.zip` extracts into a directory named after the file stem (`zsh/.config/zsh/functions/extract:43,70`). `.deb` unpacks `control` and `data` subdirectories using `ar` and `tar`, descending with `pushd` and restoring with `popd` in an `always` block (`zsh/.config/zsh/functions/extract:73-90`). `.deb` assumes the members are control.tar.gz and data.tar.gz. The tar.zstd suffix is matched, not the more common tar.zst.

An unmatched suffix or a missing file is reported and sets the overall status to 1, and extraction continues with the next argument. With `-r`, the archive is deleted only after that archive succeeded (`zsh/.config/zsh/functions/extract:97-101`). The completion file glob lists the same suffixes (`zsh/.config/zsh/completions/_extract:5`).

`extract-images` is unrelated to `extract`. Called as `extract-images file`, it writes an array named `reply` in the caller's scope, with the unique image URLs (gif, jpg, png, svg) found in an HTML or XML file. The caller must declare `local -a reply` first because the function assigns to it without declaring it (`zsh/.config/zsh/functions/extract-images:42-45,55-64`). It returns 0 if `reply` is non-empty. Most of the file is explanatory comments.

## PATH

`add-to-path [-p] dir...` validates each directory, skips ones already in `path` on an append, and then assigns once so that order is preserved: `path=($dirs $path)` to prepend, `path+=($dirs)` to append (`zsh/.config/zsh/functions/add-to-path:40-60`). Its header says `path` is declared unique (`-U`) in `.zprofile` (`zsh/.config/zsh/functions/add-to-path:6-7`). `zsh/.config/zsh/.zprofile:19` sets it with `typeset -gUa path ...`. A prepend of an existing entry relies on that property to remove the later duplicate. `ls-path` prints `$path`, or `$fpath` with `--fpath`, one entry per line under a coloured header (`zsh/.config/zsh/functions/ls-path:20-28`).

## Text and novelty

`acme` prints its arguments with a blue symbol and cyan background. `banner` pipes arguments through `figlet -c`, sized to `$COLUMNS`, and exits 1 without figlet or without arguments (`zsh/.config/zsh/functions/banner:17-26`). `emoji` keeps a three-entry associative array (`disappointed`, `flip`, `shrug`) and prints the chosen one, or copies it with `pbcopy` under `-c` (`zsh/.config/zsh/functions/emoji:17-21,50-55`). The names are duplicated in `_emoji`, so a new emoji needs both files (`zsh/.config/zsh/completions/_emoji:7`). `mock` randomises the case of each character in its arguments, or of stdin when it is not a terminal and no arguments were given (`zsh/.config/zsh/functions/mock:33-50`).

`clock` and `watch::file-count` both loop forever: print three lines, wait with `zselect -t 100` (one second, since the unit is hundredths), then move the cursor up and clear three lines with `echoti cuu1` and `echoti el`. They use zsh modules instead of external `date`, `sleep` and `tput` (`zsh/.config/zsh/functions/clock:6-24`, `zsh/.config/zsh/functions/watch::file-count:13-23`). Neither handles `SIGINT` specially, and neither takes options.

## Where to look

- `zsh/.config/zsh/functions/extract` holds the archive dispatch and the status-handling pattern.
- `zsh/.config/zsh/functions/add-to-path` is the fullest example of the option and validation pattern in this group.
- `zsh/.config/zsh/functions/c` is the template for a jumper with options and error handling.
- `zsh/.config/zsh/completions/_dotfiles::make` shows how to delegate to another command's completion.
- `zsh/.config/zsh/functions/AGENTS.md` and `zsh/.config/zsh/completions/AGENTS.md` set the rules for adding a function and its completion.
