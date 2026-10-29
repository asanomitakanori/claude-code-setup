# claude-harness

Personal setup for [Claude Code](https://docs.claude.com/en/docs/claude-code).

## Layout

- `AGENTS.md`: agent instructions; `CLAUDE.md` is a symlink to it
- `skills/`: skills; `.claude/skills` and `.agents/skills` are symlinks to it
- `statusline/`: the status line script and its installer

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
