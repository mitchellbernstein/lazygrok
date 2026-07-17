---
name: rules
description: "Use when the user asks about project rules, AGENTS.md, injected instructions, supported rule file locations, or how LazyGrok/Grok loads rules vs Codex Rules. Triggers: rules, AGENTS.md, project instructions, .cursor/rules, .omo/rules, CONTEXT.md."
---

# Project rules (LazyGrok / Grok)

On Grok Build, "rules" are **files the host injects** — not the Codex Rules plugin runtime. Still honor the same project sources OmO/LazyCodex supported.

## Supported project sources (read these)

| Path | Role |
| --- | --- |
| `AGENTS.md` | Primary Grok / multi-agent instructions (repo root and nested) |
| `CONTEXT.md` | Extra product/context brief |
| `.omo/rules/**/*.md` | OmO-style project rules |
| `.claude/rules/**/*.md` | Claude-compatible rules |
| `.cursor/rules/**/*.mdc` or `*.md` | Cursor file-scoped rules |
| `.github/instructions/**/*.md` | Copilot-style instructions |
| `.github/copilot-instructions.md` | Flat Copilot instructions |
| `CLAUDE.md` / `Agents.md` | Alternate instruction roots |

## How to apply

1. On session start or when the user asks "what rules apply", **list** matching files under the workspace and summarize in ≤15 lines.
2. Prefer **more specific nested `AGENTS.md`** over root when working in a subdirectory.
3. File-scoped `.mdc` rules: apply when editing matching globs from frontmatter.
4. Never invent rules that are not in those files.
5. If both Codex-oriented and Grok-oriented files conflict, prefer **explicit user instruction** > nested AGENTS > root AGENTS > other rule packs.

## Environment knobs (informational)

Codex plugin env vars (`CODEX_RULES_*`) do not control Grok. For LazyGrok:

- Follow host `AGENTS.md` injection.
- Plugin hooks may print LazyGrok mode hints; they do not replace project rules.

## What to do right now

If the user asked about rules: scan the paths above with `list_dir`/`grep`/`read_file` and report which apply to the current cwd/files.
