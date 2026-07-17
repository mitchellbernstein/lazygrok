---
name: ast-grep
description: "[LazyGrok] Use ast-grep (sg) for AST-aware code search and rewrite across 25 languages. Trigger for structural code matching or deterministic codemods: find every function/call/class/import shaped like X, rewrite console.log to logger.info, strip `as any`, migrate require() to import, find empty catch blocks or missing await, and scan/apply YAML rules. Prefer this over rg/grep when the target is syntax shape rather than text; use rg for string contents, comments, filenames, or regex-style byte searches. LazyGrok commands: /lg-ast-grep."
---
## Grok Harness Tool Compatibility

This skill was adapted from OmO / LazyCodex. On **Grok Build**, do **not** call Codex `multi_agent_v1.*`, OpenCode `call_omo_agent`, or `team_*` tools literally.

| Source example | Grok tool |
| --- | --- |
| `spawn_subagent` / `spawn_agent` / `call_omo_agent` / `task(...)` | `spawn_subagent` with `subagent_type` + self-contained `prompt` |
| `wait_agent` / `background_output` | `get_command_or_subagent_output` |
| `team_create` / `team_send_message` / `team_delete` | Parallel `spawn_subagent` waves; **you** (parent) broker findings between rounds |
| `todo_write` | `todo_write` |
| `search_replace` | `search_replace` / write |
| `codegraph_*` | Use if available; else `grep` + `read_file` + `lg-explorer` |
| Codex `Playwright / agent-browser / chrome-devtools (Grok browser tools)` | Playwright / agent-browser / chrome-devtools MCP / available browser tools |
| Codex LSP tools | Prefer project language servers via shell + `lsp-setup`; Grok has no native `lsp_*` unless configured |

Role map: `explorer`→`lg-explorer`, `librarian`→`lg-librarian`, `plan`→`lg-plan`, `metis`→`lg-metis`, `momus`→`lg-momus`, `oracle`/gate→`lg-gate-reviewer`, code review→`lg-code-reviewer`, workers→`lg-worker` / `lg-worker-high`. Built-in `explore` / `plan` / `general-purpose` are fine fallbacks.

Every child `prompt` is self-contained and starts with `TASK:` / `ROLE:` / `DELIVERABLE:` / `SCOPE:` / `VERIFY:`. Prefer `background: true` for parallel waves, then poll with `get_command_or_subagent_output`.

If a later code block conflicts with this section, **this section wins**.

# ast-grep

`sg` (also installed as `ast-grep`) is an **AST-aware search and rewrite tool** across 25 languages. It treats your pattern as code, parses it the same way it parses your project, and matches structurally. It is the right tool whenever your question depends on **code shape** rather than text bytes.

This skill ships a Python wrapper at `scripts/ast_grep_helper.py` and platform install scripts at `install.sh` (POSIX) and `install.ps1` (Windows). The helper adds offline pattern validation, the two-pass write trick, and binary auto-resolution. Use it as your default entry point.

---

## When to use this skill

Use it whenever the user's question is about **code structure**, not bytes:

- "Find every function that takes a `Request` parameter."
- "Rewrite every `console.log(x)` to `logger.info(x)`."
- "Strip every `as any` cast."
- "Replace `require(...)` with `import` across the repo."
- "Find empty catch blocks."
- "Migrate `Optional[X]` to `X | None`."
- "Apply this codemod across these 200 files."
- "Run our YAML lint rules and surface violations."

Switch to plain `grep` / `rg` when the question is text-shaped (string literal contents, comments, license headers, file names, cross-language regex). When in doubt, ask: "does the answer depend on the language's syntax tree, or just on the file's bytes?" If the former, ast-grep. If the latter, grep.

---

## Three things the agent must internalize

### 1. ast-grep is NOT regex

The wildcards are `$VAR` (one AST node) and `$$$` (zero or more nodes). Regex syntax fails silently:

| You wrote | What ast-grep saw | What you wanted |
|---|---|---|
| `foo\|bar` | bitwise-or of `foo` and `bar` | run two separate searches |
| `.*foo` | not parseable | `$$$ foo` (if `$$$` is a list of nodes) or use `rg` |
| `\w+` | not parseable | `$VAR` to capture any identifier |
| `[a-z]` | character class, not parseable | switch to `rg` |

The full anti-pattern table is in `references/pitfalls.md` §1. The helper's `validate` subcommand catches these mechanically — call it before debugging "no matches" by hand.

### 2. Patterns must be valid code

The pattern itself must parse. `def $FN($$$):` fails because the trailing `:` makes it incomplete; use `def $FN($$$)`. `function $NAME` without params/body fails; use `function $NAME($$$) { $$$ }`. Full table per language in `references/pitfalls.md` §2.

### 3. `--update-all` and `--json` are mutually exclusive (silently)

