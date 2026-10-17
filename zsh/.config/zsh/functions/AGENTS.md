# Functions directory rules

Every function here MUST have a zsh completion file in `../completions`.

- Name file `_<function-name>`. Example: `sys-report` has `../completions/_sys-report`.
- Start file with `#compdef <function-name>`.
- End file with vim modeline used by other completion files.
- Add or change completion in same commit as function.
- Cover every option function parses with `zparseopts`.
- Use `../completions/_sys-report` and `../completions/_mkrepeat` as templates.
- No-argument function: completion offers only `-h` and `--help`.
- Internal helpers need no completion. Helpers: `wezterm::_pane`. List new ones here.
- Rebuild `../functions.zwc` after adding or deleting a function.

Read `../completions/AGENTS.md` before writing completion.
