# CLI Tools

Use these tools for listed operations. All installed on this machine.

| Operation | Preferred tool | Avoid |
|-----------|----------------|-------|
| Discover files | `fd` | `find`, `ls -R` |
| Search source code | `rg` | `grep -r` |
| Structural code search | `ast-grep` | regex for syntax-aware matches |
| Read source files | Native `Read` tool | `cat`, `head`, `tail`, `sed -n` |
| Edit source files | Native `Edit` / `Write` tools | `sed -i`, `awk`, heredoc rewrites |
| JSON processing | `jq` | `python -c`, `grep` on JSON |
| YAML processing | `yq` | `python -c`, `grep` on YAML |

## Notes

- `grep` and `find` blocked in Bash by `hooks/validate-bash.sh`. Do not retry under another spelling.
- `fd`: `find` replacement is `fd --hidden --no-ignore`, searches same files `find` would. Drop those flags only when skipping hidden/ignored files intended. Example: `fd --hidden --no-ignore -e ts . src/`.
- `rg`: respects `.gitignore`; use `-t <type>`, `-g '<glob>'`, `-l` for file list, `-C <n>` for context.
- `ast-grep`: use for matching code by syntax (calls, imports, patterns with metavariables). Binary is `ast-grep`, not `sg`. Example: `ast-grep run -p 'console.log($A)' -l ts`.
- `yq` here is Python jq wrapper (kislyuk/yq), not mikefarah/yq. Takes jq syntax. Use `-y` for YAML output, `-i` for in-place edits. Example: `yq -y '.services | keys' docker-compose.yml`.
- Prefer `rg` for plain text; switch to `ast-grep` when text search gives false matches (comments, strings, formatting variants).
- Use shell edits of source files only for bulk mechanical changes across many files where native tool impractical.