This is the single biggest gotcha when scripting. `sg run -p P -r R --json --update-all` returns the JSON but **does not mutate files**. To both preview AND apply, run **two passes**:

```bash
sg run -p P -r R --json=compact .   # pass 1: see what would change
sg run -p P -r R --update-all .     # pass 2: actually apply
```

The helper does this automatically when you call `replace --apply`. Read `references/pitfalls.md` §9.

---

## The helper script — `scripts/ast_grep_helper.py`

A single-file Python 3 stdlib wrapper. Same on every OS. The agent's default entry point.

### `search` — find all matches of a pattern

```bash
python3 scripts/ast_grep_helper.py search 'console.log($MSG)' --lang ts src/
```

Validates the pattern offline first. If the pattern looks like regex (`\w`, `.*`, `|`, etc.) the helper exits with a hint and never calls `sg` — saves a round-trip. Pass `--force` to skip validation.

Flags:
- `--lang ts` (or any of the 25 languages; aliases like `js`, `py`, `rs`, `kt` accepted)
- `--globs '!**/*.test.ts'` (repeatable; prefix `!` to exclude)
- `-C 3` (context lines)
- `--json-out` (raw JSON instead of human format)

### `replace` — rewrite by pattern, dry-run by default

```bash
# Dry-run preview (default — no files mutated)
python3 scripts/ast_grep_helper.py replace 'console.log($MSG)' 'logger.info($MSG)' --lang ts src/

# Actually apply
python3 scripts/ast_grep_helper.py replace 'console.log($MSG)' 'logger.info($MSG)' --lang ts src/ --apply
```

The helper:
1. Validates both `pattern` and `rewrite` for hint-detectable mistakes.
2. Runs pass 1 with `--json=compact` to collect matches and show a preview.
3. If `--apply` is set, runs pass 2 with `--update-all` to mutate files.

### `scan` — run YAML rules

```bash
# Discover sgconfig.yml from cwd and run all rules
python3 scripts/ast_grep_helper.py scan src/

# Run a single rule file
python3 scripts/ast_grep_helper.py scan -r rules/no-console.yml src/

# Apply auto-fixes
python3 scripts/ast_grep_helper.py scan -U src/

# CI-friendly GitHub annotations
python3 scripts/ast_grep_helper.py scan --report-style short src/
```

### `validate` — offline pattern check (no `sg` call)

Useful for CI lints, pre-commit hooks, and quick sanity checks:

```bash
python3 scripts/ast_grep_helper.py validate '\w+' --lang ts
# → exit 2: regex \w not supported. Use $VAR for identifiers.

python3 scripts/ast_grep_helper.py validate 'console.log($MSG)' --lang ts
# → exit 0: pattern looks plausible for ast-grep.
```

### `langs` / `doctor` / `install`

```bash
python3 scripts/ast_grep_helper.py langs       # list 25 supported languages and aliases
python3 scripts/ast_grep_helper.py doctor      # check ast-grep binary availability
python3 scripts/ast_grep_helper.py install     # delegate to install.sh / install.ps1
```

`new` and `test` subcommands proxy directly to `sg new` and `sg test`.

---

## Direct `sg` use (when the helper isn't enough)

The helper is opinionated. For full control, drop to `sg`. The skill ships a CLI cheat sheet in `references/cli.md`. The minimal idioms:

```bash
# Search
sg run -p 'console.log($MSG)' --lang ts src/

# Search with JSON for scripting
sg run -p 'console.log($MSG)' --lang ts --json=compact src/ | jq '.[] | .file'

# Rewrite, dry-run
sg run -p 'console.log($MSG)' -r 'logger.info($MSG)' --lang ts --json=compact src/

# Rewrite, apply
sg run -p 'console.log($MSG)' -r 'logger.info($MSG)' --lang ts --update-all src/

# Pattern from stdin (great for ad-hoc experiments)
echo 'console.log("hi")' | sg run -p 'console.log($MSG)' --lang js --stdin

# Debug a pattern that returns 0 matches
sg run -p '<your pattern>' --lang <lang> --debug-query=ast --stdin <<< '<sample-code>'

# Run YAML rules
sg scan src/

# Inline YAML rule (one-off)
sg scan --inline-rules '
id: no-todo
language: TypeScript
severity: warning
rule: { pattern: TODO }' src/
```

When using `sg` directly in a shell, **always single-quote patterns** so `$VAR` is not expanded by the shell.

---

## Decision tree — what to use, when

```
USER asks for "find/rewrite/codemod"
│
├─ structural pattern (function shape, call, class, import, control flow)
│  └→ ast-grep (this skill)
│
├─ text pattern (regex, alternation, character classes, file names)
│  └→ rg / grep
│
├─ semantic question (what variable does this refer to? does this throw?)
│  └→ LSP tools, TypeScript compiler, Pyright, Semgrep with type inference
│
└─ multiple repos / federated search
   └→ a search engine + then ast-grep / rg / LSP per-repo
```

