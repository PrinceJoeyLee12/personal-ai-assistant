---
name: clickup-api
description: Direct ClickUp REST API scripts for all operations — task CRUD, subtasks, custom fields, tags, comments, time tracking, schedule queries, list filtering, and full-workspace search. Use these scripts instead of MCP. No OAuth needed — uses personal API token from ~/.openclaw/openclaw.json. Scripts live in skills/clickup-api/scripts/.
---

# ClickUp API — Script Library

All ClickUp operations as executable bash scripts. Direct REST API calls, no MCP or OAuth required. Token auto-loaded from `~/.openclaw/openclaw.json`.

**Scripts dir:** `~/.openclaw/workspace/skills/clickup-api/scripts/`  
**Team/Workspace ID:** `9016539972` (Pickpacer's Workspace)  
**Timezone:** Always `Asia/Manila` (UTC+8). Convert dates to UTC milliseconds for API.

---

## Quick Reference

| Script | What It Does |
|--------|-------------|
| `cu-task-create.sh` | Create a task or subtask in any list |
| `cu-task-get.sh` | Get full task details (with subtasks + custom fields) |
| `cu-task-update.sh` | Update any task field |
| `cu-task-close.sh` | Mark a task as complete |
| `cu-task-delete.sh` | Delete a task permanently |
| `cu-task-search.sh` | Search tasks by keyword or tag |
| `cu-field-set.sh` | Set any custom field value on a task |
| `cu-tag-add.sh` | Add a tag to a task |
| `cu-tag-remove.sh` | Remove a tag from a task |
| `cu-comment-add.sh` | Post a comment on a task |
| `cu-comment-list.sh` | List all comments on a task |
| `cu-time-start.sh` | Start time tracking on a task |
| `cu-time-stop.sh` | Stop the active time tracker |
| `cu-time-log.sh` | Log time manually on a task |
| `cu-time-current.sh` | Check which timer is currently running |
| `cu-time-list.sh` | List all time entries for a task |
| `cu-list-tasks.sh` | Get tasks from a list with optional filters |
| `cu-list-get.sh` | Get metadata for a list |
| `cu-schedule-today.sh` | Show today's full schedule (Manila TZ) |
| `cu-schedule-date.sh` | Show schedule for any date (Manila TZ) |
| `cu-search.sh` | Full-workspace keyword search |
| `cu-workspace-info.sh` | Workspace/team info and members |

---

## Usage

Set a convenience alias for the scripts directory:
```bash
S=~/.openclaw/workspace/skills/clickup-api/scripts
```

### Task Operations

```bash
# Create a task (required: --list, --name)
$S/cu-task-create.sh --list 901604386916 --name "Daily Check-in" --priority 1 --tags "routine"

# Create with full options
$S/cu-task-create.sh \
  --list 901604362025 \
  --name "Morning Routine" \
  --status "to do" \
  --priority 1 \
  --start 1773622800000 \
  --due 1773626400000 \
  --time-est 3600000 \
  --tags "block time,routine"

# Create a subtask
$S/cu-task-create.sh --list 901604362025 --name "Bible reading" --parent abc123def

# Get task details
$S/cu-task-get.sh abc123def

# Update a task
$S/cu-task-update.sh abc123def --status "inprogress" --priority 2

# Update multiple fields
$S/cu-task-update.sh abc123def --name "New Name" --due 1773709200000

# Close (mark complete)
$S/cu-task-close.sh abc123def

# Delete
$S/cu-task-delete.sh abc123def
```

### Custom Fields

```bash
# ABC Task Category (drop_down by index)
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 0    # A Task-1
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 1    # A Task-2
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 2    # B Task-1
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 3    # B Task-2
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 4    # routine-1
$S/cu-field-set.sh <task_id> 241293c9-b8fb-4d0b-8563-7091c3c27eb7 5    # routine-2

# Categorize (drop_down by index)
$S/cu-field-set.sh <task_id> ec149710-5cf6-42f0-b24e-3eb241182914 0    # Non-negotiable
$S/cu-field-set.sh <task_id> ec149710-5cf6-42f0-b24e-3eb241182914 1    # Delegate
$S/cu-field-set.sh <task_id> ec149710-5cf6-42f0-b24e-3eb241182914 2    # Negotiable
$S/cu-field-set.sh <task_id> ec149710-5cf6-42f0-b24e-3eb241182914 3    # Eliminate

# Budget (PHP amount — currency)
$S/cu-field-set.sh <task_id> 72b72734-93dd-411f-a33f-3058b4d79875 5000

# Actual Spend
$S/cu-field-set.sh <task_id> 82595661-6cb3-46b1-99df-e57a1ec842b6 4500

# Income
$S/cu-field-set.sh <task_id> b3ddf778-72a7-4863-9eea-b11e25c4fda0 30000

# Partial Payment
$S/cu-field-set.sh <task_id> 482687ed-96ad-46d7-9636-4229fcfcb87f 2000

# Is paid (checkbox)
$S/cu-field-set.sh <task_id> 0b5aeafb-e514-40fd-878f-517516fa5d46 true
$S/cu-field-set.sh <task_id> 0b5aeafb-e514-40fd-878f-517516fa5d46 false

# In Debt To (text)
$S/cu-field-set.sh <task_id> bdf3bf3f-5f76-4789-8c92-5c8bfffb3239 "BDO"

# Progress (0-100)
$S/cu-field-set.sh <task_id> 708a825f-8719-4e06-8322-4d1594636a02 50
```

### Tags

```bash
$S/cu-tag-add.sh <task_id> "needs budget"
$S/cu-tag-add.sh <task_id> "march 2026"
$S/cu-tag-add.sh <task_id> "routine"
$S/cu-tag-add.sh <task_id> "block time"
$S/cu-tag-remove.sh <task_id> "old-tag"
```

### Comments

```bash
$S/cu-comment-add.sh <task_id> "Paid via GCash on March 16"
$S/cu-comment-list.sh <task_id>
```

### Time Tracking

```bash
# Start timer
$S/cu-time-start.sh <task_id>
$S/cu-time-start.sh <task_id> --desc "Deep work on Pickpacer"

# Stop active timer
$S/cu-time-stop.sh

# Check what's running
$S/cu-time-current.sh

# Log time manually (duration in ms: 3600000 = 1h, 1800000 = 30m)
$S/cu-time-log.sh <task_id> 3600000
$S/cu-time-log.sh <task_id> 5400000 --desc "Morning run session"

# List time entries for a task
$S/cu-time-list.sh <task_id>
```

### Schedule Queries

```bash
# Today's full schedule (Manila TZ)
$S/cu-schedule-today.sh

# Specific date
$S/cu-schedule-date.sh 2026-03-17
$S/cu-schedule-date.sh 2026-04-01

# Raw JSON output
$S/cu-schedule-today.sh --raw
$S/cu-schedule-date.sh 2026-03-17 --raw
```

### List Queries & Search

```bash
# All open tasks in a list
$S/cu-list-tasks.sh 901604386916

# Include closed tasks
$S/cu-list-tasks.sh 901604362025 --include-closed

# With date range filter (start_date)
$S/cu-list-tasks.sh 901604362025 --start-gt 1773622800000 --start-lt 1773709200000

# With due date range
$S/cu-list-tasks.sh 901604353987 --due-gt 1773622800000 --due-lt 1773795600000

# Filter by status
$S/cu-list-tasks.sh 901604386916 --status "inprogress"

# Include subtasks
$S/cu-list-tasks.sh 901604361973 --subtasks

# Get list metadata
$S/cu-list-get.sh 901604362025

# Search workspace by keyword
$S/cu-search.sh "house binaliw"
$S/cu-search.sh "march 2026" --tag

# Search a specific list
$S/cu-task-search.sh "morning routine" --list 901604362025

# Workspace info
$S/cu-workspace-info.sh
```

---

## Custom Field IDs

| Field | ID | Type | Values |
|-------|----|------|--------|
| ABC Task Category | `241293c9-b8fb-4d0b-8563-7091c3c27eb7` | drop_down | 0=A Task-1, 1=A Task-2, 2=B Task-1, 3=B Task-2, 4=routine-1, 5=routine-2 |
| Categorize | `ec149710-5cf6-42f0-b24e-3eb241182914` | drop_down | 0=Non-negotiable, 1=Delegate, 2=Negotiable, 3=Eliminate |
| Budget | `72b72734-93dd-411f-a33f-3058b4d79875` | currency | PHP numeric |
| Actual Spend | `82595661-6cb3-46b1-99df-e57a1ec842b6` | currency | PHP numeric |
| Income | `b3ddf778-72a7-4863-9eea-b11e25c4fda0` | currency | PHP numeric |
| Partial Payment | `482687ed-96ad-46d7-9636-4229fcfcb87f` | currency | PHP numeric |
| Is paid | `0b5aeafb-e514-40fd-878f-517516fa5d46` | checkbox | true / false |
| In Debt To | `bdf3bf3f-5f76-4789-8c92-5c8bfffb3239` | short_text | string |
| progress | `708a825f-8719-4e06-8322-4d1594636a02` | manual_progress | 0–100 |
| Documentation | `e45d579a-0b6c-4a74-8102-366d9d169d41` | task_link | task_id string |
| Testing Scripts | `db39025e-7b1f-4a9d-836d-0867a2d80a8e` | task_link | task_id string |
| deployment | `34fd7270-a384-4872-993e-8af4607df370` | task_link | task_id string |

---

## List IDs Reference

| Domain | List | ID |
|--------|------|----|
| Personal | Personal List | `901604362025` |
| Personal | Others | `901604409717` |
| Family | Family List | `901604361973` |
| Family | Family Home Renovation | `901604531431` |
| Love | Love List | `901604409689` |
| Love | Apartment List | `901604765860` |
| Love | House - Binaliw List | `901605383401` |
| Love | Love Financial List | `901605680981` |
| Running | Run List | `901604361974` |
| Athletes | RunSmartWithLee List | `901604361967` |
| Pickpacer | Prince Joey Lee List | `901604342078` |
| Pickpacer | GEN - General List | `901604386916` |
| Pickpacer | Core - General List | `901604314839` |
| Pickpacer | Core WD - Website Dev | `901604318618` |
| Pickpacer | Core BIT - Bug Tracking | `901604318441` |
| Pickpacer | F&O Main List | `901604353987` |
| Pickpacer | Expenses List | `901604354127` |
| Pickpacer | F&O Wages List | `901604388639` |
| Pickpacer | Marketing Main List | `901604832496` |
| Pickpacer | HR - Hr List | `901605120956` |
| Pickpacer | Sales List | `901611468224` |
| Hardlix | HardlixHardware Business | `901605645075` |
| Work | work | `901604362284` |

---

## Statuses

- `to do` — Not started
- `inprogress` — In progress
- `complete` — Done

## Priority API Values

| Priority | Value |
|----------|-------|
| Urgent | `1` |
| High | `2` |
| Normal | `3` |
| Low | `4` |
| None | omit field |

## Time Conversions (Manila → UTC ms)

```
1 hour = 3600000 ms
30 min = 1800000 ms
1.5 hr = 5400000 ms
Manila UTC offset = +8h = +28800 seconds

Manila midnight (00:00) = previous UTC day 16:00:00
Manila 05:00 = previous UTC day 21:00:00
```
