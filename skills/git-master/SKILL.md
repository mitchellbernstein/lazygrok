---
name: git-master
description: "[LazyGrok] MUST USE whenever a task needs a commit or git-history investigation. Covers atomic commits, staging, commit-message style, rebase, squash, fixup/autosquash, blame, bisect, reflog, git log -S/-G, and questions like who wrote this or when was this added. Do not use for ordinary code edits unless the user asks for git work. LazyGrok commands: /lg-git-master."
---
## Grok Harness Tool Compatibility

This skill was adapted from OmO / LazyCodex. On **Grok Build**, do **not** call Codex `multi_agent_v1.*`, OpenCode `call_omo_agent`, or `team_*` tools literally.

Translate to Grok tools (see also `references/grok-tool-map.md` at plugin root):

| Source example | Grok tool |
| --- | --- |
| `spawn_subagent` / `spawn_agent` / `call_omo_agent` / `task(...)` | `spawn_subagent` with `subagent_type` + self-contained `prompt` |
| `wait_agent` / `background_output` | `get_command_or_subagent_output` |
| `team_create` / `team_send_message` / `team_delete` | Parallel `spawn_subagent` waves; **you** (parent) broker findings between rounds |
| `todo_write` | `todo_write` |
| `search_replace` | `search_replace` / write |
| `codegraph_*` | Use if available; else `grep` + `read_file` + `lg-explorer` |

Role map: `explorer`→`lg-explorer`, `librarian`→`lg-librarian`, `plan`→`lg-plan`, `metis`→`lg-metis`, `momus`→`lg-momus`, `oracle`/gate→`lg-gate-reviewer`, code review→`lg-code-reviewer`, workers→`lg-worker` / `lg-worker-high`. Built-in `explore` / `plan` / `general-purpose` are fine fallbacks.

Every child `prompt` is self-contained and starts with `TASK:` / `ROLE:` / `DELIVERABLE:` / `SCOPE:` / `VERIFY:`. Prefer `background: true` for parallel waves, then poll with `get_command_or_subagent_output`.

If a later code block conflicts with this section, **this section wins**.

# Git Master

Use this skill when the user asks you to operate on Git history or answer a Git-history question. Be exact, conservative, and evidence-led. Read the repository state before you infer anything.

## Mode Gate

Classify the request first:

- `COMMIT`: stage and commit local changes.
- `REBASE`: rebase, squash, fixup, autosquash, reorder, split, or otherwise rewrite branch history.
- `HISTORY`: answer when, where, who, why, or which commit changed something.
- `STATUS`: inspect branch, diff, or working-tree state without changing it.

Do not commit, rebase, push, force-push, reset, stash-pop, or delete anything unless the user explicitly asked for that operation. If the request is only investigative, report findings and stop.

## Ground Truth

Gather independent facts in parallel when the tools allow it:

```bash
git status --short
git diff --stat
git diff --staged --stat
git branch --show-current
git log -30 --oneline
git log -30 --pretty=format:%s
git rev-parse --abbrev-ref @{upstream}
git merge-base HEAD origin/main
git merge-base HEAD origin/master
```

Missing upstream or missing `main`/`master` is normal. Fall back to the best available branch or report the missing fact. Never treat a failed lookup as proof.

## PR Body Evidence Attachments

When a PR body needs screenshots or terminal PNGs, use the repo reference at `docs/reference/github-attachment-upload.md`. The allowed hosting path is GitHub user attachments from the authenticated web attachment flow; never commit temporary images, never use GitHub Releases for PR evidence, and never use external image hosts. Do not log browser cookies, CSRF tokens, S3 form fields, or upload headers.

## Commit Mode

Commit only the user's requested changes. Preserve unrelated dirty work.

1. Detect message style from recent history. Use the dominant local pattern, language, and casing. Do not default to Conventional Commits unless the repo uses them.
2. Inspect the full diff, not only filenames. Separate unrelated user edits from the requested commit.
3. Build atomic groups by behavior, module, and revertability. Keep implementation and its direct tests together.
4. Prefer multiple commits for unrelated concerns. A single commit is acceptable only when the changed files form one indivisible behavior or the user explicitly asks for one commit.
5. Stage by path or hunk so each commit contains only its atomic group.
6. Before each commit, verify `git diff --staged --stat` and enough staged diff to prove the group is right.
7. Commit with the detected style. After each commit, verify `git log -1 --oneline`.

Grouping rules:

- Split different features, modules, generated artifacts, config, docs, and test-only changes unless they are inseparable.
- Keep generated files with the source change that produced them when omitting them would leave the repo inconsistent.
- Never hide failing or unrelated changes inside a broad commit.

Final report: list commit hashes, messages, and any remaining uncommitted files.

## Rebase Mode

History rewriting is a shared-impact operation.

- Never rebase or rewrite `main`, `master`, `dev`, release branches, or a protected branch unless the user explicitly named that exact operation.
- If commits may already be pushed, ask before force-pushing. Use `--force-with-lease`, never plain `--force`.
- If the worktree is dirty, preserve it intentionally before rebasing. Do not stash-pop over conflicts without checking what changed.
- For fixups, prefer `git commit --fixup=<hash>` followed by `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`.
- For conflicts, read the conflicting files and resolve by intent. Do not choose ours/theirs blindly.
- If a rebase goes wrong, use `git rebase --abort` first. Use reflog only after explaining the recovery path.

After rewriting, run the relevant tests or at least the project's cheapest smoke check, then show the new branch log from base to HEAD.

## History Mode

Choose the Git tool by the question:

- `git log -S "text"`: when the count of an exact string changed.
- `git log -G "regex"`: when diffs touched lines matching a pattern.
- `git blame -L start,end -- file`: who last changed specific lines.
- `git log --follow -- file`: history across renames for one file.
- `git show <hash>`: inspect the commit that appears relevant.
- `git bisect`: find the first bad commit when there is a deterministic pass/fail command and known good/bad bounds.
- `git reflog`: recover or explain recent local history movement.

Always cite the exact command evidence in the answer: commit hash, subject, file path, and line or diff context when relevant. If the evidence is ambiguous, say what remains unproven.

## Safety Checks

Before any write to Git history:

- Current branch is known.
- Dirty work is accounted for.
- Upstream/pushed status is known or explicitly unknown.
- The operation matches the user's request.
- Recovery path is known (`rebase --abort`, reflog hash, or untouched worktree).

Before finishing:

- Run the most relevant verification available for the changed behavior or history operation.
- Report commands that passed and any command you could not run.
- Leave the worktree state explicit.
