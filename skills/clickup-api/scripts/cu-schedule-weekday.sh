#!/usr/bin/env bash
# cu-schedule-weekday.sh — Create Joey's common Monday-Friday routine in ClickUp for a specific date (Asia/Manila timezone)
#
# Usage: cu-schedule-weekday.sh <YYYY-MM-DD>
#
# Arguments:
#   <YYYY-MM-DD>   Date for which to create the weekday routine (must be a Monday-Friday)
#
# Exit:   0 on success, 1 on error or invalid date
#
# Requires: cu-task-create.sh from the same directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

DATE_ARG="${1:-}"

if [[ -z "$DATE_ARG" ]]; then
  echo "Usage: cu-schedule-weekday.sh <YYYY-MM-DD>" >&2
  exit 1
fi

# Validate date and check if it's a weekday using Python
DATE_INFO=$(python3 -c "
import sys
from datetime import datetime, timezone, timedelta

try:
    d = datetime.strptime('${DATE_ARG}', '%Y-%m-%d').date()
except ValueError:
    print(f'ERROR: Invalid date \'${DATE_ARG}\'. Use YYYY-MM-DD.', file=sys.stderr)
    sys.exit(1)

# Monday is 0, Sunday is 6
if d.weekday() >= 5: 
    print(f'ERROR: Date \'${DATE_ARG}\' is not a weekday (Monday-Friday).', file=sys.stderr)
    sys.exit(1)

manila = timezone(timedelta(hours=8))
day_start = datetime(d.year, d.month, d.day, 0, 0, 0, tzinfo=manila)

# Output UTC timestamps for start/due dates, and formatted date for task names
times = {}
times['04_00'] = int(day_start.replace(hour=4, minute=0, second=0).timestamp() * 1000)
times['05_00'] = int(day_start.replace(hour=5, minute=0, second=0).timestamp() * 1000)
times['06_00'] = int(day_start.replace(hour=6, minute=0, second=0).timestamp() * 1000)
times['07_00'] = int(day_start.replace(hour=7, minute=0, second=0).timestamp() * 1000)
times['07_30'] = int(day_start.replace(hour=7, minute=30, second=0).timestamp() * 1000)
times['08_00'] = int(day_start.replace(hour=8, minute=0, second=0).timestamp() * 1000)
times['11_00'] = int(day_start.replace(hour=11, minute=0, second=0).timestamp() * 1000)
times['11_30'] = int(day_start.replace(hour=11, minute=30, second=0).timestamp() * 1000)
times['12_00'] = int(day_start.replace(hour=12, minute=0, second=0).timestamp() * 1000)
times['13_00'] = int(day_start.replace(hour=13, minute=0, second=0).timestamp() * 1000)
times['14_30'] = int(day_start.replace(hour=14, minute=30, second=0).timestamp() * 1000)
times['16_00'] = int(day_start.replace(hour=16, minute=0, second=0).timestamp() * 1000)
times['17_00'] = int(day_start.replace(hour=17, minute=0, second=0).timestamp() * 1000)
times['18_30'] = int(day_start.replace(hour=18, minute=30, second=0).timestamp() * 1000)
times['19_00'] = int(day_start.replace(hour=19, minute=0, second=0).timestamp() * 1000)
times['19_30'] = int(day_start.replace(hour=19, minute=30, second=0).timestamp() * 1000)
times['20_00'] = int(day_start.replace(hour=20, minute=0, second=0).timestamp() * 1000)
times['20_30'] = int(day_start.replace(hour=20, minute=30, second=0).timestamp() * 1000)

print("DATE_FORMATTED=%s" % d.strftime('%B %-d, %Y'))
for hour, ts in times.items():
    print("TIME_%s=%s" % (hour, ts))
" || exit 1)

eval "$DATE_INFO"

echo "Creating weekday routine for $DATE_ARG..."

# Task 1: Daily Checkin Checklist (GEN - General List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604386916 --name "Daily Checkin Checklist" --priority 1 --start_date "${TIME_04_00}" --due_date "${TIME_04_00}" --tags "routine" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=4,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 2: Morning Routine (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Morning Routine" --priority 3 --start_date "${TIME_05_00}" --due_date "${TIME_06_00}" --time_estimate 5400000 --tags "block time" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=4,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 3: Morning Session (Run List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604361974 --name "Morning Session" --priority 1 --start_date "${TIME_06_00}" --due_date "${TIME_07_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=1,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 4: Settle down (Others List) - Morning
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Settle down" --priority 1 --start_date "${TIME_07_00}" --due_date "${TIME_07_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=3,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 5: Breakfast (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Breakfast" --priority 1 --due_date "${TIME_07_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 6: Work (work list)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362284 --name "Work" --priority 1 --start_date "${TIME_08_00}" --due_date "${TIME_11_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 7: Sleep (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Sleep" --priority 1 --start_date "${TIME_11_00}" --due_date "${TIME_11_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=2,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 8: Noon Session (Run List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604361974 --name "Noon Session" --priority 1 --start_date "${TIME_12_00}" --due_date "${TIME_13_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 9: Reading for 30mins (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Reading for 30mins" --priority 3 --start_date "${TIME_13_00}" --due_date "${TIME_13_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 10: Prepare + Lunch (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Prepare + Lunch" --start_date "${TIME_13_00}" --due_date "${TIME_14_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 11: Pickpacer (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Pickpacer" --priority 1 --start_date "${TIME_14_30}" --due_date "${TIME_16_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 12: Prepare for a run (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Prepare for a run" --start_date "${TIME_16_00}" --due_date "${TIME_17_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 13: Evening Session (Run List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604361974 --name "Evening Session" --priority 1 --start_date "${TIME_17_00}" --due_date "${TIME_18_30}" --time_estimate 5400000 --tags "block time" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 14: Settle down (Others List) - Evening
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Settle down" --priority 1 --start_date "${TIME_19_00}" --due_date "${TIME_19_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 15: Dinner (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Dinner" --priority 1 --due_date "${TIME_19_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 16: Evening Routine (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Evening Routine" --priority 3 --start_date "${TIME_20_00}" --due_date "${TIME_20_30}" --time_estimate 1800000 --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=5,ec149710-5cf6-42f0-b24e-3eb241182914=0"

echo "Weekday routine creation complete for $DATE_ARG."
