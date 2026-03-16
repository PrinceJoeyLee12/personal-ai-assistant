#!/usr/bin/env bash
# cu-task-search.sh — Search tasks by keyword or tag
#
# Usage: cu-task-search.sh <query> [OPTIONS]
#
# Required:
#   <query>             Keyword to search (first positional argument)
#
# Optional:
#   --list <id>         Restrict search to a specific list
#   --tag               Treat <query> as a tag filter instead of keyword
#   --include-closed    Include completed/closed tasks (default: open only)
#
# Output: JSON array of matching tasks (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

QUERY="${1:-}"
[[ -z "$QUERY" ]] && { echo "Usage: cu-task-search.sh <query> [--list <id>] [--tag] [--include-closed]" >&2; exit 1; }
shift

LIST_ID="" TAG_MODE=false INCLUDE_CLOSED=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)          LIST_ID="$2"; shift 2 ;;
    --tag)           TAG_MODE=true; shift ;;
    --include-closed) INCLUDE_CLOSED=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

QUERY_ENCODED=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$QUERY")

if [[ -n "$LIST_ID" ]]; then
  # Search within a specific list
  if [[ "$TAG_MODE" == "true" ]]; then
    URL="${CU_BASE}/list/${LIST_ID}/task?tags[]=${QUERY_ENCODED}&subtasks=true"
  else
    URL="${CU_BASE}/list/${LIST_ID}/task?query=${QUERY_ENCODED}&subtasks=true"
  fi
  [[ "$INCLUDE_CLOSED" == "true" ]] && URL="${URL}&include_closed=true"
else
  # Search workspace-wide
  if [[ "$TAG_MODE" == "true" ]]; then
    URL="${CU_BASE}/team/${CU_TEAM}/task?tags[]=${QUERY_ENCODED}&subtasks=true"
  else
    URL="${CU_BASE}/team/${CU_TEAM}/task?query=${QUERY_ENCODED}&subtasks=true"
  fi
  [[ "$INCLUDE_CLOSED" == "true" ]] && URL="${URL}&include_closed=true"
fi

_cu_get "$URL" | _pp
