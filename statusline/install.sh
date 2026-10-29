#!/bin/bash
# Install the status line into ~/.claude and point settings.json at it.
set -euo pipefail
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }
here=$(cd "$(dirname "$0")" && pwd)
dest="$HOME/.claude/statusline.sh"
settings="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
install -m 755 "$here/statusline.sh" "$dest"
[ -f "$settings" ] || echo '{}' >"$settings"
tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": "~/.claude/statusline.sh"}' "$settings" >"$tmp" && mv "$tmp" "$settings"
echo "Installed $dest and set statusLine in $settings"
