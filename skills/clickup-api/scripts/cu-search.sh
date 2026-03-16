#!/usr/bin/env bash
# cu-search.sh — Full-workspace keyword or tag search
#
# Usage: cu-search.sh <query> [OPTIONS]
#
# Required:
#   <query>           Keyword to search across all tasks in the workspace
#
# Optional:
#   --tag             Treat <query> as a tag filter instead of keyword
#   --include-closed  Include closed/completed tasks
#
# Output: JSON with tasks array (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

QUERY="${1:-}"
[[ -z "$QUERY" ]] && { echo "Usage: cu-search.sh <query> [--tag] [--include-closed]" >&2; exit 1; }
shift

TAG_MODE=false INCLUDE_CLOSED=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)           TAG_MODE=true; shift ;;
    --include-closed) INCLUDE_CLOSED=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

QUERY_ENCODED=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$QUERY")

if [[ "$TAG_MODE" == "true" ]]; then
  URL="${CU_BASE}/team/${CU_TEAM}/task?tags[]=${QUERY_ENCODED}&subtasks=true"
else
  URL="${CU_BASE}/team/${CU_TEAM}/task?query=${QUERY_ENCODED}&subtasks=true"
fi

[[ "$INCLUDE_CLOSED" == "true" ]] && URL="${URL}&include_closed=true"

_cu_get "$URL" | _pp
