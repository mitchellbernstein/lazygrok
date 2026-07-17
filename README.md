# LazyGrok

**OmO / LazyCodex harness for [Grok Build](https://grok.com)** — namespaced as **`/lg-*`** so it is obvious what is LazyGrok vs GSD, compound-engineering (`ce-*`), or other plugins.

```bash
grok plugin install ~/Documents/GitHub/lazygrok --trust
# enable "lazygrok" in ~/.grok/config.toml [plugins].enabled
```

---

## Command prefix: `/lg-*` (preferred)

| Prefer (LazyGrok) | Bare alias (still works) | What it does |
| --- | --- | --- |
| **`/lg-ulw`** · `/lg-ultrawork` | `/ulw` | Evidence-driven ship mode |
| **`/lg-ulw-plan`** | `/ulw-plan` | Prometheus plan → `.omo/plans/` |
| **`/lg-start-work`** | `/start-work` | Execute plan (orchestrator + workers) |
| **`/lg-ulw-loop`** | `/ulw-loop` | Durable loop until evidence |
| **`/lg-ulw-research`** | `/ulw-research` | Max-saturation research |
| **`/lg-init-deep`** | `/init-deep` | Hierarchical `AGENTS.md` memory |
| **`/lg-brainstorm`** | `/brainstorm` | OmO-power brainstorm → `.omo/brainstorms/` |
| **`/lg-hyperplan`** | `/hyperplan` | Adversarial multi-agent planning |
| **`/lg-debug`** | `/debug` | OmO hypothesis-driven debugging |
| **`/lg-review-work`** | `/review-work` | Multi-lane post-impl review |
| **`/lg-remove-ai-slops`** | `/remove-ai-slops` | AI-slop cleanup |
| **`/lg-refactor`** | `/refactor` | Behavior-preserving restructure |
| **`/lg-git-master`** | `/git-master` | Commits & git history |
| **`/lg-frontend`** | `/frontend` | UI/UX design router |
| **`/lg-programming`** | `/programming` | Strict TS/Python/Rust/Go |
| **`/lg-visual-qa`** | `/visual-qa` | Screenshot / TUI QA |
| **`/lg-ast-grep`** | `/ast-grep` | Structural search/rewrite |
| **`/lg-ultimate-browsing`** | `/ultimate-browsing` | Hard web / WAF access |
| **`/lg-sessions`** · `/lg-coding-agent-sessions` | `/sessions` | Agent session archaeology |
| **`/lg-lsp`** · `/lg-lsp-setup` | `/lsp` · `/lsp-setup` | Language servers |
| **`/lg-teammode`** | `/teammode` | Named multi-agent teams |
| **`/lg-rules`** | `/rules` | Project rules / AGENTS.md |

Slash descriptions are tagged **`[LazyGrok]`** so they stand out in the command picker next to GSD / `ce-*` / other plugins.

Natural language still works (`ulw: …`, `debug this`) via skill descriptions that list both `/lg-*` and bare triggers.

### Typical flow

```text
/lg-brainstorm multi-tenant auth
/lg-ulw-plan
/lg-start-work

/lg-debug empty 200 on checkout
/lg-ulw add rate limit and prove with a real request
```

State: **`.omo/`** in the project (plans, drafts, brainstorms, teams, ulw-loop).

---

## Agents (already `lg-*`)

| Agent | Job |
| --- | --- |
| `lg-explorer` | Codebase map (read-only) |
| `lg-librarian` | Docs / web / OSS (read-only) |
| `lg-worker` · `lg-worker-high` | Implementation |
| `lg-plan` · `lg-metis` · `lg-momus` | Plan / gaps / plan review |
| `lg-code-reviewer` · `lg-gate-reviewer` | Review + final gate |

See [docs/models.md](docs/models.md) and [references/grok-tool-map.md](references/grok-tool-map.md).

---

## Skills (28) + aliases

Full OmO/LazyCodex surface: ultrawork, ulw-plan, start-work, ulw-loop, ulw-research, init-deep, brainstorm, hyperplan, debugging, review-work, remove-ai-slops, comment-checker, refactor, git-master, programming, frontend, visual-qa, ast-grep, ultimate-browsing, coding-agent-sessions, lsp, lsp-setup, rules, teammode (+ thin aliases `ulw`, `debug`, `sessions`, `ultraresearch`).

---

## Not LazyGrok (other plugins)

| Prefix / style | Plugin |
| --- | --- |
| `ce-*` | compound-engineering |
| GSD / get-shit-done style commands | that plugin (not this repo) |
| Cursor `brainstorming`, etc. | Cursor skills |

If it does **not** start with `/lg-` (or the documented bare OmO alias), it is **not** LazyGrok.

---

## Install

```bash
grok plugin uninstall lazygrok --confirm   # if upgrading
grok plugin install ~/Documents/GitHub/lazygrok --trust
grok plugin details lazygrok
```

Restart the Grok session so `/lg-*` commands appear.

MIT — adapted from OmO / LazyCodex. See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
