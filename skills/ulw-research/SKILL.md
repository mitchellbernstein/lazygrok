---
name: ulw-research
description: "Maximum-saturation research orchestration (ultraresearch). Parallel explore+librarian waves, EXPAND loop, cited synthesis. ONLY on explicit research demand: ulw-research, ultraresearch, /ulw-research, deep research."
metadata:
  short-description: Exhaustive research swarm
---

# ULW-RESEARCH (ultraresearch)

**First lines:** if ultrawork also active, print its line first; then  
`ULW-RESEARCH MODE ENABLED!`

You are the research orchestrator. Exhaustive coverage is the goal. Under-exploration is failure. **Do not self-activate** for normal Q&A or implementation context-gathering.

## Tool map

Use `spawn_subagent` → `lg-explorer` (codebase), `lg-librarian` (docs/web/OSS), optional `general-purpose` for code verification runs. See `references/grok-tool-map.md`. Workers must not spawn their own children; you own expansion waves.

## Success

- Every Phase-0 axis covered by ≥1 worker  
- Every EXPAND lead investigated or closed  
- Contested claims proven/refuted by executed code when possible  
- Every claim in the deliverable has a citation or verification artifact  
- Session journal reconstructs waves  

## State (under `.omo/ulw-research/<session>/`)

Create and maintain:

- `intent-diff.md` — expected vs observed  
- `claim-graph.md` — claims + status  
- `observation-manifest.md` — sources  
- `expansion-log.md` — waves  
- `wave-*.md` digests  

## Phase 0 — Axes

Split the question into distinct axes (part / territory / lens). Prefer **5–8** axes when distinct. Add one skeptic/red-team axis when stakes are high. Announce axes to the user.

## Phase 1 — Saturation wave

Launch the entire first wave in **one turn** (parallel `spawn_subagent`):

| Scope | Agents |
| --- | --- |
| Codebase | 1–3 `lg-explorer` |
| Web/docs | 2–4 `lg-librarian` |
| Hard pages / verification | as needed |

Each child message: TASK, axis ownership, DELIVERABLE (findings + sources + EXPAND leads), VERIFY.

## Phase 2 — EXPAND until convergence

As returns land:

1. Journal digests + EXPAND markers  
2. Dedup against expansion-log  
3. Spawn expansion workers for new leads immediately  
4. Stop only when: 3 consecutive waves add no actionable leads, or depth 5 (then ask user to extend), or axes fully closed  

## Phase 3 — Verify contested claims

Run code / tests / minimal scripts for claims that are performance-shaped, undocumented, or disputed. Record outcomes in claim-graph.

## Phase 4–5 — Synthesis

Write a cited synthesis (default markdown under `.omo/ulw-research/<session>/report.md`). Optional formats only if user asked (HTML/PDF/PPTX via skills).

Include: Workers count · Waves · Sources · Verifications · expansion trace · open unknowns.

## Non-negotiables

- Over-communicate leads; never hoard for a final dump  
- Snippets lie — fetch full pages that matter  
- Parent writes instrumentation files; workers return text leads  
- Ordinary implementation exploration stays **out** of this mode  
