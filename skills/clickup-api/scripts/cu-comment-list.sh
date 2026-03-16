#!/usr/bin/env bash
# cu-comment-list.sh — List all comments on a ClickUp task
#
# Usage: cu-comment-list.sh <task_id>
#
# Output: JSON array of comments (pretty-printed), newest last
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-comment-list.sh <task_id>" >&2; exit 1; }

_cu_get "${CU_BASE}/task/${TASK_ID}/comment" | _pp
