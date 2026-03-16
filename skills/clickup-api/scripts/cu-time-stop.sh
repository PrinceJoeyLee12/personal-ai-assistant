#!/usr/bin/env bash
# cu-time-stop.sh — Stop the currently active time tracker
#
# Usage: cu-time-stop.sh
#
# Output: Stopped time entry JSON with duration (pretty-printed)
# Exit:   0 on success, 1 on error or if no timer is running

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

_cu_post "${CU_BASE}/team/${CU_TEAM}/time_entries/stop" -d '{}' | _pp
