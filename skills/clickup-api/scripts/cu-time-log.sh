#!/usr/bin/env bash
# cu-time-log.sh — Log time manually on a ClickUp task
#
# Usage: cu-time-log.sh <task_id> <duration_ms> [OPTIONS]
#
# Required:
#   <task_id>         Task to log time on
#   <duration_ms>     Duration in milliseconds  (3600000 = 1h, 1800000 = 30m, 5400000 = 1.5h)
#
# Optional:
#   --start <ms>      Start time in Unix ms, UTC  (default: now - duration)
#   --desc <text>     Description for the entry
#   --billable        Mark as billable (default: false)
#
# Output: Created time entry JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
DURATION="${2:-}"

if [[ -z "$TASK_ID" || -z "$DURATION" ]]; then
  echo "Usage: cu-time-log.sh <task_id> <duration_ms> [--start <ms>] [--desc <text>] [--billable]" >&2
  exit 1
fi
shift 2

START="" DESC="" BILLABLE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --start)    START="$2"; shift 2 ;;
    --desc)     DESC="$2";  shift 2 ;;
    --billable) BILLABLE=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

# Default start = now - duration
if [[ -z "$START" ]]; then
  NOW_MS=$(python3 -c "import time; print(int(time.time() * 1000))")
  START=$(( NOW_MS - DURATION ))
fi

BODY=$(jq -n \
  --arg tid "$TASK_ID" \
  --argjson dur "$DURATION" \
  --argjson start "$START" \
  --argjson billable "$BILLABLE" \
  '{tid: $tid, duration: $dur, start: $start, billable: $billable}')

[[ -n "$DESC" ]] && BODY=$(echo "$BODY" | jq --arg v "$DESC" '. + {description: $v}')

_cu_post "${CU_BASE}/team/${CU_TEAM}/time_entries" -d "$BODY" | _pp
