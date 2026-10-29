#!/bin/bash
# Claude Code status line: model │ dir ⎇ branch │ context bar │ 5h limit │ cost
input=$(cat)
eval "$(jq -r '
  @sh "model=\(.model.display_name // "?")",
  @sh "dir=\(.workspace.current_dir // .cwd // "")",
  @sh "project=\(.workspace.project_dir // "")",
  @sh "cost=\(.cost.total_cost_usd // 0)",
  @sh "ctx_size=\(.context_window.context_window_size // 0)",
  @sh "pct=\(.context_window.used_percentage // 0 | floor)",
  @sh "ctx=\(.context_window.current_usage // {} | (.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0))",
  @sh "five=\(.rate_limits.five_hour.used_percentage // "" | tostring)"
' <<<"$input")"

# Colors
R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
MAG=$'\033[35m'; BLU=$'\033[34m'; GRN=$'\033[32m'; YEL=$'\033[33m'; RED=$'\033[31m'; CYN=$'\033[36m'
SEP=" ${D}│${R} "
level() { if [ "$1" -lt 50 ]; then printf '%s' "$GRN"; elif [ "$1" -lt 80 ]; then printf '%s' "$YEL"; else printf '%s' "$RED"; fi; }

# Branch of the current dir, or of the project when the current dir is not a repo.
git -C "$dir" rev-parse 2>/dev/null || dir=$project
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
[ -z "$branch" ] && branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
dirty=""
if [ -n "$branch" ] && [ -n "$(git -C "$dir" status --porcelain --untracked-files=no 2>/dev/null | head -1)" ]; then
  dirty="${YEL}●${R}"
fi

human() { awk -v n="${1:-0}" 'BEGIN{ if(n>=1e6) { s=sprintf("%.1f", n/1e6); sub(/\.0$/, "", s); printf "%sM", s } else if(n>=1e3) printf "%.0fk", n/1e3; else printf "%d", n }'; }

# Context bar: green < 50%, yellow < 80%, red above.
BAR=$(level "$pct")
width=10
filled=$(( (pct * width + 50) / 100 ))
bar=""
for ((i = 0; i < width; i++)); do
  if [ "$i" -lt "$filled" ]; then bar+="${BAR}━"; else bar+="${D}━${R}"; fi
done

out="${B}${MAG}◆ ${model}${R}"
out+="${SEP}${BLU}$(basename "$dir")${R}"
[ -n "$branch" ] && out+=" ${GRN}⎇ ${branch}${R}${dirty:+ $dirty}"
out+="${SEP}${bar}${R} $(level "$pct")${pct}%${R} ${D}$(human "$ctx")/$(human "$ctx_size")${R}"
[ -n "$five" ] && out+="${SEP}${D}5h${R} $(level "${five%.*}")${five%.*}%${R}"
out+="${SEP}${CYN}\$$(printf '%.2f' "$cost")${R}"
printf '%s' "$out"
