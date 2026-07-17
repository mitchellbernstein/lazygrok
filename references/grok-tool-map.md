# Grok tool map (LazyGrok)

Use these tools. Never call Codex `multi_agent_v1.*`, OpenCode `call_omo_agent` / `team_*`, or invent missing host tools.

| Intent | Grok tool |
| --- | --- |
| Spawn worker | `spawn_subagent` — `subagent_type` = plugin agent (`lg-explorer`, `lg-librarian`, `lg-plan`, `lg-worker`, `lg-worker-high`, `lg-gate-reviewer`, `lg-code-reviewer`, `lg-metis`, `lg-momus`) or built-in `explore` / `plan` / `general-purpose` |
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
| User questions | `ask_user_question` when multi-choice forks help |

## Codex / OpenCode → Grok translation

| Source example | Use on Grok |
| --- | --- |
| `multi_agent_v1.spawn_agent({message, agent_type})` | `spawn_subagent({prompt: message, subagent_type: mapped_role, description: "…"})` |
| `multi_agent_v1.wait_agent` / `background_output` | `get_command_or_subagent_output` |
| `call_omo_agent(subagent_type=…)` | `spawn_subagent(subagent_type=…)` |
| `task(subagent_type=…)` | `spawn_subagent(subagent_type=…)` |
| `team_create` / `team_send_message` / `team_delete` | Parallel `spawn_subagent` waves; parent brokers context between rounds |
| `update_plan` | `todo_write` |
| `apply_patch` | `search_replace` / write |
| `codegraph_explore` | Prefer if present; else `grep` + `read_file` + `lg-explorer` |
| Codex `agent_type: explorer` | `lg-explorer` (or built-in `explore`) |
| `librarian` | `lg-librarian` |
| `plan` / Prometheus | `lg-plan` |
| `metis` / `momus` | `lg-metis` / `lg-momus` |
| `oracle` / gate reviewer | `lg-gate-reviewer` or `lg-code-reviewer` |
| `lazycodex-worker-low` / `medium` | `lg-worker` |
| `lazycodex-worker-high` | `lg-worker-high` |
| `sisyphus` (lead) | Main Grok session (you) |

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
| lg-worker-high | high | Hard impl |
| lg-plan, lg-metis, lg-momus, lg-gate-reviewer, lg-code-reviewer | high | Plan & gates |

Parent may override with skill `model` / `effort` frontmatter when the host supports it.

## Skill root path

When a skill says run `scripts/…` relative to the skill:

```
${GROK_PLUGIN_ROOT:-~/.grok/installed-plugins/<lazygrok-id>}/skills/<skill-name>/scripts/...
```

Or from the source checkout: `~/Documents/GitHub/lazygrok/skills/<skill-name>/scripts/...`
