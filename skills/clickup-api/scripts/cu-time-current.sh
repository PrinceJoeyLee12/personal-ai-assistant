#!/usr/bin/env bash
# cu-time-current.sh — Check which timer is currently running
#
# Usage: cu-time-current.sh
#
# Output: Current time entry JSON, or {"running": false} if none active
# Exit:   0 always

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

RESPONSE=$(_cu_get "${CU_BASE}/team/${CU_TEAM}/time_entries/current")
if [[ -z "$RESPONSE" || "$RESPONSE" == 'null' || "$RESPONSE" == '{}' ]]; then
  echo '{"running": false}'
else
  echo "$RESPONSE" | _pp
fi
