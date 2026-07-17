# LazyGrok

**Full OmO / LazyCodex agent harness for [Grok Build](https://grok.com).**  
Same workflows — ultrawork, brainstorm, debugging, frontend, programming, plan→start-work, teammode, evidence gates — on **Grok models** instead of OpenAI Codex.

```bash
grok plugin install ~/Documents/GitHub/lazygrok --trust
# ensure "lazygrok" is in ~/.grok/config.toml [plugins].enabled
```

---

## How to use

### Core workflow

| Command | What it does |
| --- | --- |
| `/brainstorm` | OmO-power explore-first requirements → `.omo/brainstorms/` |
| `/ulw-plan` | Prometheus decision-complete plan → `.omo/plans/` |
| `/start-work` | Orchestrate plan; workers implement |
| `/ulw` | Evidence-driven ship mode |
| `/ulw-loop` | Durable loop until completion promise |
| `/ulw-research` | Max-saturation research |
| `/debug` | OmO hypothesis-driven debugging |
| `/hyperplan` | Adversarial multi-agent planning |
| `/init-deep` | Hierarchical `AGENTS.md` memory |

### Specialist skills (also slash-callable)

| Command | Domain |
| --- | --- |
| `/frontend` | UI/UX design router + brand refs + Lighthouse path |
| `/programming` | Strict TS / Python / Rust / Go discipline + TDD |
| `/visual-qa` | Screenshot / TUI visual QA |
| `/ast-grep` | Structural search & rewrite |
| `/refactor` | Behavior-preserving restructure |
| `/git-master` | Atomic commits / history archaeology |
| `/review-work` | Multi-lane post-implementation review |
| `/remove-ai-slops` | AI-slop cleanup with regression locks |
| `/ultimate-browsing` | Hard web / WAF / stealth browsing |
| `/coding-agent-sessions` · `/sessions` | Local agent session search (incl. Grok) |
| `/lsp` · `/lsp-setup` | Language servers / diagnostics |
| `/teammode` | Named multi-agent teams (`.omo/teams/`) |
| `/rules` | Project rules / AGENTS.md sources |

### Typical flows

```text
/brainstorm multi-tenant auth   →  /ulw-plan  →  /start-work
/debug empty 200 on checkout
/frontend redesign settings page
/programming + /ulw implement rate limiter with TDD
/teammode split API + web for feature X
```

State: **`.omo/`** (plans, drafts, brainstorms, teams, ulw-loop, research).

---

## Agents (`lg-*`)

`lg-explorer` · `lg-librarian` · `lg-worker` · `lg-worker-high` · `lg-plan` · `lg-metis` · `lg-momus` · `lg-code-reviewer` · `lg-gate-reviewer`

See [docs/models.md](docs/models.md) and [references/grok-tool-map.md](references/grok-tool-map.md).

---

## Skill inventory (v0.3 — full port)

| Family | Status |
| --- | --- |
| ultrawork, ulw-plan (+ refs/scaffold), ulw-loop, ulw-research, start-work | full |
| debugging (+ methodology/runtimes/tools) | full |
| brainstorm, hyperplan | full (Grok-adapted) |
| review-work, remove-ai-slops, init-deep, refactor, git-master | full |
| frontend (+ design brand refs) | full |
| programming (+ language refs) | full |
| visual-qa, ast-grep, ultimate-browsing | full |
| coding-agent-sessions (+ Grok ref) | full |
| lsp, lsp-setup, rules | full (Grok-adapted; no Codex LSP MCP assumed) |
| teammode | full (spawn_subagent transport; `.omo/teams` scripts) |
| comment-checker | full |

Tool names rewritten for Grok (`spawn_subagent`, not Codex `multi_agent_v1` / OpenCode `team_*`).

---

## Install / verify

```bash
grok plugin install ~/Documents/GitHub/lazygrok --trust
grok plugin list
grok plugin details lazygrok
```

```toml
[plugins]
enabled = [..., "lazygrok"]
```

After skill updates, reinstall (or restart Grok) so `~/.grok/installed-plugins/lazygrok-*` refreshes.

---

## Inspirations

Adapted from **[oh-my-openagent (OmO)](https://github.com/code-yeongyu/oh-my-openagent)** and **[LazyCodex](https://github.com/code-yeongyu/lazycodex)**.  
Independent Grok Build port. See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md). MIT — [LICENSE](LICENSE).
