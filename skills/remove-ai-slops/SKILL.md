---
name: remove-ai-slops
description: "Behavior-preserving cleanup of AI-looking code: dead wrappers, redundant comments, over-abstraction. Use for remove-ai-slops, deslop, clean AI code."
metadata:
  short-description: Deslop AI code without behavior change
---

# remove-ai-slops

Behavior-preserving pass:

1. Diff or user-named paths only (default: recent changes)  
2. Remove redundant comments, unused helpers, needless abstractions, duplicate error wrapping  
3. Keep public APIs and tests green  
4. Run project tests/typecheck after  
5. Summarize deletions with risk notes  

Do not rename for style alone. Do not expand scope.
