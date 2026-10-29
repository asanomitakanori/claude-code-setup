#!/bin/bash
# Install herdr, its config and the herdr-file-viewer plugin (with the local icon patch).
# Existing config files are backed up with a timestamp before they are replaced.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
conf="$HOME/.config/herdr"
stamp=$(date +%Y%m%d-%H%M%S)
# Commit the icon patch was made against; the plugin is pinned there so the patch applies.
viewer_ref=c237626260478d5f2d788149fc741ddf3c3588ba

if ! command -v herdr >/dev/null; then
  curl -fsSL https://herdr.dev/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

place() { # place <src> <dest>
  mkdir -p "$(dirname "$2")"
  if [ -f "$2" ] && ! cmp -s "$1" "$2"; then cp "$2" "$2.bak-$stamp"; fi
  cp "$1" "$2"
}
place "$here/config.toml" "$conf/config.toml"

herdr plugin install smarzban/herdr-file-viewer --ref "$viewer_ref" --yes
place "$here/file-viewer.toml" "$(herdr plugin config-dir herdr-file-viewer)/config.toml"

# file_icons is a local addition (upstream declined it); it needs a source build.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
if command -v cargo >/dev/null; then
  root=$(herdr plugin list --json | jq -r '.result.plugins[] | select(.plugin_id=="herdr-file-viewer") | .plugin_root')
  if git -C "$root" apply --check "$here/file-viewer-icons.patch" 2>/dev/null; then
    git -C "$root" apply "$here/file-viewer-icons.patch"
    (cd "$root" && cargo build --release)
  else
    echo "Icon patch already applied or does not apply; skipped" >&2
  fi
else
  echo "cargo not found: the file viewer runs without icons (file_icons is ignored)" >&2
fi

herdr server reload-config 2>/dev/null || true
echo "herdr configured in $conf"
echo "On hosts that share an NFS home, add herdr/zshrc.snippet to ~/.zshrc"
