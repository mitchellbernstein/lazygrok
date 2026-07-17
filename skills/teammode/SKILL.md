---
name: teammode
description: "LazyGrok team orchestration: run a named team of cooperating workers with durable .omo/teams state. MUST USE when the user asks to create, run, coordinate, inspect, archive, or delete a team of agents, or to work as a team in parallel. On Grok the transport is spawn_subagent waves (parent brokers); optional team.mjs script still owns disk state. Use a team when work is not perfectly isolated but parallelizing helps; use plain subagents when scope is isolated or the goal is ambiguous. Triggers: team mode, teammode, make a team, run as a team, team of agents, coordinate threads, parallel agents, archive the team, /teammode."
metadata:
  short-description: Named multi-agent teams with .omo/teams state
---

## Grok Harness Tool Compatibility

On **Grok Build** there is **no** Codex MultiAgentV2 and **no** OpenCode `team_*`.

| Intent | Grok tool |
| --- | --- |
| Spawn member | `spawn_subagent` (`lg-worker` / `lg-worker-high` / `general-purpose` / role agents) |
| Wait | `get_command_or_subagent_output` |
| Isolate edits | `isolation: "worktree"` or git worktrees via `team.mjs worktree-add` |
| Kill stuck child | `kill_command_or_subagent` |

Announce once: `Teammode transport: Grok spawn_subagent (parent-brokered).`

# Teammode (LazyGrok)

Run a named team of cooperating workers under one leader, with durable state on disk under `.omo/teams/`.

## When to use a team (vs plain subagents)

Use a **TEAM** when either holds:
- work does **not** split into perfectly isolated pieces, but parallelizing is clearly better (members react to each other's findings); or
- the goal is clear but investigation should fan out.

Use **plain** `spawn_subagent` (not a team) when either holds:
- work **is** perfectly isolated; or
- the goal is still ambiguous — one mind should resolve direction first.

## You are the leader — orchestrate, do not implement

The main session is ALWAYS the team leader. Orchestrate: split work, assign slices, verify deliverables, relay findings, synthesize. **DELEGATE every product-code edit to a member.** If you catch yourself editing product files while the team runs, that slice should have been a member.

## Compose by part, ownership, or perspective — not job title

- Always **2+ members** (one worker = plain subagent, not a team).
- Non-overlapping responsibilities. Each member has:
  - `--name` short label
  - `focus` — concrete part / ownership / perspective
  - `lens` — `area` | `ownership` | `perspective`
  - `deliverable` — what they must return

## Run the script — never hand-write team state

```bash
node "<skill-root>/scripts/team.mjs" init --name "<team>" --session-name "<session>" --transport spawn_agent
node "<skill-root>/scripts/team.mjs" add-member --team <session_id> --id A --name "<role>" --focus "<slice>" --lens area|ownership|perspective --deliverable "<...>"
node "<skill-root>/scripts/team.mjs" bind-agent --team <session_id> --id A --agent-path <subagent_id> [--cwd <path>]
node "<skill-root>/scripts/team.mjs" member-prompt --team <session_id> --id A
node "<skill-root>/scripts/team.mjs" set-status --team <session_id> --id A --status reported|blocked|active|archived [--note "<...>"]
node "<skill-root>/scripts/team.mjs" worktree-add --team <session_id> --id A [--base-branch <branch>]
node "<skill-root>/scripts/team.mjs" worktree-remove --team <session_id> --id A [--force]
node "<skill-root>/scripts/team.mjs" integrate --team <session_id> [--id A]
node "<skill-root>/scripts/team.mjs" archive --team <session_id> [--id A] [--note "<...>"]
node "<skill-root>/scripts/team.mjs" delete --team <session_id> [--force]
node "<skill-root>/scripts/team.mjs" status --team <session_id>
```

`init` creates `.omo/teams/{session_id}/` with `team.json`, `guide.md`, and `artifacts/`. Re-run is a safe no-op.

> **Transport flag:** scripts may still say `spawn_agent` / MultiAgentV2. On Grok that means **`spawn_subagent`**. If `init` rejects a transport name, pass whatever the script accepts for the native-agent path and **implement runtime with `spawn_subagent`**.

## Create members (Grok runtime)

1. `init` + `add-member` for each member.
2. If members would touch the same files → `worktree-add` **before** spawn; pass cwd in the member prompt.
3. Spawn each member:

```
spawn_subagent({
  subagent_type: "lg-worker",  // or lg-worker-high / general-purpose
  background: true,
  isolation: "worktree",       // when isolation needed and host supports it
  description: "<member name>",
  prompt: `<bootstrap from member-prompt>\n\nTASK: ...\nROLE: team member <name>\nDELIVERABLE: ...\nSCOPE: ...\nVERIFY: ...\n\nRead .omo/teams/<id>/guide.md and team.json. Report WORKING:/BLOCKED: progress. Return a final deliverable summary.`
})
```

4. `bind-agent --agent-path <subagent_id>` with the returned id.
5. Poll with `get_command_or_subagent_output`. Re-spawn or resume with new context when you need to relay peer findings (Grok has no inter-member mailbox — **you** paste digests).

## Communication (parent-brokered)

- Members do **not** see each other.
- You relay peer digests in English via new prompts / resume.
- Expect `WORKING:` / `BLOCKED:` style progress when you re-prompt.
- Shared files go in the team `artifacts/` directory.

## Let members work

Do not spam "any update?". Re-prompt only when: new info, reassignment, peer result changes their work, or true stall past expected work.

## Run a ulw-plan in parallel

Map independent todos in a wave → one member each. Dependencies → next wave after blockers report. Overlapping files → worktrees.

## Archive / delete / cleanup

1. Collect useful artifacts.
2. Kill any still-running children.
3. `archive` then `delete` team state.
4. `integrate` / PR / `worktree-remove` as the user requested.

## Stop rules

- Stop and ask before deleting an unarchived team with active members.
- If `spawn_subagent` fails mid-run, say so — do not fake a Codex/OpenCode transport.
- Never implement product code as the leader while the team is live.
