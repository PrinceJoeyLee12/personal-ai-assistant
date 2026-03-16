#!/usr/bin/env bash
# cu-tag-add.sh — Add a tag to a ClickUp task
#
# Usage: cu-tag-add.sh <task_id> <tag>
#
# Notes:
#   - Tags are always lowercased
#   - Spaces in tag names are preserved (URL-encoded in the request)
#   - Example tags: "routine", "needs budget", "march 2026", "block time"
#
# Output: Empty body on success (ClickUp returns 200 with no body)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
TAG="${2:-}"

if [[ -z "$TASK_ID" || -z "$TAG" ]]; then
  echo "Usage: cu-tag-add.sh <task_id> <tag>" >&2
  exit 1
fi

# Lowercase the tag
TAG=$(echo "$TAG" | tr '[:upper:]' '[:lower:]')

# URL-encode the tag
TAG_ENCODED=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$TAG")

RESPONSE=$(_cu_post "${CU_BASE}/task/${TASK_ID}/tag/${TAG_ENCODED}" -d '{}')
if [[ -z "$RESPONSE" ]]; then
  echo "{\"added\": true, \"task_id\": \"${TASK_ID}\", \"tag\": \"${TAG}\"}"
else
  echo "$RESPONSE" | _pp
fi
