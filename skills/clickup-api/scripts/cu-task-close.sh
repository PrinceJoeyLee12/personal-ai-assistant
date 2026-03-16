#!/usr/bin/env bash
# cu-task-close.sh — Mark a ClickUp task as complete
#
# Usage: cu-task-close.sh <task_id>
#
# Output: Updated task JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-task-close.sh <task_id>" >&2; exit 1; }

_cu_put "${CU_BASE}/task/${TASK_ID}" -d '{"status": "complete"}' | _pp
