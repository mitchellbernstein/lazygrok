---
name: review-work
description: "Multi-angle post-implementation review. Use for review-work, review this change, gate the diff."
metadata:
  short-description: Multi-lane review
---

# review-work

Run independent review lanes (parallel `spawn_subagent` when useful):

| Lane | Agent / focus |
| --- | --- |
| Correctness | `lg-code-reviewer` — bugs, edge cases |
| Gate | `lg-gate-reviewer` — evidence vs claims |
| Security | auth, injection, secrets in diff |
| Simplicity | YAGNI, dead code |
| Tests | missing coverage, tautological tests |

## Input

User goal, diff or changed files, verification evidence paths.

## Output

Per-lane PASS/FAIL with findings. Overall: all PASS required for gate success. Timeouts/inconclusive = FAIL.
