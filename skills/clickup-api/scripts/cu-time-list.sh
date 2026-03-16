#!/usr/bin/env bash
# cu-time-list.sh — List time entries for a ClickUp task
#
# Usage: cu-time-list.sh <task_id>
#
# Output: JSON array of time entries (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-time-list.sh <task_id>" >&2; exit 1; }

_cu_get "${CU_BASE}/team/${CU_TEAM}/time_entries?task_id=${TASK_ID}" | _pp
