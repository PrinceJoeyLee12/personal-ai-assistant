#!/usr/bin/env bash
# cu-config.sh — Shared ClickUp configuration. Source this, do not run directly.
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/cu-config.sh"

CU_BASE="https://api.clickup.com/api/v2"
CU_TEAM_ID="9016539972"

# Always read token from ~/.openclaw/openclaw.json (authoritative).
# Falls back to CLICKUP_API_TOKEN env var only if the file is missing.
_cfg="${HOME}/.openclaw/openclaw.json"
if [[ -f "$_cfg" ]]; then
  CU_TOKEN=$(jq -r '.env.CLICKUP_API_TOKEN // empty' "$_cfg" 2>/dev/null || true)
fi
# Fall back to env var if file didn't yield a token
if [[ -z "${CU_TOKEN:-}" ]]; then
  CU_TOKEN="${CLICKUP_API_TOKEN:-}"
fi
CU_TEAM="${CLICKUP_TEAM_ID:-${CU_TEAM_ID}}"

if [[ -z "$CU_TOKEN" ]]; then
  echo "ERROR: CLICKUP_API_TOKEN not set. Add to ~/.openclaw/openclaw.json or run: export CLICKUP_API_TOKEN=pk_..." >&2
  return 1 2>/dev/null || exit 1
fi

# HTTP helpers — all silent, output goes to stdout
_cu_get()    { curl -s     -H "Authorization: ${CU_TOKEN}" "$@"; }
_cu_post()   { curl -s -X POST   -H "Authorization: ${CU_TOKEN}" -H "Content-Type: application/json" "$@"; }
_cu_put()    { curl -s -X PUT    -H "Authorization: ${CU_TOKEN}" -H "Content-Type: application/json" "$@"; }
_cu_delete() { curl -s -X DELETE -H "Authorization: ${CU_TOKEN}" "$@"; }

# Pretty-print JSON (pass-through if jq unavailable)
_pp() { if command -v jq &>/dev/null; then jq '.'; else cat; fi; }
