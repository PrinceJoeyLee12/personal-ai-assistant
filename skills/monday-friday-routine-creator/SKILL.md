---
name: monday-friday-routine-creator
description: Create Joey's common Monday to Friday routine in ClickUp. Use when Joey asks to set up his daily schedule for a weekday, including core work blocks, running sessions, and personal time. Handles routine scheduling and custom field applications based on his established patterns.
---

# Monday to Friday Routine Creator

This skill automates the creation of Joey's typical Monday to Friday daily schedule in ClickUp, ensuring consistency with his established routines and priorities, including his seasonal adjustments for the Baby Season (March-June 2026).

## Core Rules & Principles

All tasks created by this skill adhere to Joey's core principles:

1.  **Timezone:** Always `Asia/Manila` (UTC+8).
2.  **Tags are always lowercase.**
3.  **Protected Routines:** Never schedules tasks during Joey's sacred Morning Routine (Prayer, Meditation, Bible, Run) or Evening Routine.
4.  **Ichigo Ichie:** Encourages focused presence in one domain at a time.
5.  **Ma:** Leaves deliberate empty space between tasks for breathing room.
6.  **Hara Hachi Bu:** Promotes sustainability by not over-scheduling.
7.  **Shizen:** Aligns tasks with natural energy rhythms (deep work post-run, lighter tasks later).

## Current Season Adjustments (March–June 2026 — Baby Season)

During this period:

*   **Running is reduced** to ~50-60 km/week, with shorter daily sessions.
*   **Wife & Baby priority is elevated** — evening blocks are protected for family time.
*   **Pickpacer** remains Priority A with dedicated deep work blocks.

## Workflow: Create Weekday Schedule

When Joey asks to build a schedule for a Monday to Friday date:

### Step 1: Validate Date

*   Ensure the provided date is a weekday (Monday-Friday).
*   Check if a schedule already exists for the target date. If so, inform Joey and ask if he wants to modify or overwrite.

### Step 2: Create Tasks (using `scripts/cu-schedule-weekday.sh`)

Use the `cu-schedule-weekday.sh` script to create each task in the correct ClickUp list with precise start/due times, priorities, tags, and custom fields. The script will follow the detailed template below.

### Step 3: Report

*   Show the created schedule as a timeline.
*   Note the total scheduled hours versus free time to ensure adherence to the `Ma` principle.

## Joey's Ideal Weekday Daily Schedule Template (ClickUp Task Details)

This template captures Joey's usual Monday to Friday routine based on the provided task IDs. All times are in Asia/Manila (UTC+8).

| Time (Manila) | Duration | Task Name | ClickUp List | List ID | Priority | Tags | Custom Fields |
|---------------|----------|-----------|--------------|---------|----------|------|---------------|
| 04:00 - 04:00 | all-day  | Daily Checkin Checklist | GEN - General List | `901604386916` | Urgent (`1`) | `routine` | ABC Task Category: `routine - 1` (4), Categorize: `Non-negotiable` (0) |
| 05:00 - 06:00 | 1h 30m   | Morning Routine | Personal List | `901604362025` | Normal (`3`) | `block time` | ABC Task Category: `routine - 1` (4), Categorize: `Non-negotiable` (0) |
| 06:00 - 07:00 | 1h       | Morning Session | Run List | `901604361974` | Urgent (`1`) | - | ABC Task Category: `A Task - 2` (1), Categorize: `Non-negotiable` (0) |
| 07:00 - 07:30 | 30m      | Settle down | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `B Task - 2` (3), Categorize: `Non-negotiable` (0) |
| 07:30 - 08:00 | 30m      | Breakfast | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 08:00 - 11:00 | 3h       | Work | work | `901604362284` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 11:00 - 11:30 | 30m      | Sleep | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `B Task - 1` (2), Categorize: `Non-negotiable` (0) |
| 12:00 - 01:00 | 1h       | Noon Session | Run List | `901604361974` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 01:00 - 01:30 | 30m      | Reading for 30mins | Personal List | `901604362025` | Normal (`3`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 01:00 - 02:30 | 1h 30m   | Prepare + Lunch | Others | `901604409717` | - | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 02:30 - 04:00 | 1h 30m   | Pickpacer | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 04:00 - 05:00 | 1h       | Prepare for a run | Others | `901604409717` | - | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 05:00 - 06:30 | 1h 30m   | Evening Session | Run List | `901604361974` | Urgent (`1`) | `block time` | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 07:00 - 07:30 | 30m      | Settle down | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 07:30 - 08:00 | 30m      | Dinner | Others | `901604409717` | Urgent (`1`) | - | ABC Task Category: `A Task - 1` (0), Categorize: `Non-negotiable` (0) |
| 08:00 - 08:30 | 30m      | Evening Routine | Personal List | `901604362025` | Normal (`3`) | - | ABC Task Category: `routine - 2` (5), Categorize: `Non-negotiable` (0) |


## API: Create Weekday Scheduled Task

This skill uses `cu-task-create.sh` with the following parameters for each task:

```bash
"$SCRIPT_DIR/cu-task-create.sh" \
  --list {LIST_ID} \
  --name "{TASK_NAME}" \
  --priority {PRIORITY_ID} \
  --start_date {START_DATE_MS} \
  --due_date {DUE_DATE_MS} \
  [--time_estimate {TIME_ESTIMATE_MS}] \
  [--tags "{TAG1},{TAG2}"] \
  [--custom_fields "{FIELD_ID_1}={VALUE_1},{FIELD_ID_2}={VALUE_2}"]
```

Refer to `TOOLS.md` for specific custom field IDs and their valid options. Always use the numerical `orderindex` for dropdown values when setting custom fields.
