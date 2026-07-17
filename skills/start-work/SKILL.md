---
name: start-work
description: "Execute a LazyGrok / Prometheus plan under .omo/plans/ with Boulder state, workers, and gate verification. Use for start-work, execute plan, continue plan, resume plan."
metadata:
  short-description: Execute plan until all checkboxes done
---

# start-work

**You are the orchestrator — not the implementer.**  
Do not edit product files or run QA yourself. Delegate via `spawn_subagent`.

## Select plan

1. Read `.omo/boulder.json` if present  
2. List `.omo/plans/*.md`  
3. Use user-provided plan name, or sole plan, or resume active Boulder work  
4. If no plan: bootstrap **ulw-plan** first, then continue  

## Boulder state

Write `.omo/boulder.json` before impl:

```json
{
  "schema_version": 2,
  "active_work_id": "<id>",
  "works": {
    "<id>": {
      "work_id": "<id>",
      "active_plan": ".omo/plans/<name>.md",
      "plan_name": "<name>",
      "session_ids": ["grok:<session_id>"],
      "status": "active",
      "worktree_path": null
    }
  }
}
```

Optional: `isolation: worktree` on workers for branch work; store path in `worktree_path`.

## Execute next checkbox

1. First unchecked top-level `- [ ]` in `## Todos` / `## Final Verification Wave`  
2. LIGHT vs HEAVY (same rules as ultrawork)  
3. Decompose; spawn independent lanes in parallel  
4. Difficulty: small → `lg-worker`; hard → `lg-worker-high`  
5. Research → `lg-explorer` / `lg-librarian`  

Each worker TASK includes: goal, files, RED-first when touching behavior, exact Manual-QA scenario, cleanup, DoneClaim shape.

## Verify (five gates per checkbox)

1. Plan reread  
2. Automated tests/typecheck/lint  
3. Manual-QA artifact (not dry-run)  
4. Adversarial classes that apply  
5. Cleanup receipts  

Worker DoneClaim → independent `lg-gate-reviewer` → only `confirmed` marks done.  
Ledger: append JSON lines to `.omo/start-work/ledger.jsonl`.

Mark `- [x]` only after gates pass. Continue without asking.

## Complete

When all checkboxes done:

1. Final verification commands from plan  
2. Spawn `lg-code-reviewer` + `lg-gate-reviewer` on final diff  
3. Print `ORCHESTRATION COMPLETE` with plan path, evidence, gate verdict  
4. Mark Boulder work completed  

## Hard rules

- No production change without RED-first (or failing Manual-QA)  
- No tests-only done claims  
- No direct implementation by root  
- Session ids prefixed `grok:`  
