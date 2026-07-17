# LazyGrok maintainer notes

- Target host: **Grok Build** plugins (skills, agents, commands, hooks).
- Inspirations live at `~/Documents/GitHub/oh-my-openagent` and `~/Documents/GitHub/lazycodex` (not submodules).
- Prefer behavior parity with LazyCodex Light over OpenCode Ultimate features.
- When porting skills: copy full trees (including `references/`), inject Grok harness compatibility, rewrite `multi_agent_*` / `call_omo_agent` / `team_*` → `spawn_subagent` / `get_command_or_subagent_output`.
- State for user projects: `.omo/` (plans, drafts, brainstorms, boulder, ulw-loop, research).
- After skill changes: `grok plugin install ~/Documents/GitHub/lazygrok --trust` (or reinstall) so the installed-plugins copy refreshes.
- Do not push releases until `grok plugin details lazygrok` shows expected skills/commands.
