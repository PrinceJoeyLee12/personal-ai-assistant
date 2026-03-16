#!/usr/bin/env bash
# cu-task-get.sh — Get full details of a ClickUp task
#
# Usage: cu-task-get.sh <task_id>
#
# Output: Full task JSON including subtasks and custom fields (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-task-get.sh <task_id>" >&2; exit 1; }

_cu_get "${CU_BASE}/task/${TASK_ID}?include_subtasks=true&custom_fields=true" | _pp