If the user says "find all" or "every", default to ast-grep when the target is shaped (function, class, call, import, statement). Default to rg when the target is text (string content, comment, license header, file name, identifier substring).

---

## Always run dry-run first when rewriting

A bad pattern silently rewrites the wrong thing. The helper's `replace` defaults to dry-run for this reason. The flow is:

1. Search to confirm matches: `helper search '<pattern>' --lang X .`
2. Dry-run rewrite: `helper replace '<pattern>' '<rewrite>' --lang X .` (no `--apply`)
3. Inspect the dry-run summary: number of matches, files affected, the per-location preview.
4. If wrong: refine pattern, go back to step 1.
5. If right: `helper replace '<pattern>' '<rewrite>' --lang X . --apply`.

Never apply a rewrite that you have not first dry-run.

---

## When `sg` returns 0 matches but you know the code is there

In priority order:

1. **Run `helper validate '<pattern>' --lang <lang>`** — catches regex misuse, missing function bodies, Python trailing colons.
2. **Check `--lang`** — `sg` infers from extension; if you pass a `.tsx` file with `--lang ts` (not `tsx`), JSX won't parse.
3. **Inspect the parsed pattern**: `sg run -p '<pattern>' --lang <lang> --debug-query=ast --stdin <<< '<sample>'`. If it shows `ERROR` nodes, the pattern is malformed.
4. **Check the AST of the target file**: `sg run -p '$_' --lang <lang> --debug-query=cst path/to/file | head -40` — find the `kind` you're trying to match.
5. **Try the playground**: <https://ast-grep.github.io/playground.html> — paste code + pattern, see what's happening.

Do not blindly retry with variations. Each failure has a reason; surface it.

---

## When to use YAML rules vs inline `-p` patterns

**Use inline `-p`** when:
- One-off ad-hoc query.
- The pattern is simple (no constraints, no fix template).
- You're exploring.

**Use YAML rules** (file under `rules/`, run via `sg scan`) when:
- The pattern is reused (lint rule, codemod that runs in CI).
- You need `constraints`, `transform`, complex `inside`/`has`, or composite logic.
- You want auto-fix (`fix:` field).
- You want to test the rule (snapshot tests via `sg test`).

The full YAML rule schema is in `references/yaml-rules.md`. Project setup (`sgconfig.yml`, `ruleDirs`, `utilDirs`) is in `references/sgconfig.md`.

---

## Output discipline

- `sg run --json=compact` produces an array of match objects: `{ file, range: {start, end}, text, replacement?, lines, language, ... }`. Pipe through `jq` for further processing.
- Without `--json`, `sg` produces human-readable colored output suitable for terminals.
- The helper's default output is human-readable (file:line:column + match preview). Pass `--json-out` for raw JSON.
- The helper's `replace` always summarizes: number of matches, number of files, per-location preview.

When summarizing for the user, **always include the count of files affected**, not just the count of matches. Users care about blast radius.

---

## Required reading (in order of priority)

1. `references/patterns.md` — meta-variables, naming rules, strictness levels. Read when you're unsure why a pattern doesn't match.
2. `references/pitfalls.md` — the failure-mode field guide. Read when 0 matches surprises you.
3. `references/recipes.md` — copy-paste patterns by language. Read first when you start a new task.
4. `references/cli.md` — `sg run`, `sg scan`, `sg test`, `sg new`, `sg lsp`. Read when the helper isn't enough.
5. `references/yaml-rules.md` — YAML rule schema. Read when you outgrow inline patterns.
6. `references/sgconfig.md` — project-level configuration. Read when you set up `sg scan` for a real project.
7. `references/install.md` — per-OS install methods. Read only if `install.sh` / `install.ps1` fail.

---

## Invariants (do not break)

- **Validate before searching.** When emitting a pattern programmatically, call `helper validate` first. It catches the regex-misuse class of mistakes that account for ~70% of "0 matches" debug sessions.
- **Dry-run before applying.** Never run `sg run -r ... --update-all` without first inspecting the matches. The helper's `replace` enforces this by default.
- **Two-pass writes.** When using `sg` directly to both preview and apply, run two invocations — `--json` ignores `--update-all`.
- **Single-quote patterns in shell.** `'$VAR'` not `"$VAR"`. The shell expands `$VAR` to the empty string in double quotes, breaking the pattern.
- **Pattern is code, not regex.** When the pattern would need `|`, `.*`, `\w`, or `[a-z]`, switch to `rg` instead. Don't try to force ast-grep into a regex shape.
- **`--lang` is required for stdin.** When piping with `--stdin`, set `--lang` explicitly; `sg` cannot infer from extension.
- **Linux: prefer `ast-grep` over `sg`** because `sg` collides with `setgroups`. The helper handles this; if you call `sg` directly, alias it: `alias sg=ast-grep`.
