---
name: ulw-loop
description: "Durable evidence-bound loop until a completion promise. Use for ulw-loop, keep going until X, verified completion."
metadata:
  short-description: Loop until evidence / promise
---

# ulw-loop

Run ultrawork-style steps in a durable loop until the completion promise is true.

## Bootstrap

1. Load **ultrawork** rules (evidence, RED→GREEN, real-surface proof)  
2. Create state dir: `.omo/ulw-loop/<session-or-slug>/`  
3. Write `goal.md` with objective + success criteria + completion promise text  
4. Write `ledger.jsonl` (append-only events)  
5. `status.json`: `{ "status": "active", "iteration": 0, "promise": "...", "max_iterations": 100 }`  

Ultrawork mode max iterations may be higher (up to 500) when user said ultrawork.

## Loop

Each iteration:

1. Increment `iteration`  
2. Pick next incomplete criterion / gap  
3. Execute with ultrawork discipline (spawn workers as needed)  
4. Append ledger event with evidence paths  
5. If promise observable is true → set status `complete`, stop  
6. If max iterations → stop and report remaining gaps  

After compaction: re-read `goal.md` + `ledger.jsonl` + `status.json` before acting.

## Completion promise

User may pass `--completion-promise=TEXT`. Done only when that TEXT is **observably** true from evidence (not asserted). Default: all success criteria PASS with artifacts.

## First line

`ULW-LOOP MODE ENABLED!` (and ultrawork line if also active)
