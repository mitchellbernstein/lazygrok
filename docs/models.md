# Model map: LazyCodex → LazyGrok

LazyCodex routes OpenAI tiers (luna / sol / terra). LazyGrok uses **Grok models + reasoning effort**.

| LazyCodex role | LazyCodex model idea | LazyGrok agent | Grok mapping |
| --- | --- | --- | --- |
| explorer | fast / low | `lg-explorer` | `grok-4.5` effort **low** (or composer-class if available) |
| librarian | fast / low | `lg-librarian` | same |
| worker-low / medium | mid | `lg-worker` | `grok-4.5` effort **medium** |
| worker-high / executor | strong | `lg-worker-high` | `grok-4.5` effort **high** |
| plan / metis / momus | strongest | `lg-plan`, `lg-metis`, `lg-momus` | `grok-4.5` effort **high** |
| code-reviewer / gate | strongest | `lg-code-reviewer`, `lg-gate-reviewer` | `grok-4.5` effort **high** |

Your `~/.grok/config.toml` may set `default = "grok-composer-2.5-fast"` for everyday chat. LazyGrok agents prefer effort tiers on the session model when multiple model IDs are not available.

Pattern: **cheap digs → strong builds → strong reviews.**
