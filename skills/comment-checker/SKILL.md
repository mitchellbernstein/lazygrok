---
name: comment-checker
description: "Strip AI-slop comments after edits. Use for comment-checker, no AI comments, clean comments."
metadata:
  short-description: No AI comment slop
---

# comment-checker

After edit-like work, inspect changed files for comment smell:

- Narrating what the next line does ("// increment counter")  
- "AI wrote this" / apologetic / emoji decoration  
- Restating types or names already clear in code  
- TODO without owner/ticket  

**Keep:** non-obvious invariants, safety warnings, public API intent, legal headers.

Prefer deleting noise over rewriting into more prose. Behavior-preserving only.
