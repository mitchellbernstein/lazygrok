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

if ((${#hints[@]})); then
  printf 'LazyGrok mode hints:\n'
  for h in "${hints[@]}"; do printf ' - %s\n' "$h"; done
fi
exit 0
