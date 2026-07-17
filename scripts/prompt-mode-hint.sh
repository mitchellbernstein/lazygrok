#!/usr/bin/env bash
# Hint when user prompt looks like LazyCodex mode keywords (stdin = hook JSON if any)
set -euo pipefail
input="$(cat || true)"
# Try common fields; fall back to full payload
text="$(printf '%s' "$input" | python3 -c '
import sys, json, re
raw = sys.stdin.read()
try:
    d = json.loads(raw)
except Exception:
    print(raw); raise SystemExit
for k in ("prompt", "userPrompt", "user_prompt", "text", "message"):
    if isinstance(d.get(k), str):
        print(d[k]); raise SystemExit
print(raw)
' 2>/dev/null || printf '%s' "$input")"

lower="$(printf '%s' "$text" | tr '[:upper:]' '[:lower:]')"
hints=()
if printf '%s' "$lower" | grep -qE '\b(ultrawork|/ultrawork|\bulw\b|/ulw)\b'; then
  hints+=("ULTRAWORK keyword detected — load ultrawork skill; first line ULTRAWORK MODE ENABLED!")
fi
if printf '%s' "$lower" | grep -qE 'ulw-research|ultraresearch|/ulw-research|deep research'; then
  hints+=("ULW-RESEARCH keyword detected — load ulw-research; first line ULW-RESEARCH MODE ENABLED!")
fi
if printf '%s' "$lower" | grep -qE 'ulw-plan|/ulw-plan'; then
  hints+=("ULW-PLAN keyword detected — plan only under .omo/plans; no product code.")
fi
if printf '%s' "$lower" | grep -qE 'start-work|/start-work'; then
  hints+=("START-WORK keyword detected — orchestrate plan; do not implement as root.")
fi
if printf '%s' "$lower" | grep -qE 'ulw-loop|/ulw-loop'; then
  hints+=("ULW-LOOP keyword detected — durable loop until promise/evidence.")
fi


if printf '%s' "$lower" | grep -qE '\b(debug|/debug|debugging)\b'; then
  hints+=("DEBUG keyword detected — load debugging skill; runtime evidence only.")
fi
if printf '%s' "$lower" | grep -qE 'brainstorm|/brainstorm'; then
  hints+=("BRAINSTORM keyword detected — load brainstorm skill; first line BRAINSTORM MODE ENABLED!")
fi
if printf '%s' "$lower" | grep -qE 'hyperplan|/hyperplan|\bhpp\b'; then
  hints+=("HYPERPLAN keyword detected — adversarial multi-agent planning.")
fi
if printf '%s' "$lower" | grep -qE 'review-work|review my work'; then
  hints+=("REVIEW-WORK keyword detected — multi-lane post-implementation review.")
fi


if printf '%s' "$lower" | grep -qE '\b(frontend|/frontend|redesign|lighthouse)\b'; then
  hints+=("FRONTEND keyword — load frontend skill for UI work.")
fi
if printf '%s' "$lower" | grep -qE 'visual-qa|/visual-qa|visual qa'; then
  hints+=("VISUAL-QA keyword — load visual-qa skill.")
fi
if printf '%s' "$lower" | grep -qE 'ast-grep|/ast-grep|\basg\b'; then
  hints+=("AST-GREP keyword — load ast-grep for structural search.")
fi
if printf '%s' "$lower" | grep -qE 'teammode|/teammode|make a team|run as a team'; then
  hints+=("TEAMMODE keyword — load teammode; spawn_subagent waves.")
fi
if printf '%s' "$lower" | grep -qE 'ultimate-browsing|/ultimate-browsing|cloudflare.?waf|stealth browser'; then
  hints+=("ULTIMATE-BROWSING keyword — hard web access skill.")
fi
if printf '%s' "$lower" | grep -qE 'coding-agent-sessions|/sessions|what did i work on'; then
  hints+=("SESSIONS keyword — load coding-agent-sessions.")
fi


if printf '%s' "$lower" | grep -qE '/lg-|\\blg-(ulw|debug|brainstorm|plan|start-work|hyperplan)'; then
  hints+=("LazyGrok /lg-* command detected — load matching LazyGrok skill (not CE/GSD).")
fi

if ((${#hints[@]})); then
  printf 'LazyGrok mode hints:\n'
  for h in "${hints[@]}"; do printf ' - %s\n' "$h"; done
fi
exit 0
