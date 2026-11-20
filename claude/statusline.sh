#!/bin/bash
# Line 1: model, folder, running subagents, ponytail level.
# Line 2: context bar, tokens, 5h/7d limits, cache hit rate.
# `statusline.sh agent start|stop` is the SubagentStart/SubagentStop hook that feeds the agent count.
input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }
agents_dir="${TMPDIR:-/tmp}/claude-agents/$(j '.session_id')"

if [ "$1" = agent ]; then
  id=$(j '.agent_id')
  [ -n "$id" ] || exit 0
  mkdir -p "$agents_dir"
  if [ "$2" = start ]; then touch "$agents_dir/$id"; else rm -f "$agents_dir/$id"; fi
  exit 0
fi

model=$(j '.model.display_name')
dir=$(j '.workspace.current_dir')
used=$(j '.context_window.used_percentage')
tok=$(j '.context_window.total_input_tokens')
size=$(j '.context_window.context_window_size')
five=$(j '.rate_limits.five_hour.used_percentage')
week=$(j '.rate_limits.seven_day.used_percentage')
hit=$(j '.prompt_cache.hit_ratio')

# green < 50, yellow < 80, red otherwise
color() { if [ "$1" -lt 50 ]; then printf '\033[32m'; elif [ "$1" -lt 80 ]; then printf '\033[33m'; else printf '\033[31m'; fi; }
R='\033[0m'
DIM='\033[2m'
k() { awk -v n="$1" 'BEGIN{ if (n>=1000000) printf "%.1fM", n/1000000; else if (n>=1000) printf "%.0fk", n/1000; else printf "%d", n }'; }

# Same glyphs and meter as the opencode status plugin.
agents=$(find "$agents_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$agents" -gt 0 ]; then a="\033[32m󰚩 ${agents}${R}"; else a="${DIM}󰚩 0${R}"; fi

# Ponytail's hooks write the live mode here; no file means off.
mode=$(head -n1 "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.ponytail-active" 2>/dev/null | tr -d '[:space:]')
case "$mode" in
lite) meter='▄▁▁' ;;
full) meter='▄▄▁' ;;
ultra) meter='▄▄▄' ;;
*) meter='▁▁▁' ;;
esac

printf '\033[36m%s\033[0m in \033[34m%s\033[0m  %b  %b\n' "${model:-Claude}" "$(basename "${dir:-$PWD}")" "$a" "${DIM}󱗁 ${meter}${R}"

line=""
if [ -n "$used" ]; then
  p=$(printf '%.0f' "$used")
  f=$((p / 10)); [ "$f" -gt 10 ] && f=10
  bar=""; for i in $(seq 1 10); do [ "$i" -le "$f" ] && bar="${bar}█" || bar="${bar}░"; done
  line="$(color "$p")$bar ${p}%${R}"
  [ -n "$tok" ] && [ -n "$size" ] && line="$line $(k "$tok")/$(k "$size")"
else
  line="░░░░░░░░░░ -"
fi
for pair in "5h:$five" "7d:$week"; do
  v=${pair#*:}
  [ -n "$v" ] && { p=$(printf '%.0f' "$v"); line="$line | ${pair%%:*} $(color "$p")${p}%${R}"; }
done
[ -n "$hit" ] && line="$line | cache $(awk -v h="$hit" 'BEGIN{printf "%.0f", h*100}')%"
printf '%b\n' "$line"
