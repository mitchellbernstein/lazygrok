---
name: init-deep
description: "Generate hierarchical AGENTS.md project memory. Use for init-deep, deep init, project memory, orient a large codebase."
metadata:
  short-description: Hierarchical AGENTS.md
---

# init-deep

Create hierarchical `AGENTS.md` so future agents have landmarks without re-explaining the monorepo.

## Steps

1. Map top-level layout (list_dir, package manifests, existing AGENTS.md/CLAUDE.md/README)  
2. Score complex directories (many files, mixed concerns, critical domain)  
3. Write **root** `AGENTS.md`: stack, how to run, key paths, non-negotiables, what not to touch  
4. Write nested `AGENTS.md` only where local context differs (e.g. `api/`, `web/`, `packages/foo/`)  
5. Keep each file concise (< ~80 lines). Prefer pointers over dumps  
6. Do not overwrite carefully maintained human AGENTS.md without merging — preserve unique human rules  

## Output

List of paths written + one-line purpose each. Suggest re-running when architecture shifts.
