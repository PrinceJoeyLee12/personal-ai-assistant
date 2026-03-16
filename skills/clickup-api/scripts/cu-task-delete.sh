#!/usr/bin/env bash
# cu-task-delete.sh — Permanently delete a ClickUp task
#
# Usage: cu-task-delete.sh <task_id>
#
# ⚠️  This is irreversible. The task and all subtasks will be deleted.
#
# Output: Empty response on success (ClickUp returns 204)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-task-delete.sh <task_id>" >&2; exit 1; }

RESPONSE=$(_cu_delete "${CU_BASE}/task/${TASK_ID}")
if [[ -z "$RESPONSE" ]]; then
  echo "{\"deleted\": true, \"task_id\": \"${TASK_ID}\"}"
else
  echo "$RESPONSE" | _pp
fi
