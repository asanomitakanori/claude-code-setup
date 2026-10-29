# claude-code-setup

Personal setup for [Claude Code](https://docs.claude.com/en/docs/claude-code).

## Layout

- `AGENTS.md`: agent instructions; `CLAUDE.md` is a symlink to it
- `skills/`: skills; `.claude/skills` and `.agents/skills` are symlinks to it
- `rules/`: global rules for how to work with pstack
- `settings.example.json`: general settings (theme, model, effort per model, status line)
- `statusline/`: the status line script and its installer
- `.claude/settings.json`: plugins enabled when Claude Code opens this repository

## Plugins

This repository is a Claude Code plugin marketplace (`.claude-plugin/marketplace.json`). Neither plugin is authored here; both are cited from [cursor/plugins](https://github.com/cursor/plugins). The marketplace points at the upstream directories instead of copying them, so the code and its licenses stay there.

- **pstack** (cited): `poteto-mode`, `poteto-agent` and the other pstack skills, from `harness/pstack/claude-code`. © 2026 Lauren Tan, MIT License.
- **thermos** (cited): code review. `/thermos` runs a branch audit (bugs, breaking changes, security) and a code-quality audit as parallel subagents and merges the findings; the two audits are also available alone. From `thermos`. © 2026 Cursor, MIT License.

Claude Code offers to install them when it opens this repository. To install them for every project:

```bash
claude plugin marketplace add asanomitakanori/claude-code-setup
claude plugin install pstack@claude-code-setup
claude plugin install thermos@claude-code-setup
```

## Rules

Files in `~/.claude/rules/` apply to every project. Copy the ones you want:

```bash
mkdir -p ~/.claude/rules && cp rules/*.md ~/.claude/rules/
```

- `pstack-default.md`: use pstack's `poteto-mode` for substantive engineering work
- `subagent-delegation.md`: the main session plans and delegates coding to `pstack:poteto-agent` subagents
- `pstack-models.md`: which model and effort each pstack role uses

## Settings

`settings.example.json` holds the general settings. Merge it into `~/.claude/settings.json` (existing keys are overwritten by the example's):

```bash
jq -s '.[0] * .[1]' ~/.claude/settings.json settings.example.json > /tmp/settings.json && mv /tmp/settings.json ~/.claude/settings.json
```

## Status line

`statusline/statusline.sh` shows, on one line:

```
◆ Opus │ my-repo ⎇ feature-branch ● │ ━━━━━━━━━━ 42% 84k/200k │ 5h 17% │ $1.23
```

- model name
- current directory and git branch (`●` when tracked files have uncommitted changes)
- context window usage as a bar, percentage and tokens (green < 50%, yellow < 80%, red above)
- 5-hour rate limit usage, when Claude Code reports it
- session cost in USD

Requires `bash`, `jq` and `git`.

### Install

```bash
./statusline/install.sh
```

This copies the script to `~/.claude/statusline.sh` and adds the following to `~/.claude/settings.json` (other settings are kept):

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh"
}
```

Restart Claude Code to pick it up.

## Credits

- [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan, cited from [cursor/plugins](https://github.com/cursor/plugins) under the MIT License.
- [thermos](https://github.com/cursor/plugins/tree/main/thermos) by Cursor, cited from [cursor/plugins](https://github.com/cursor/plugins) under the MIT License.

## License

MIT, see [LICENSE](LICENSE). This covers the files in this repository. pstack and thermos are not included here and stay under their own MIT Licenses (© 2026 Lauren Tan and © 2026 Cursor).
