#!/usr/bin/env bash
# cu-time-start.sh — Start time tracking on a ClickUp task
#
# Usage: cu-time-start.sh <task_id> [OPTIONS]
#
# Required:
#   <task_id>         Task to start the timer on
#
# Optional:
#   --desc <text>     Description for the time entry
#   --billable        Mark as billable (default: false)
#
# Note: Only one timer can be active at a time. Running this stops any existing timer.
#
# Output: Time entry JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-time-start.sh <task_id> [--desc <text>] [--billable]" >&2; exit 1; }
shift

DESC="" BILLABLE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --desc)     DESC="$2"; shift 2 ;;
    --billable) BILLABLE=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

BODY=$(jq -n --arg tid "$TASK_ID" --argjson billable "$BILLABLE" \
  '{tid: $tid, billable: $billable}')
[[ -n "$DESC" ]] && BODY=$(echo "$BODY" | jq --arg v "$DESC" '. + {description: $v}')

_cu_post "${CU_BASE}/team/${CU_TEAM}/time_entries/start" -d "$BODY" | _pp
