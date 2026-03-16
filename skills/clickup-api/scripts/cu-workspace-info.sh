#!/usr/bin/env bash
# cu-workspace-info.sh — Get workspace/team info and members
#
# Usage: cu-workspace-info.sh
#
# Output: Team JSON including name, color, and member list (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

_cu_get "${CU_BASE}/team" | _pp
