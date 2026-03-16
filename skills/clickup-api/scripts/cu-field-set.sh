#!/usr/bin/env bash
# cu-field-set.sh — Set a custom field value on a ClickUp task
#
# Usage: cu-field-set.sh <task_id> <field_id> <value>
#
# Arguments:
#   <task_id>    Task ID
#   <field_id>   Custom field UUID
#   <value>      Value to set — type is auto-detected:
#                  "true" / "false"  → boolean  (checkbox fields)
#                  numeric           → number    (currency, drop_down index, progress)
#                  anything else     → string    (short_text, task_link)
#
# Field ID Reference:
#   ABC Task Category  241293c9-b8fb-4d0b-8563-7091c3c27eb7  (0-5 index)
#   Categorize         ec149710-5cf6-42f0-b24e-3eb241182914  (0-3 index)
#   Budget             72b72734-93dd-411f-a33f-3058b4d79875  (PHP numeric)
#   Actual Spend       82595661-6cb3-46b1-99df-e57a1ec842b6  (PHP numeric)
#   Income             b3ddf778-72a7-4863-9eea-b11e25c4fda0  (PHP numeric)
#   Partial Payment    482687ed-96ad-46d7-9636-4229fcfcb87f  (PHP numeric)
#   Is paid            0b5aeafb-e514-40fd-878f-517516fa5d46  (true/false)
#   In Debt To         bdf3bf3f-5f76-4789-8c92-5c8bfffb3239  (string)
#   progress           708a825f-8719-4e06-8322-4d1594636a02  (0-100)
#
# Output: JSON response (pretty-printed)
# Exit:   0 on success, 1 on error

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

TASK_ID="${1:-}"
FIELD_ID="${2:-}"
VALUE="${3:-}"

if [[ -z "$TASK_ID" || -z "$FIELD_ID" || -z "$VALUE" ]]; then
  echo "Usage: cu-field-set.sh <task_id> <field_id> <value>" >&2
  exit 1
fi

# Auto-detect value type
if [[ "$VALUE" == "true" || "$VALUE" == "false" ]]; then
  # Boolean
  BODY=$(jq -n --argjson v "$VALUE" '{value: $v}')
elif [[ "$VALUE" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  # Numeric (drop_down index, currency, progress)
  BODY=$(jq -n --argjson v "$VALUE" '{value: $v}')
else
  # String (short_text, task_link)
  BODY=$(jq -n --arg v "$VALUE" '{value: $v}')
fi

_cu_post "${CU_BASE}/task/${TASK_ID}/field/${FIELD_ID}" -d "$BODY" | _pp
