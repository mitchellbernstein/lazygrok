# Grok Build sessions

Local Grok Build session data (typical macOS layout):

| Path | Contents |
| --- | --- |
| `~/.grok/sessions/` | Session directories (URL-encoded workspace paths as folder names) |
| `~/.grok/sessions/<workspace>/<session-id>/` | Per-session store |
| `chat_history.jsonl` | Conversation turns |
| `terminal/*.log` | Tool / shell output captures |
| `updates.jsonl` | Session updates stream |
| `prompt_context.json` | Prompt/context snapshots when present |
| `~/.grok/memtrace/` | Memtrace JSONL segments |
| `~/.grok/active_sessions.json` | Active session index |

## Search tips

```bash
# Recent session dirs
ls -lt ~/.grok/sessions | head

# Grep chat history for a topic
rg -n "rate limit" ~/.grok/sessions --glob 'chat_history.jsonl' | head

# List sessions for a workspace path (folder names are URL-encoded)
ls ~/.grok/sessions | rg -i 'Documents|GitHub|your-repo'
```

## Finder integration

If `scripts/find-agent-sessions.py` does not yet register `grok` as a platform, treat this reference as the source of truth and use `rg`/`find` against `~/.grok/sessions` and `~/.grok/memtrace`. Pass `--root ~/.grok` only when intentional (can be large).

## Subagents

Grok subagent work often appears as nested tool results inside the parent `chat_history.jsonl` or as separate terminal logs under the same session folder. Search both.
