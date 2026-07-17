# Grok tool map (LazyGrok)

Use these tools. Never call Codex `multi_agent_v1.*` or OpenCode `call_omo_agent` / `team_*`.

| Intent | Grok tool |
| --- | --- |
| Spawn worker | `spawn_subagent` — `subagent_type` = plugin agent name (`lg-explorer`, `lg-librarian`, `lg-plan`, `lg-worker`, `lg-worker-high`, `lg-gate-reviewer`, `lg-code-reviewer`, `lg-metis`, `lg-momus`) or built-in `explore` / `plan` / `general-purpose` |
| Background spawn | `spawn_subagent` with `background: true` |
| Wait / read result | `get_command_or_subagent_output` |
| Isolation | `isolation: "worktree"` when editing in parallel safely |
| Capability | `capability_mode`: `read-only` for explore/librarian/reviewers |
| Shell | `run_terminal_command` |
| Read / search | `read_file`, `grep`, `list_dir` |
| Edit | `search_replace` (or write tool if available) |
| Todos | `todo_write` |
| Goals | `update_goal` when available; else a `# Goal` block in the notepad |
| Web | `web_search`, `web_fetch` / `open_page` |

## Spawn message contract

Every child prompt starts with:

```
TASK: <imperative assignment>
ROLE: <lg-*>
DELIVERABLE: <what to return>
SCOPE: <paths / limits>
VERIFY: <how parent checks>
```

Self-contained. No reliance on parent history unless you intentionally pass context in the prompt.

## Model roles (effort on grok-4.5; optional composer for cheap digs)

| Role | Effort | Notes |
| --- | --- | --- |
| lg-explorer, lg-librarian | low | Fast map / docs |
| lg-worker | medium | Default impl |
| lg-worker-high, lg-executor | high | Hard impl |
| lg-plan, lg-metis, lg-momus, lg-gate-reviewer, lg-code-reviewer | high | Plan & gates |

Parent may override with skill `model` / `effort` frontmatter when the host supports it.
