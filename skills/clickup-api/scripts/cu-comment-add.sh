#!/usr/bin/env bash
# cu-comment-add.sh — Post a comment on a ClickUp task
#
# Usage: cu-comment-add.sh <task_id> <text>
#
# Arguments:
#   <task_id>   Task to comment on
#   <text>      Comment text (supports plain text; wrap in quotes for multi-word)
#
# Output: Created comment JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
TEXT="${2:-}"

if [[ -z "$TASK_ID" || -z "$TEXT" ]]; then
  echo "Usage: cu-comment-add.sh <task_id> <text>" >&2
  exit 1
fi

BODY=$(jq -n --arg t "$TEXT" '{comment_text: $t, notify_all: false}')
_cu_post "${CU_BASE}/task/${TASK_ID}/comment" -d "$BODY" | _pp
