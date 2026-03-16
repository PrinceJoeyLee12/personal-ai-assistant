#!/usr/bin/env bash
# cu-list-tasks.sh — Get tasks from a ClickUp list with optional filters
#
# Usage: cu-list-tasks.sh <list_id> [OPTIONS]
#
# Required:
#   <list_id>           List ID to query
#
# Optional:
#   --start-gt <ms>     Tasks with start_date > this value (Unix ms, UTC)
#   --start-lt <ms>     Tasks with start_date < this value
#   --due-gt <ms>       Tasks with due_date > this value
#   --due-lt <ms>       Tasks with due_date < this value
#   --status <s>        Filter by status (can repeat):  "to do" | "inprogress" | "complete"
#   --include-closed    Include closed/completed tasks (default: open only)
#   --subtasks          Include subtasks in results (default: false)
#
# Output: JSON response with tasks array (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

LIST_ID="${1:-}"
[[ -z "$LIST_ID" ]] && { echo "Usage: cu-list-tasks.sh <list_id> [OPTIONS]" >&2; exit 1; }
shift

START_GT="" START_LT="" DUE_GT="" DUE_LT=""
STATUS_FILTERS=() INCLUDE_CLOSED=false SUBTASKS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --start-gt)      START_GT="$2";  shift 2 ;;
    --start-lt)      START_LT="$2";  shift 2 ;;
    --due-gt)        DUE_GT="$2";    shift 2 ;;
    --due-lt)        DUE_LT="$2";    shift 2 ;;
    --status)        STATUS_FILTERS+=("$2"); shift 2 ;;
    --include-closed) INCLUDE_CLOSED=true; shift ;;
    --subtasks)      SUBTASKS=true;  shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

URL="${CU_BASE}/list/${LIST_ID}/task?page=0"

[[ -n "$START_GT" ]] && URL="${URL}&start_date_gt=${START_GT}"
[[ -n "$START_LT" ]] && URL="${URL}&start_date_lt=${START_LT}"
[[ -n "$DUE_GT"   ]] && URL="${URL}&due_date_gt=${DUE_GT}"
[[ -n "$DUE_LT"   ]] && URL="${URL}&due_date_lt=${DUE_LT}"
[[ "$INCLUDE_CLOSED" == "true" ]] && URL="${URL}&include_closed=true"
[[ "$SUBTASKS" == "true" ]] && URL="${URL}&subtasks=true"

for S in "${STATUS_FILTERS[@]:-}"; do
  S_ENC=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$S")
  URL="${URL}&statuses[]=${S_ENC}"
done

_cu_get "$URL" | _pp
