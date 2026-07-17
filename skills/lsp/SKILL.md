---
name: lsp
description: "[LazyGrok] Use when you need language-server diagnostics, definitions, references, symbols, or rename safety in the current workspace. On Grok, prefer lsp-setup + CLI language servers (typescript-language-server, basedpyright, rust-analyzer, gopls, etc.) via shell; use native lsp.* MCP tools only if present. Triggers: lsp, diagnostics, go to definition, find references, rename symbol, type errors after edit. LazyGrok commands: /lg-lsp."
---

## Grok Harness Tool Compatibility

Grok Build may **not** expose Codex `lsp.*` MCP tools. Prefer:

1. Load **`lsp-setup`** if servers are missing.
2. Run language-native check commands (see below).
3. If `lsp.*` / `mcp__lsp__*` tools appear in your tool list, use them.

# LSP (LazyGrok)

## Preferred path on Grok (no native LSP MCP)

| Goal | Approach |
| --- | --- |
| Diagnostics | Language CLI: `tsc --noEmit`, `basedpyright`, `ruff check`, `cargo check`, `go test` / `golangci-lint`, `swift build` |
| Definition / refs | `rg` + `read_file`; or `ast-grep` for structural; or language server CLI if configured |
| Rename safety | Prefer `ast-grep` / IDE-grade server; otherwise grep + careful multi-file edit + test |

After edits that touch types or public APIs, always run the project's typecheck/lint **and** a focused test.

## If Codex-style `lsp.*` tools exist

- `lsp.status` — configured / installed / missing servers
- `lsp.diagnostics` — prefer `severity: "error"` after edits
- `lsp.goto_definition` / `lsp.find_references` / `lsp.symbols`
- `lsp.prepare_rename` / `lsp.rename`

## Config locations (from OmO/LazyCodex)

Project: `.codex/lsp-client.json` or `.omo/lsp-client.json`  
User: `~/.codex/lsp-client.json` (optional)

```json
{
  "lsp": {
    "typescript": {
      "command": ["typescript-language-server", "--stdio"],
      "extensions": [".ts", ".tsx", ".js", ".jsx"]
    }
  }
}
```

Use **`lsp-setup`** for install/config per language. When diagnostics report a missing server, set it up before claiming "no errors".
