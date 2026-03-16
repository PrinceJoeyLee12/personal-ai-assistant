#!/usr/bin/env bash
# cu-task-create.sh — Create a task (or subtask) in a ClickUp list
#
# Usage: cu-task-create.sh --list <list_id> --name <name> [OPTIONS]
#
# Required:
#   --list <id>         List ID to create the task in
#   --name <name>       Task name
#
# Optional:
#   --desc <text>       Description / markdown body
#   --status <s>        Status: "to do" | "inprogress" | "complete"  (default: "to do")
#   --priority <n>      1=urgent 2=high 3=normal 4=low
#   --start <ms>        Start date (Unix ms, UTC)
#   --due <ms>          Due date (Unix ms, UTC)
#   --time-est <ms>     Time estimate in ms  (3600000 = 1h)
#   --tags <t1,t2>      Comma-separated tags (auto-lowercased)
#   --parent <task_id>  Parent task ID — creates a subtask
#
# Output: Full task JSON (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

LIST_ID="" NAME="" DESC="" STATUS="to do"
PRIORITY="" START="" DUE="" TIME_EST="" TAGS="" PARENT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)     LIST_ID="$2";   shift 2 ;;
    --name)     NAME="$2";      shift 2 ;;
    --desc)     DESC="$2";      shift 2 ;;
    --status)   STATUS="$2";    shift 2 ;;
    --priority) PRIORITY="$2";  shift 2 ;;
    --start)    START="$2";     shift 2 ;;
    --due)      DUE="$2";       shift 2 ;;
    --time-est) TIME_EST="$2";  shift 2 ;;
    --tags)     TAGS="$2";      shift 2 ;;
    --parent)   PARENT="$2";    shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$LIST_ID" ]] && { echo "ERROR: --list <list_id> is required" >&2; exit 1; }
[[ -z "$NAME"    ]] && { echo "ERROR: --name <name> is required" >&2; exit 1; }

# Build JSON body
BODY=$(jq -n --arg name "$NAME" --arg status "$STATUS" '{name: $name, status: $status}')

[[ -n "$DESC"     ]] && BODY=$(echo "$BODY" | jq --arg v "$DESC"     '. + {description: $v}')
[[ -n "$PRIORITY" ]] && BODY=$(echo "$BODY" | jq --argjson v "$PRIORITY" '. + {priority: $v}')
[[ -n "$START"    ]] && BODY=$(echo "$BODY" | jq --argjson v "$START"    '. + {start_date: $v}')
[[ -n "$DUE"      ]] && BODY=$(echo "$BODY" | jq --argjson v "$DUE"      '. + {due_date: $v}')
[[ -n "$TIME_EST" ]] && BODY=$(echo "$BODY" | jq --argjson v "$TIME_EST" '. + {time_estimate: $v}')
[[ -n "$PARENT"   ]] && BODY=$(echo "$BODY" | jq --arg v "$PARENT"       '. + {parent: $v}')
[[ -n "$TAGS"     ]] && BODY=$(echo "$BODY" | jq --arg t "$TAGS" \
  '. + {tags: ($t | split(",") | map(ltrimstr(" ") | rtrimstr(" ") | ascii_downcase) | map(select(length > 0)))}')

_cu_post "${CU_BASE}/list/${LIST_ID}/task" -d "$BODY" | _pp
