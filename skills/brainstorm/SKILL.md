---
name: brainstorm
description: "[LazyGrok] OmO-power explore-first brainstorming for LazyGrok. MUST USE before creative work when requirements are fuzzy, multiple approaches compete, or the user says brainstorm / interview me / figure out what to build / explore options. Grounds in the codebase, fans out parallel adversarial lenses (skeptic/validator/researcher/architect/creative), runs Metis gap analysis, interviews only for owner-forks, and writes a decision-ready requirements brief under .omo/brainstorms/ — never product code. More rigorous than lightweight CE brainstorm. Triggers: brainstorm, brainstorming, /brainstorm, interview me, explore options, figure out what to build, what should we build, requirements before plan, design dialogue, ideation with rigor. LazyGrok commands: /lg-brainstorm, /brainstorm."
metadata:
  short-description: OmO explore-first brainstorm → .omo/brainstorms/
---

## Grok Harness Tool Compatibility

Use `spawn_subagent` + `get_command_or_subagent_output` only. Role map: explorer→`lg-explorer`, librarian→`lg-librarian`, metis→`lg-metis`, plan→`lg-plan`, momus→`lg-momus`. See plugin `references/grok-tool-map.md`.

# Brainstorm (OmO-power, LazyGrok)

You are running **OmO-style brainstorming** — the powerful pre-plan dialogue that LazyCodex/OmO express through Prometheus explore-first + Metis + adversarial pressure, not a casual chat.

**First line when this skill loads:** `BRAINSTORM MODE ENABLED!`

## What this is / is not

| This IS | This is NOT |
| --- | --- |
| Explore-first requirements synthesis | Jumping to implementation |
| Parallel adversarial option attack | One-shot vibe list of ideas |
| Owner-fork interview only | Dumping 20 questions the repo can answer |
| Durable artifact under `.omo/brainstorms/` | Chat-only throwaway notes |
| Handoff into `/ulw-plan` or `/hyperplan` | Replacing `/start-work` execution |

**Never edit product code.** Never pretend a brainstorm brief is an executable plan.

## Relationship to other LazyGrok commands

```
/brainstorm  →  requirements + options + decisions brief  (.omo/brainstorms/)
     ↓ user ok
/ulw-plan    →  decision-complete work plan                (.omo/plans/)
     ↓ user ok
/start-work  →  workers implement
```

- Use **`/hyperplan`** instead when the user wants maximum adversarial multi-agent combat before planning (heavier than brainstorm).
- Use **`/ulw-plan`** directly when the outcome is already clear and they only need a worker plan.
- Use **`/ulw-research`** when the ask is pure research, not product direction.

## Phase loop (do not skip)

### Phase 0 — Acknowledge + slug

1. Say `BRAINSTORM MODE ENABLED!`
2. Restate the request in one sentence.
3. Pick a slug: lowercase, digits, hyphens (`auth-multi-tenant`).
4. Create todos for Phases 1–6.

### Phase 1 — Ground in reality (parallel)

In **one turn**, spawn:

| Role | `subagent_type` | Mission |
| --- | --- | --- |
| Explorer | `lg-explorer` | How does related code work today? Paths, patterns, tests, constraints |
| Librarian | `lg-librarian` | External docs / OSS patterns / prior art for this problem class |
| Metis | `lg-metis` | Gaps, contradictions, unstated assumptions in the user brief |

Each child prompt:

```
TASK: …
ROLE: lg-*
DELIVERABLE: numbered findings with file:line or URL citations
SCOPE: …
VERIFY: parent can open cited paths
```

`background: true` + `capability_mode: "read-only"` where available. Wait with `get_command_or_subagent_output`.

**Subagent outputs are CLAIMS until you verify** critical paths yourself with `read_file` / `grep`.

### Phase 2 — Intent routing (announce once)

Announce one line:

> Intent: **CLEAR|UNCLEAR**, brainstorm depth: **standard|adversarial**

