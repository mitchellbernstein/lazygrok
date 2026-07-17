# LazyGrok

**OmO / LazyCodex workflows for [Grok Build](https://grok.com).**  
Ultrawork, brainstorm, debugging, hyperplan, plan → start-work, evidence gates, and role agents — on **Grok models** instead of OpenAI Codex.

```bash
grok plugin install ~/Documents/GitHub/lazygrok --trust
# ensure lazygrok is in ~/.grok/config.toml [plugins].enabled
```

---

## How to use (type these)

### Command pillars

| Command | What it does |
| --- | --- |
| `/brainstorm` | OmO-power explore-first requirements → `.omo/brainstorms/` |
| `/ulw-plan` | Prometheus decision-complete plan → `.omo/plans/` |
| `/start-work` | Orchestrate plan; workers implement; gate verifies |
| `/ulw` · ultrawork | Evidence-driven ship mode (RED→GREEN + real-surface proof) |
| `/ulw-loop` | Durable loop until completion promise |
| `/ulw-research` | Max-saturation research swarm |
| `/debug` | OmO hypothesis-driven debugging (+ full `references/`) |
| `/hyperplan` | Adversarial multi-agent planning (5-lens combat) |
| `/init-deep` | Hierarchical `AGENTS.md` memory |
| `/review-work` | Multi-lane post-implementation review |
| `/remove-ai-slops` | Behavior-preserving AI-slop cleanup |
| `/refactor` | Behavior-preserving restructure |
| `/git-master` | Atomic commits / history investigation |

### Typical flows

**Fuzzy product idea**

```text
/brainstorm multi-tenant auth for the API
# approve brief →
/ulw-plan
# approve plan →
/start-work
```

**Clear feature, ship hard**

```text
/ulw add 5/min rate limit on /login and prove with a real request
```

**Bug**

```text
/debug API returns 200 but empty body on checkout
```

**Max-rigor planning**

```text
/hyperplan redesign billing webhooks
```

Natural language also works when the skill description matches (`debug this`, `brainstorm options`, `review my work`, `ulw: …`).

State lives under **`.omo/`** in the project (plans, drafts, brainstorms, boulder, ulw-loop, research).

---

## What this is

| Piece | Role |
| --- | --- |
| **OmO** ([oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)) | Agent harness playbook |
| **LazyCodex** ([lazycodex](https://github.com/code-yeongyu/lazycodex)) | OmO packaged for Codex CLI |
| **LazyGrok** (this repo) | Same workflows packaged for **Grok** |

You do **not** need OmO + LazyCodex installed to use LazyGrok.

---

## Agents (Grok roles)

| Agent | Job |
| --- | --- |
| `lg-explorer` | Codebase map (read-only) |
| `lg-librarian` | Docs / web / OSS (read-only) |
| `lg-worker` / `lg-worker-high` | Implementation |
| `lg-plan` · `lg-metis` · `lg-momus` | Plan / gaps / plan review |
| `lg-code-reviewer` · `lg-gate-reviewer` | Review + final gate |

See [docs/models.md](docs/models.md) and [references/grok-tool-map.md](references/grok-tool-map.md).

---

## Install / verify

```bash
grok plugin install ~/Documents/GitHub/lazygrok --trust
grok plugin list
grok plugin details lazygrok
```

```toml
# ~/.grok/config.toml
[plugins]
enabled = [..., "lazygrok"]
```

Uninstall: `grok plugin uninstall lazygrok --confirm`

---

## Skill inventory (v0.2)

| Ported from OmO/LazyCodex | Status |
| --- | --- |
| ultrawork, ulw-plan (+ refs + scaffold), ulw-loop, ulw-research, start-work | yes |
| debugging (+ full methodology/runtimes/tools refs) | yes |
| brainstorm (OmO explore + adversarial lenses; LazyGrok command) | yes |
| hyperplan (Grok `spawn_subagent` adaptation) | yes |
| review-work, remove-ai-slops, init-deep, refactor, git-master | yes |
| frontend, programming, visual-qa, ast-grep, ultimate-browsing, teammode | not yet |

Tool names are rewritten for Grok (`spawn_subagent`, not Codex `multi_agent_v1` / OpenCode `team_*`).

---

## Inspirations (credit)

Heavily adapted from **oh-my-openagent (OmO)** and **LazyCodex** by code-yeongyu / Sisyphus Labs.  
Independent port for Grok Build. Not affiliated with OpenAI or xAI. See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

MIT — see [LICENSE](LICENSE).
