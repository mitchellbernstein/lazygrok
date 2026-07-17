---
name: ulw-loop
description: "[LazyGrok] Goal-like loop that uses ultrawork mode to decompose work into systematic, evidence-bound steps. LazyGrok commands: /lg-ulw-loop."
metadata:
  short-description: Goal-like ultrawork loop for systematic decomposition
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

# ulw-loop

Use this skill when the user asks for `ulw-loop`, `ulw`, durable goal execution, evidence-led work, manual QA, or checkpointed long-running delivery.

This skill is intentionally compact. The full workflow lives in `references/full-workflow.md`. Read only the sections needed for the current phase, then execute them exactly.

## Required First Steps

1. Open `references/full-workflow.md`.
2. Read through **Bootstrap** (including its tier triage), **Execution Loop**, the **Manual-QA channels** table, and the **Stop Rules** before running any ULW command or recording evidence.
3. If the task has code edits, tests, QA, or commit work, follow the full workflow's delegation and evidence rules. Tests alone never prove done.

## Non-Negotiables

- Use the ulw-loop CLI state under `.omo/ulw-loop`; do not hand-edit goal state.
- After any compaction or context loss, re-read brief + goals + ledger FIRST plus `omo ulw-loop status --json`, then resume; never re-plan from scratch.
- If `omo ulw-loop create-goals` says the existing aggregate is already complete, start unrelated new work with a fresh `--session-id <new-id>` instead of steering or forcing the completed default state. Use `--force` only to intentionally overwrite completed evidence.
- Every success criterion needs observable evidence from a real surface: a channel (terminal/TUI via the xterm.js web terminal, HTTP, browser, computer-use) or, for CLI- or data-shaped criteria, an auxiliary surface (CLI stdout, DB diff, parsed config dump).
- Evidence is bound to the tree it was captured at (`git rev-parse --short "HEAD^{tree}"`); it goes stale only when tracked content changes — a rebase or amend that keeps the tree identical keeps it valid. When the tree differs, re-run at the current HEAD and re-record, never relabel or regenerate. Record only after cleanup receipts exist.
- Delegate code edits, test writes, fixes, and QA execution to right-sized Codex subagents when the workflow requires it.
- Every `spawn_agent` message starts with `TASK:`, then names `DELIVERABLE`, `SCOPE`, and `VERIFY`; put role and specialty instructions inside `message`; use `fork_turns: "none"` (v1: `background: true  # no parent history; self-contained prompt`) unless full history is truly required.
- Plan and reviewer agents may run for a long time; spawn them in the background and keep doing independent root work. Between `wait_agent` calls, back off — double the timeout up to ~5 minutes — instead of spinning short cycles.
- For work likely to exceed one wait cycle, require the child to send `WORKING: <task> - <current phase>` before long reading, testing, or review passes, and `BLOCKED: <reason>` only when it cannot progress.
- Track spawned agent names locally. Use `wait_agent` for mailbox signals, not proof of completion. A timeout only means no new mailbox update arrived. Treat a running child as alive.
- While children run, surface the active subagent count, agent names, and latest `WORKING:` phase.
- Fallback only when the child is completed without the deliverable, ack-only after `followup_task`, explicitly `BLOCKED:`, or no longer running. Then record inconclusive and respawn a smaller `fork_turns: "none"` task with the missing deliverable.
- Use `git-master` for git-tracked edits: inspect recent and touched-path commit history, then commit each verified work unit atomically in the repository's observed language, scope, and message style with only that unit's files staged.

## Codex Tool Mapping

Codex exposes ONE subagent surface per session — check your tool list. GPT-5.6 (sol/terra) get the flat MultiAgentV2 tools (primary); GPT-5.5 and gpt-5.6-luna get the namespaced `multi_agent_v1.*` set (fallback row). The workflow's orchestration examples map to:

| Intent | MultiAgentV2 (gpt-5.6 sol/terra) |
| --- | --- |
| Spawn a worker | `spawn_agent({"task_name":"<lower_snake_id>","message":"TASK: act as <role>. ...","fork_turns":"none"})` — `task_name`+`message` required; `fork_turns:"none"` = no parent history; do NOT set `agent_type`/`model`/`reasoning_effort` |
| Re-task an idle worker (wakes it) | `followup_task({"target":"<name>","message":"..."})` |
| Send context without interrupting | `send_message({"target":"<name>","message":"..."})` |
| Wait for a mailbox signal | `wait_agent({"timeout_ms":<ms>})` — any live worker; a timeout only means no new update |
| Enumerate / stop a runaway | `list_agents()` / `interrupt_agent({"target":"<name>"})` — no `close_agent`; finished workers end on their own |

V1 fallback (gpt-5.5, gpt-5.6-luna): `spawn_subagent({...,"background": true})`, `spawn_subagent  # re-prompt via resume_from if available` (re-task), `get_command_or_subagent_output({"targets":[...],"timeout_ms":...})`, `kill_command_or_subagent`.

When translating `load_skills=[...]`, include the requested skill names in the spawned agent's `message`.
