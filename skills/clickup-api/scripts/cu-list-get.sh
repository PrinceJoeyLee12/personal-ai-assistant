#!/usr/bin/env bash
# cu-list-get.sh — Get metadata for a ClickUp list
#
# Usage: cu-list-get.sh <list_id>
#
# Output: List JSON (name, status options, folder, space, etc.) — pretty-printed
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

LIST_ID="${1:-}"
[[ -z "$LIST_ID" ]] && { echo "Usage: cu-list-get.sh <list_id>" >&2; exit 1; }

_cu_get "${CU_BASE}/list/${LIST_ID}" | _pp
