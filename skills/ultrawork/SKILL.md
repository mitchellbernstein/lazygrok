---
name: ultrawork
description: "Binding ultrawork mode for LazyGrok. Use when the user says ultrawork, ulw, /ulw, /ultrawork, or wants maximum-precision evidence-driven shipping. Overrides casual completion."
metadata:
  short-description: Evidence-driven ship mode
---

# ULTRAWORK (LazyGrok)

Read `references/grok-tool-map.md` at the plugin root for spawn/tool rules.

**MANDATORY first user-visible line this turn:**
`ULTRAWORK MODE ENABLED!`

[CODE RED] Outcome-first. Evidence-driven. No process narration.

## Goal

Deliver EXACTLY what the user asked, end-to-end, proven by:

1. Failing-first proof RED→GREEN through the cheapest faithful channel
2. Real-surface proof sized by tier below

**Tests alone never prove done.**

## Tier triage (once; ratchet up only)

Default **LIGHT**. Take **HEAVY** when the change set hits: new module/layer/domain model; auth/security/permissions; new external integration (API/queue/payment); DB schema/migration; concurrency/transactions/cache invalidation; cross-domain refactor; or user said carefully/thoroughly/design first.

- **LIGHT**: 1–2 success criteria; notepad plan; self-review; one real-surface proof
- **HEAVY**: 3+ criteria (happy, edge, regression); full reviewer gate via `lg-gate-reviewer`

## Bootstrap (all four before other work)

### 0. Discover

Survey loaded skills; name which apply. Fire first discovery wave **in parallel**: `grep`/`read_file` + spawn `lg-explorer` and/or `lg-librarian` when layout or external contracts are unfamiliar. Spawn `lg-plan` only if open design decisions remain **after** discovery returns.

### 1. Binding success criteria

Register a goal via `update_goal` when available; else open `# Goal` in the notepad as binding. Criteria list exact scenarios (literal command/action + binary PASS/FAIL) and WHEN TO STOP.

### 2. Durable notepad

```bash
NOTE=$(mktemp -t ulw-$(date +%Y%m%d-%H%M%S).XXXXXX.md)
```

Sections: Plan, Success criteria, Now, Todo, Findings, Learnings. **Append only.** After compaction, re-read whole notepad first.

### 3. Todos

Use `todo_write`. One `in_progress` at a time. Atomic steps with WHERE/WHY/HOW/VERIFY.

## Execution loop (PIN → RED → GREEN → SURFACE → CLEAN)

Until every criterion PASSES with evidence:

1. PIN + RED failing-first proof (or Manual-QA scenario failing) before production code
2. GREEN: smallest change; re-run proof
3. SURFACE: real channel (HTTP `curl -i`, browser, device install, CLI stdout for CLI-shaped work)
4. CLEANUP receipts for every spawned resource
5. HEAVY: spawn `lg-gate-reviewer` until `confirmed`

## Subagents

`spawn_subagent` with `subagent_type` = `lg-explorer` | `lg-librarian` | `lg-plan` | `lg-worker` | `lg-worker-high` | `lg-gate-reviewer`.  
Prompt contract: TASK / DELIVERABLE / SCOPE / VERIFY. Prefer `background: true` for long children; collect with `get_command_or_subagent_output`.  
Do not complete a todo while its child is still running.

## Constraints

- No production change before RED proof (except pure format/comment/rename)
- Never suppress tests/lints; never skip tests to green
- Never claim done from inference — only captured evidence
- Commits: Conventional; do not commit unless user authorized

## Stop

Stop when completion conditions are **fundamentally** fulfilled and every criterion has evidence + cleanup. After 2 identical failures on one step, ask the user. After 2 exploration waves with no new facts, act.

## Final message

Outcome + criteria checklist with evidence paths + notepad path + gate verdict (if HEAVY).
