#!/usr/bin/env bash
# Scaffold .omo plan artifacts for LazyGrok ulw-plan
set -euo pipefail
slug="${1:-}"
if [[ -z "$slug" ]]; then
  echo "usage: scaffold-plan.sh <slug> [--clear|--unclear]" >&2
  exit 1
fi
intent="clear"
[[ "${2:-}" == "--unclear" ]] && intent="unclear"
[[ "${2:-}" == "--clear" ]] && intent="clear"

mkdir -p .omo/plans .omo/drafts
plan=".omo/plans/${slug}.md"
draft=".omo/drafts/${slug}.md"

if [[ -f "$plan" && "${3:-}" != "--reset" && "${2:-}" != "--reset" ]]; then
  echo "exists: $plan (pass --reset to rebuild skeleton)"
  exit 0
fi

cat > "$draft" <<EOF
# Draft: ${slug}

- intent: ${intent}
- review_required: false
- status: exploring
- updated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Decisions
(append)

## Open questions
(append)
EOF

cat > "$plan" <<EOF
# Plan: ${slug}

## TL;DR (For humans)

_One paragraph outcome._

## Goal

-

## Must-NOT-Have

-

## Decisions

-

## Todos

- [ ] Task 1 — acceptance: … — QA: \`exact command\` PASS when …

## Final Verification Wave

- [ ] Full suite / typecheck / real-surface smoke — QA: …
EOF

echo "wrote $draft"
echo "wrote $plan"
