# LazyGrok maintainer notes

- Target host: **Grok Build** plugins (skills, agents, commands, hooks).
- **Namespace:** user-facing slash commands prefer **`/lg-*`** (e.g. `/lg-ulw`, `/lg-debug`). Bare OmO names (`/ulw`, `/debug`) remain aliases. Skill dirs keep OmO names; agents stay `lg-*`.
- Tag command `description` with `[LazyGrok]` so the picker is distinct from GSD / `ce-*`.
- Inspirations: `~/Documents/GitHub/oh-my-openagent`, `~/Documents/GitHub/lazycodex` (not submodules).
- When porting skills: full trees + Grok harness header; rewrite Codex/OpenCode tools → `spawn_subagent` / `get_command_or_subagent_output`.
- State: `.omo/` (plans, drafts, brainstorms, teams, boulder, ulw-loop, research).
- After changes: reinstall plugin and restart Grok so `/lg-*` reloads.
