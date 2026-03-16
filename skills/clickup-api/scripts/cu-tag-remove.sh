#!/usr/bin/env bash
# cu-tag-remove.sh — Remove a tag from a ClickUp task
#
# Usage: cu-tag-remove.sh <task_id> <tag>
#
# Output: Empty body on success (ClickUp returns 200)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
TAG="${2:-}"

if [[ -z "$TASK_ID" || -z "$TAG" ]]; then
  echo "Usage: cu-tag-remove.sh <task_id> <tag>" >&2
  exit 1
fi

TAG=$(echo "$TAG" | tr '[:upper:]' '[:lower:]')
TAG_ENCODED=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$TAG")

RESPONSE=$(_cu_delete "${CU_BASE}/task/${TASK_ID}/tag/${TAG_ENCODED}")
if [[ -z "$RESPONSE" ]]; then
  echo "{\"removed\": true, \"task_id\": \"${TASK_ID}\", \"tag\": \"${TAG}\"}"
else
  echo "$RESPONSE" | _pp
fi
