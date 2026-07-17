# LazyGrok

**OmO / LazyCodex workflows for [Grok Build](https://grok.com).**  
Ultrawork, ultraresearch, plan → start-work, evidence gates, and role agents — on **Grok models** instead of OpenAI Luna/Sol.

```bash
grok plugin install /path/to/lazygrok --trust
# enable in ~/.grok/config.toml [plugins].enabled if needed
```

Then in a session: `/ulw`, `/ulw-research`, `/ulw-plan`, `/start-work`, `/ulw-loop`, `/init-deep`.

---

## What this is

| Piece | Role |
| --- | --- |
| **OmO** ([oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)) | The agent harness playbook (skills, loops, discipline) |
| **LazyCodex** ([lazycodex](https://github.com/code-yeongyu/lazycodex)) | OmO packaged for **Codex CLI** |
| **LazyGrok** (this repo) | Same ideas packaged for **Grok** — one repo, one install |

You do **not** need OmO + LazyCodex installed to use LazyGrok. Those are inspirations (and local clones under `~/Documents/GitHub/` for maintainers).

---

## Commands (V0)

| Command | What it does |
| --- | --- |
| `/ulw` · `/ultrawork` | Evidence-driven ship mode (RED→GREEN + real-surface proof) |
| `/ulw-research` · ultraresearch | Max-saturation research swarm + cited synthesis |
| `/ulw-plan` | Plan only → `.omo/plans/` (Prometheus) |
| `/start-work` | Orchestrate plan; workers implement; gate verifies |
| `/ulw-loop` | Durable loop until completion promise |
| `/init-deep` | Hierarchical `AGENTS.md` memory |
| skills | `comment-checker`, `remove-ai-slops`, `review-work` |

State lives under **`.omo/`** in the project (plans, boulder, ledgers, research) — same spirit as LazyCodex.

---

## Agents (Grok roles)

| Agent | Job | Effort |
| --- | --- | --- |
| `lg-explorer` | Codebase map (read-only) | low |
| `lg-librarian` | Docs / web / OSS (read-only) | low |
| `lg-worker` | Default implementation | medium |
| `lg-worker-high` | Hard implementation | high |
| `lg-plan` · `lg-metis` · `lg-momus` | Plan / gaps / plan review | high |
| `lg-code-reviewer` · `lg-gate-reviewer` | Review + final gate | high |

Mapped from LazyCodex’s explorer/librarian/workers/plan/momus/gate stack. See [docs/models.md](docs/models.md).

---

## Install

```bash
# from this repo
grok plugin install . --trust

# or by path
grok plugin install ~/Documents/GitHub/lazygrok --trust
```

Enable if Grok leaves plugins disabled by default:

```toml
# ~/.grok/config.toml
[plugins]
enabled = ["lazygrok"]  # plus your other plugins
```

Verify:

```bash
grok plugin list
grok plugin details lazygrok
grok inspect   # skills + agents should show plugin: lazygrok
```

Uninstall: `grok plugin uninstall lazygrok --confirm`

---

## Inspirations (credit)

Heavily inspired by / adapted from:

- **[oh-my-openagent (OmO)](https://github.com/code-yeongyu/oh-my-openagent)** — ultrawork, ulw-research, plan/start-work, comment checker, discipline agents  
- **[LazyCodex](https://github.com/code-yeongyu/lazycodex)** — Codex distribution, install UX, agent role packaging  
- Name pattern: **LazyVim** for Neovim  

LazyGrok is an independent port for Grok Build. Not affiliated with Sisyphus Labs, OpenAI, or xAI. Workflow text is reimplemented for Grok’s plugin/skill/subagent APIs (no Codex `apply_patch` / `multi_agent_v1` hard-wiring).

---

## Layout

```
lazygrok/
├── .grok-plugin/plugin.json
├── skills/          # ultrawork, ulw-research, ulw-plan, start-work, …
├── agents/          # lg-* role agents
├── commands/        # /ulw, /ulw-research, …
├── hooks/           # session + keyword hints + post-edit nudge
├── scripts/         # scaffold-plan, prompt-mode-hint
├── references/      # Grok tool map
└── docs/models.md
```

---

## Status

**V0** — skill + agent + command parity for daily LazyCodex workflows on Grok.  
Not a full OmO Ultimate port (no OpenCode Team Mode, no hashline edit tool, no OpenAI multi-model matrix).

MIT — see [LICENSE](LICENSE) and [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
