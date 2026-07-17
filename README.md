# LazyGrok

**OmO / LazyCodex workflows for [Grok Build](https://grok.com).**  
Ultrawork, ultraresearch, plan → start-work, evidence gates, and role agents — on **Grok** instead of OpenAI Codex.

```bash
grok plugin install mitchellbernstein/lazygrok --trust
```

Then enable it (Grok plugins are off until listed in `enabled`), restart a session, and type **`/lg-ulw`**.

---

## What this is

| Piece | Role |
| --- | --- |
| **OmO** ([oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)) | The agent harness playbook (skills, loops, discipline) |
| **LazyCodex** ([lazycodex](https://github.com/code-yeongyu/lazycodex)) | OmO packaged for **Codex CLI** (`npx lazycodex-ai install`) |
| **LazyGrok** (this repo) | Same ideas packaged for **Grok Build** — one repo, one install |

You do **not** need OmO or LazyCodex installed to use LazyGrok. Those are inspirations only.

---

## Install

### Prerequisites

- [Grok Build](https://grok.com) CLI (`grok` on your `PATH`)
- A Grok account / API auth already working (`grok` opens a session)

### One-liner (recommended)

```bash
grok plugin install mitchellbernstein/lazygrok --trust
```

Same install via full URL:

```bash
grok plugin install https://github.com/mitchellbernstein/lazygrok.git --trust
```

Pin a version if you want a fixed ref:

```bash
grok plugin install mitchellbernstein/lazygrok@v0.3.1 --trust
```

`--trust` is required for a non-interactive install. Without it, Grok prints a warning and stops (hooks / skills only load after trust).

### Enable the plugin

Grok discovers plugins but **does not load them until they are enabled**. Add `lazygrok` to `~/.grok/config.toml`:

```toml
[plugins]
enabled = [
  # ...any plugins you already use...
  "lazygrok",
]
```

Or from the CLI:

```bash
grok plugin enable lazygrok
```

### Verify

```bash
grok plugin list
grok plugin details lazygrok
```

You should see skills, commands, agents, and hooks. **Restart the Grok session** so `/lg-*` slash commands show up in the picker.

Inside a session you can also open `/plugins` and `/skills`.

### Upgrade

```bash
grok plugin update lazygrok
# or reinstall from GitHub:
grok plugin uninstall lazygrok --confirm
grok plugin install mitchellbernstein/lazygrok --trust
```

Restart the session after upgrades.

### Uninstall

```bash
grok plugin uninstall lazygrok --confirm
```

Remove `"lazygrok"` from `[plugins].enabled` if you added it by hand.

### Local clone (maintainers / contributors)

```bash
git clone https://github.com/mitchellbernstein/lazygrok.git
cd lazygrok
grok plugin install . --trust
# or: grok plugin install /absolute/path/to/lazygrok --trust
```

Useful when hacking on skills; public users should prefer the GitHub one-liner so they get updates via `grok plugin update`.

---

## First run

Same shape as LazyCodex — just `/lg-*` instead of `$…`:

```text
/lg-init-deep
/lg-ulw-plan "what you want to build"
/lg-start-work
```

Or go straight to evidence-driven ship mode:

```text
/lg-ulw fix the payment flow and prove it with a real request
```

Stuck on a bug:

```text
/lg-debug empty 200 on checkout
```

State lives under **`.omo/`** in the project (plans, brainstorms, teams, ulw-loop, research).

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
| **`/lg-rules`** | `/rules` | Project rules / `AGENTS.md` |

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

## FAQ

**Is install as easy as LazyCodex?**  
Almost. LazyCodex is `npx lazycodex-ai install`. LazyGrok is one Grok CLI line: `grok plugin install mitchellbernstein/lazygrok --trust`. Then enable + restart. No npm, no marketplace ceremony.

**Do I need Codex or LazyCodex?**  
No. LazyGrok is standalone for Grok Build.

**Where does project state go?**  
`.omo/` in the repo you are working in (gitignored by this plugin’s conventions; add it to your project `.gitignore` if needed).

**How do I contribute?**  
Clone, edit under `skills/`, `commands/`, `agents/`, validate with `grok plugin validate .`, reinstall from the local path, open a PR on this repo.

---

## License

MIT — adapted from OmO / LazyCodex. See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

**Repo:** [github.com/mitchellbernstein/lazygrok](https://github.com/mitchellbernstein/lazygrok)
