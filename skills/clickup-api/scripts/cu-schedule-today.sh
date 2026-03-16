#!/usr/bin/env bash
# cu-schedule-today.sh — Show today's full schedule in Asia/Manila timezone
#
# Usage: cu-schedule-today.sh [--raw]
#
# Options:
#   --raw     Output raw JSON array of tasks instead of formatted timeline
#
# Queries these lists (all schedule-relevant):
#   901604362025  Personal List     (Morning/Evening Routine)
#   901604409717  Others            (Meals, Pickpacer, transitions)
#   901604361974  Run List          (Morning/Noon/Evening sessions)
#   901604362284  work              (Accenture block)
#   901604386916  GEN - General     (Daily Check-in)
#
# Note: Fetches first page (100) of each list, filters client-side by Manila date.
# Exit:   0 always

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

RAW=false
[[ "${1:-}" == "--raw" ]] && RAW=true

LISTS=(901604362025 901604409717 901604361974 901604362284 901604386916 901604342078 901604314839 901604318618 901604318441 901604353987 901604354127 901604388639 901604832496 901604361967 901604361973 901604531431 901604409689 901604765860 901605383401 901605680981 901605645075 901605120956 901611468224)
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Fetch all lists in parallel using curl
for LIST_ID in "${LISTS[@]}"; do
  curl -s -H "Authorization: ${CU_TOKEN}" \
    "${CU_BASE}/list/${LIST_ID}/task?include_closed=true&subtasks=false&page=0" \
    > "${TMPDIR}/${LIST_ID}.json" &
done
wait  # Wait for all parallel fetches

# Compute Manila day range + process + display using Python
python3 - "$TMPDIR" "$RAW" "${LISTS[@]}" <<'PYEOF'
import json, sys, os
from datetime import datetime, timezone, timedelta

tmpdir, raw = sys.argv[1], sys.argv[2] == "True"
list_ids = sys.argv[3:]

manila = timezone(timedelta(hours=8))
today = datetime.now(manila).date()
day_start = datetime(today.year, today.month, today.day,  0,  0,  0, tzinfo=manila)
day_end   = datetime(today.year, today.month, today.day, 23, 59, 59, tzinfo=manila)
start_ms  = int(day_start.timestamp() * 1000)
end_ms    = int(day_end.timestamp() * 1000)
label     = today.strftime("%A, %B %-d, %Y")

def in_day(ms):
    return ms and start_ms <= int(ms) <= end_ms

seen = set()
tasks_today = []
for lid in list_ids:
    fpath = os.path.join(tmpdir, f"{lid}.json")
    try:
        with open(fpath) as f:
            data = json.load(f)
        for t in data.get("tasks", []):
            tid = t.get("id")
            if tid in seen:
                continue
            seen.add(tid)
            if in_day(t.get("start_date")) or in_day(t.get("due_date")):
                tasks_today.append(t)
    except Exception as e:
        sys.stderr.write(f"[warn] list {lid}: {e}\n")

if raw:
    print(json.dumps(tasks_today, indent=2))
    sys.exit(0)

def fmt_time(ms):
    if not ms:
        return None
    return datetime.fromtimestamp(int(ms)/1000, tz=timezone.utc).astimezone(manila).strftime("%H:%M")

def sort_key(t):
    return int(t.get("start_date") or t.get("due_date") or 0)

print(f"📅 Today — {label}")
print()

if not tasks_today:
    print("  (no tasks scheduled today)")
    sys.exit(0)

for t in sorted(tasks_today, key=sort_key):
    s_ms = t.get("start_date")
    d_ms = t.get("due_date")
    s_str = fmt_time(s_ms)
    d_str = fmt_time(d_ms)

    if s_str and d_str and s_ms != d_ms:
        time_str = f"{s_str}–{d_str}"
    elif s_str:
        time_str = s_str
    elif d_str:
        time_str = d_str
    else:
        time_str = "all-day"

    name = t.get("name", "(unnamed)")
    status = (t.get("status") or {}).get("status", "?")
    list_name = (t.get("list") or {}).get("name", "")

    dur_str = ""
    if s_ms and d_ms and int(d_ms) > int(s_ms):
        mins = (int(d_ms) - int(s_ms)) // 60000
        if mins >= 60:
            h, m = divmod(mins, 60)
            dur_str = f" [{h}h{f'{m}m' if m else ''}]"
        elif mins > 0:
            dur_str = f" [{mins}m]"

    icon = "✓" if status == "complete" else "·"
    print(f"  {icon} {time_str:<13}  {name}{dur_str}  — {list_name}")
PYEOF
