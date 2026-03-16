#!/usr/bin/env bash
# cu-schedule-sunday.sh — Create Joey's common Sunday routine in ClickUp for a specific date (Asia/Manila timezone)
#
# Usage: cu-schedule-sunday.sh <YYYY-MM-DD>
#
# Arguments:
#   <YYYY-MM-DD>   Date for which to create the Sunday routine (must be a Sunday)
#
# Exit:   0 on success, 1 on error or invalid date
#
# Requires: cu-task-create.sh from the same directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/cu-config.sh"

DATE_ARG="${1:-}"

if [[ -z "$DATE_ARG" ]]; then
  echo "Usage: cu-schedule-sunday.sh <YYYY-MM-DD>" >&2
  exit 1
fi

# Validate date and check if it's a Sunday using Python
DATE_INFO=$(python3 -c "
import sys
from datetime import datetime, timezone, timedelta

try:
    d = datetime.strptime('${DATE_ARG}', '%Y-%m-%d').date()
except ValueError:
    print(f'ERROR: Invalid date \'${DATE_ARG}\'. Use YYYY-MM-DD.', file=sys.stderr)
    sys.exit(1)

if d.weekday() != 6: # Monday is 0, Sunday is 6
    print(f'ERROR: Date \'${DATE_ARG}\' is not a Sunday.', file=sys.stderr)
    sys.exit(1)

manila = timezone(timedelta(hours=8))
day_start = datetime(d.year, d.month, d.day, 0, 0, 0, tzinfo=manila)

# Output UTC timestamps for start/due dates, and formatted date for task names
times = {}
times['04:00'] = int(day_start.replace(hour=4, minute=0, second=0).timestamp() * 1000)
times['05:00'] = int(day_start.replace(hour=5, minute=0, second=0).timestamp() * 1000)
times['06:00'] = int(day_start.replace(hour=6, minute=0, second=0).timestamp() * 1000)
times['07:00'] = int(day_start.replace(hour=7, minute=0, second=0).timestamp() * 1000)
times['07:30'] = int(day_start.replace(hour=7, minute=30, second=0).timestamp() * 1000)
times['08:00'] = int(day_start.replace(hour=8, minute=0, second=0).timestamp() * 1000)
times['11:00'] = int(day_start.replace(hour=11, minute=0, second=0).timestamp() * 1000)
times['11:30'] = int(day_start.replace(hour=11, minute=30, second=0).timestamp() * 1000)
times['12:00'] = int(day_start.replace(hour=12, minute=0, second=0).timestamp() * 1000)
times['13:00'] = int(day_start.replace(hour=13, minute=0, second=0).timestamp() * 1000)
times['13:30'] = int(day_start.replace(hour=13, minute=30, second=0).timestamp() * 1000) # For Prepare + Lunch
times['14:30'] = int(day_start.replace(hour=14, minute=30, second=0).timestamp() * 1000) # For Pickpacer
times['15:00'] = int(day_start.replace(hour=15, minute=0, second=0).timestamp() * 1000) # For Church
times['16:00'] = int(day_start.replace(hour=16, minute=0, second=0).timestamp() * 1000) # For Prepare for run / Financial Planning Start
times['17:00'] = int(day_start.replace(hour=17, minute=0, second=0).timestamp() * 1000) # For Evening Session Start
times['18:30'] = int(day_start.replace(hour=18, minute=30, second=0).timestamp() * 1000) # For Evening Session End
times['19:00'] = int(day_start.replace(hour=19, minute=0, second=0).timestamp() * 1000) # For Settle down Evening Start
times['19:30'] = int(day_start.replace(hour=19, minute=30, second=0).timestamp() * 1000) # For Dinner / Settle down Evening End
times['20:00'] = int(day_start.replace(hour=20, minute=0, second=0).timestamp() * 1000) # For Evening Routine Start
times['20:30'] = int(day_start.replace(hour=20, minute=30, second=0).timestamp() * 1000) # For Evening Routine End


print(f"DATE_FORMATTED={d.strftime('%B %-d, %Y')}")
for hour, ts in times.items():
    print(f"TIME_{hour.replace(':', '_')}={ts}")
" || exit 1)

eval "$DATE_INFO"

echo "Creating Sunday routine for $DATE_ARG..."

# Task 1: Morning Routine (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Morning Routine" --priority 3 --start_date "${TIME_05_00}" --due_date "${TIME_06_00}" --time_estimate 5400000 --tags "block time" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=4,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 2: Morning Session (Run List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604361974 --name "Morning Session" --priority 1 --start_date "${TIME_06_00}" --due_date "${TIME_07_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=1,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 3: Settle down (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Settle down" --priority 1 --start_date "${TIME_07_00}" --due_date "${TIME_07_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=1,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 4: Breakfast (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Breakfast" --priority 1 --due_date "${TIME_07_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 5: Sleep (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Sleep" --priority 1 --start_date "${TIME_11_00}" --due_date "${TIME_11_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 6: Prepare + Lunch (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Prepare + Lunch" --due_date "${TIME_13_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 7: Reading for 30mins (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Reading for 30mins" --priority 3 --due_date "${TIME_13_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 8: Watch movie with love (Love List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409689 --name "Watch movie with love" --priority 1 --start_date "${TIME_13_30}" --due_date "${TIME_15_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 9: Church (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Church" --priority 3 --start_date "${TIME_15_00}" --due_date "${TIME_16_00}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 10: Financial Planning (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Financial Planning (${DATE_FORMATTED})" --priority 3 --start_date "${TIME_16_00}" --due_date "${TIME_17_30}" --time_estimate 5400000 --tags "block time" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=2,ec149710-5cf6-42f0-b24e-3eb241182914=2"

# Task 11: Dinner (Others List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604409717 --name "Dinner" --priority 1 --due_date "${TIME_19_30}" --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=0,ec149710-5cf6-42f0-b24e-3eb241182914=0"

# Task 12: Evening Routine (Personal List)
"$SCRIPT_DIR/cu-task-create.sh" --list 901604362025 --name "Evening Routine" --priority 3 --start_date "${TIME_20_00}" --due_date "${TIME_20_30}" --time_estimate 1800000 --custom_fields "241293c9-b8fb-4d0b-8563-7091c3c27eb7=5,ec149710-5cf6-42f0-b24e-3eb241182914=0"

echo "Sunday routine creation complete for $DATE_ARG."
