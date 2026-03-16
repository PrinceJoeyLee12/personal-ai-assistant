#!/usr/bin/env bash
# cu-task-update.sh — Update fields on an existing ClickUp task
#
# Usage: cu-task-update.sh <task_id> [OPTIONS]
#
# Required:
#   <task_id>           Task ID to update (first positional argument)
#
# Optional (provide at least one):
#   --name <name>       New task name
#   --desc <text>       New description
#   --status <s>        New status: "to do" | "inprogress" | "complete"
#   --priority <n>      1=urgent 2=high 3=normal 4=low
#   --start <ms>        Start date (Unix ms, UTC)
#   --due <ms>          Due date (Unix ms, UTC)
#   --time-est <ms>     Time estimate in ms
#
# Output: Updated task JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
[[ -z "$TASK_ID" ]] && { echo "Usage: cu-task-update.sh <task_id> [--name ...] [--status ...] ..." >&2; exit 1; }
shift

NAME="" DESC="" STATUS="" PRIORITY="" START="" DUE="" TIME_EST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)     NAME="$2";      shift 2 ;;
    --desc)     DESC="$2";      shift 2 ;;
    --status)   STATUS="$2";    shift 2 ;;
    --priority) PRIORITY="$2";  shift 2 ;;
    --start)    START="$2";     shift 2 ;;
    --due)      DUE="$2";       shift 2 ;;
    --time-est) TIME_EST="$2";  shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

BODY='{}'
[[ -n "$NAME"     ]] && BODY=$(echo "$BODY" | jq --arg v "$NAME"     '. + {name: $v}')
[[ -n "$DESC"     ]] && BODY=$(echo "$BODY" | jq --arg v "$DESC"     '. + {description: $v}')
[[ -n "$STATUS"   ]] && BODY=$(echo "$BODY" | jq --arg v "$STATUS"   '. + {status: $v}')
[[ -n "$PRIORITY" ]] && BODY=$(echo "$BODY" | jq --argjson v "$PRIORITY" '. + {priority: $v}')
[[ -n "$START"    ]] && BODY=$(echo "$BODY" | jq --argjson v "$START"    '. + {start_date: $v}')
[[ -n "$DUE"      ]] && BODY=$(echo "$BODY" | jq --argjson v "$DUE"      '. + {due_date: $v}')
[[ -n "$TIME_EST" ]] && BODY=$(echo "$BODY" | jq --argjson v "$TIME_EST" '. + {time_estimate: $v}')

if [[ "$BODY" == '{}' ]]; then
  echo "ERROR: No fields to update. Provide at least one option like --status or --name." >&2
  exit 1
fi

_cu_put "${CU_BASE}/task/${TASK_ID}" -d "$BODY" | _pp