- **CLEAR** — outcome known; open items are owner preferences/tradeoffs.
- **UNCLEAR** — fuzzy outcome ("make X better"); research + adopt announced best-practice defaults; do not dump interview load on the user.
- Explicit "interview me" / "ask me" → CLEAR interview path; ask surviving forks.
- If user said "high accuracy" / "adversarial" / "hyperplan-style" → depth **adversarial** (Phase 3 full lenses). Else **standard** (Phase 3 light: skeptic + architect only).

### Phase 3 — Adversarial option lenses

Spawn parallel `general-purpose` (or `lg-worker` with read-only prompts) members. Parent brokers — no OpenCode `team_*`.

| Lens | Attack vector |
| --- | --- |
| **skeptic** | Over-engineering, scope creep, delete-this pressure |
| **validator** | Edge cases, blast radius, failure modes |
| **researcher** | Unfounded claims — demand evidence |
| **architect** | Coupling, leaky abstractions, simplest sound shape |
| **creative** | Reframe problem; ≥2 non-obvious alternatives |

**Standard depth:** skeptic + architect (+ creative if UNCLEAR).  
**Adversarial depth:** all five, then a second round where each attacks the others' top findings (you paste a findings bundle into each re-spawn).

Filter to **survivors only** (uncontested, defended, or refined). Drop conceded fluff.

### Phase 4 — Owner-fork interview (only if needed)

Two filters on every candidate question:

1. Could evidence answer it? → research instead.
2. Could intent + a defensible default answer it? → adopt default, **announce it**, do not ask — unless irreversible / product-surface / data-schema / safety (owner-decision → always ask).

Prefer `ask_user_question` for multi-choice forks. Batch questions. Never re-ask after answered.

### Phase 5 — Write the brief

Write **one** durable file:

```
.omo/brainstorms/<slug>.md
```

Scaffold:

```markdown
# Brainstorm: <title>

- slug: <slug>
- intent: clear|unclear
- depth: standard|adversarial
- status: ready-for-plan|awaiting-user
- updated: <ISO-8601>

## Problem (one paragraph)

## Users / context

## Constraints (hard)

## Decisions (converged)

## Defaults adopted (and why)

## Options considered

| Option | Pros | Cons | Verdict |
| --- | --- | --- | --- |

## Risks & mitigations

## Open questions (owner only)

## Must-NOT-Have

## Recommended next step

- [ ] `/ulw-plan <slug>` using this brief as input
- [ ] `/hyperplan` if user wants heavier adversarial combat
```

Also keep a resume stub at `.omo/drafts/brainstorm-<slug>.md` with status + decisions if the session may compact.

### Phase 6 — Approval + handoff

1. Present a short human summary (not the whole file).
2. Ask explicitly: **approve brief → plan**, **revise**, or **stop**.
3. On approve: tell user to run `/ulw-plan` with the brainstorm path, **or** load `ulw-plan` yourself **only if** they said "plan it now" in the same turn — still **no product code**.
4. Stop. Do not implement.

## Stop rules

- Brief exists, grounded in verified repo facts, options attacked, owner forks resolved or listed → done.
- Awaiting user on owner-forks → wait.
- User said "just build it" during brainstorm → remind sticky: brainstorm/plan first unless they explicitly cancel brainstorm and demand `/ulw` ship mode.

## Anti-patterns

| Don't | Why |
| --- | --- |
| Brainstorm without opening the repo | OmO forbids plan-blind work |
| 15 vague questions | Explore-first; questions are expensive |
| Ship code from brainstorm | Wrong phase |
| One-option "brainstorm" | Must surface ≥2 real options when UNCLEAR |
| Soft adversarial lenses | Hostility is the filter |
| Confuse brief with `.omo/plans/` plan | Plans need todos + QA + acceptance |

## What to do right now

1. `BRAINSTORM MODE ENABLED!`
2. Phase 1 parallel explore/librarian/metis.
3. Route intent; run lenses; interview only owner-forks.
4. Write `.omo/brainstorms/<slug>.md`.
5. Offer `/ulw-plan` handoff.
