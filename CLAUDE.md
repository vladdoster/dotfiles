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
