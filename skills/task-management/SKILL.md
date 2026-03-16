---
name: task-management
description: General ClickUp task creation, updates, queries, and organization across all of Joey's life domains. Handles routing tasks to correct lists, setting custom fields, managing priorities, tags, statuses, and parent-child relationships.
---

# Task Management — ClickUp Operations

Create, update, query, and organize tasks across all of Joey's ClickUp workspace. This skill handles routing to the correct list, enforcing conventions, and maintaining task hygiene.

## Core Rules

1. **Timezone:** Always `Asia/Manila` (UTC+8). Convert all dates to UTC ms for API calls.
2. **Tags are always lowercase** — no exceptions
3. **Route to the correct list** — Every task MUST go to the list matching its domain. See routing table below.
4. **Parent before child** — Always create parent tasks first when building hierarchical tasks.
5. **Custom fields are required** — Set `ABC Task Category` and `Categorize` on every task creation.
6. **Financial tasks** → defer to the `financial-budgeting` skill for those.
7. **Scheduled tasks** → defer to the `calendar-scheduling` skill if it involves time blocks.
8. **Check before creating** — Search for existing tasks before creating duplicates.

## ClickUp API Reference

**Base URL:** `https://api.clickup.com/api/v2`
**Auth Header:** `Authorization: {CLICKUP_API_TOKEN}` (from `~/.openclaw/openclaw.json` env)
**Workspace ID / Team ID:** `9016539972`

## Task Routing — Which List Gets What?

### Personal Domain (`agent-personal`)

| List | ID | Use For |
|------|----|---------|
| Personal List | `901604362025` | Personal goals, habits, routines, self-improvement |
| Others | `901604409717` | Activity logging, transitions, meals, general personal tasks with start/end times |

### Family Domain (`agent-family`)

| List | ID | Use For |
|------|----|---------|
| Family List | `901604361973` | Family tasks, allowances, family events |
| Family Home Renovation | `901604531431` | Home renovation projects |

### Love / Wife Domain (`agent-wife`)

| List | ID | Use For |
|------|----|---------|
| Love List | `901604409689` | Wife-related tasks, relationship, dates |
| Apartment List | `901604765860` | Apartment matters |
| House - Binaliw List | `901605383401` | House Binaliw loan & related |
| Love Financial List | `901605680981` | Financial matters related to love/wife |

### Running Domain (`agent-running`)

| List | ID | Use For |
|------|----|---------|
| Run List | `901604361974` | Training sessions, races, running plans |

### Athletes / Coaching Domain (`agent-athletes`)

| List | ID | Use For |
|------|----|---------|
| RunSmartWithLee List | `901604361967` | Coaching, athlete management |

### Pickpacer Domain (`agent-pickpacer`)

| List | ID | Use For |
|------|----|---------|
| Prince Joey Lee List | `901604342078` | General Pickpacer / Joey's exec tasks |
| GEN - General List | `901604386916` | Daily check-ins, general Pickpacer ops |
| Core - General List | `901604314839` | Core product work |
| Core WD - Website Dev | `901604318618` | Website development |
| Core BIT - Bug Tracking | `901604318441` | Bug reports and issues |
| F&O Main List | `901604353987` | Finance & operations |
| Expenses List | `901604354127` | Business expenses |
| F&O Wages List | `901604388639` | Payroll/wages |
| Marketing Main List | `901604832496` | Marketing tasks |
| HR - Hr List | `901605120956` | Human resources |
| Sales List | `901611468224` | Sales tasks |

### Hardlix Domain (`agent-hardlix`)

| List | ID | Use For |
|------|----|---------|
| HardlixHardware Business | `901605645075` | All Hardlix business tasks |

### Work / Accenture (hidden/personal)

| List | ID | Use For |
|------|----|---------|
| work | `901604362284` | Accenture day job tasks (hidden folder in Personal space) |

## Custom Fields — Always Set These

### Required on Every Task

| Field | ID | Type | How to Set |
|-------|----|------|------------|
| ABC Task Category | `241293c9-b8fb-4d0b-8563-7091c3c27eb7` | drop_down | Index: 0=`A Task - 1`, 1=`A Task - 2`, 2=`B Task - 1`, 3=`B Task - 2`, 4=`routine - 1`, 5=`routine - 2` |
| Categorize | `ec149710-5cf6-42f0-b24e-3eb241182914` | drop_down | Index: 0=`Non-negotiable`, 1=`Delegate`, 2=`Negotiable`, 3=`Eliminate` |

### ABC Task Category Decision Guide

| Category | When to Use | Examples |
|----------|------------|---------|
| A Task - 1 | Top priority, identity-level work | Pickpacer core dev, key running session, wife/baby priority |
| A Task - 2 | High priority, important but not #1 | Pickpacer marketing, secondary business task |
| B Task - 1 | Medium priority, needs doing | Admin, compliance filings, family errands |
| B Task - 2 | Medium-low, can flex | Nice-to-have improvements, research |
| routine - 1 | Core recurring tasks | Morning routine, daily check-in, monthly expenses |
| routine - 2 | Secondary recurring tasks | Lower-priority recurring items |

### Categorize Decision Guide

| Category | When to Use |
|----------|------------|
| Non-negotiable | Big Three priorities (Pickpacer, Running, Health), sacred routines, compliance |
| Delegate | Tasks someone else can handle |
| Negotiable | Flexible — can be moved, deferred, or adjusted |
| Eliminate | Noise — should be removed or deprioritized aggressively |

### Financial Fields (Set on financial tasks only)

| Field | ID | Type |
|-------|----|------|
| Budget | `72b72734-93dd-411f-a33f-3058b4d79875` | currency |
| Actual Spend | `82595661-6cb3-46b1-99df-e57a1ec842b6` | currency |
| Income | `b3ddf778-72a7-4863-9eea-b11e25c4fda0` | currency |
| Partial Payment | `482687ed-96ad-46d7-9636-4229fcfcb87f` | currency |
| Is paid | `0b5aeafb-e514-40fd-878f-517516fa5d46` | checkbox |
| In Debt To | `bdf3bf3f-5f76-4789-8c92-5c8bfffb3239` | short_text |

### Other Fields

| Field | ID | Type |
|-------|----|------|
| progress | `708a825f-8719-4e06-8322-4d1594636a02` | manual_progress (0–100) |
| Documentation | `e45d579a-0b6c-4a74-8102-366d9d169d41` | task_link |
| Testing Scripts | `db39025e-7b1f-4a9d-836d-0867a2d80a8e` | task_link |
| deployment | `34fd7270-a384-4872-993e-8af4607df370` | task_link |

## Statuses (Universal across all Lists)

- `to do` — Not started
- `inprogress` — Work in progress
- `complete` — Done

## Priority Mapping

| Priority | API Value | Emoji |
|----------|-----------|-------|
| Urgent | 1 | 🔴 |
| High | 2 | 🟠 |
| Normal | 3 | 🟡 |
| Low | 4 | 🔵 |
| None | null | — |

## Tag Rules

| Tag | When to Use |
|-----|------------|
| `routine` | Any recurring task (daily, weekly, monthly) |
| `needs budget` | Any task requiring financial allocation |
| `[month] [year]` | Financial tasks ONLY — e.g., `march 2026` |
| `block time` | Calendar block-time tasks (routines, focus blocks) |

## API Operations

### Create a Task

```bash
curl -X POST "https://api.clickup.com/api/v2/list/{list_id}/task" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{
    "name": "Task name",
    "description": "Optional description",
    "status": "to do",
    "priority": 1,
    "parent": null,
    "tags": ["tag1", "tag2"],
    "start_date": 1773622800000,
    "due_date": 1773626400000,
    "time_estimate": 3600000
  }'
```

### Create a Sub-task

Same as above, but include `"parent": "{parent_task_id}"`.

### Update a Task

```bash
curl -X PUT "https://api.clickup.com/api/v2/task/{task_id}" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{
    "name": "Updated name",
    "status": "inprogress",
    "priority": 2
  }'
```

### Set Custom Field

```bash
curl -X POST "https://api.clickup.com/api/v2/task/{task_id}/field/{field_id}" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{"value": <value>}'
```

For drop_down fields, value is the option **index** (integer).
For currency fields, value is a **number**.
For checkbox fields, value is **true** or **false**.
For short_text fields, value is a **string**.

### Get Task Details

```bash
curl -s "https://api.clickup.com/api/v2/task/{task_id}?include_subtasks=true&custom_fields=true" \
  -H "Authorization: {token}"
```

### Search Tasks

```bash
# By tag
curl -s "https://api.clickup.com/api/v2/team/9016539972/task?tags[]={tag}&include_closed=true" \
  -H "Authorization: {token}"

# By list
curl -s "https://api.clickup.com/api/v2/list/{list_id}/task?include_closed=true&subtasks=true" \
  -H "Authorization: {token}"

# By date range (tasks starting within range)
curl -s "https://api.clickup.com/api/v2/list/{list_id}/task?start_date_gt={start_ms}&start_date_lt={end_ms}" \
  -H "Authorization: {token}"
```

### Add Tag to Task

```bash
curl -X POST "https://api.clickup.com/api/v2/task/{task_id}/tag/{tag_name}" \
  -H "Authorization: {token}"
```

### Get List Tasks (Filtered)

```bash
curl -s "https://api.clickup.com/api/v2/list/{list_id}/task?statuses[]=to%20do&statuses[]=inprogress&subtasks=true" \
  -H "Authorization: {token}"
```

## Workflow: Joey Asks to Create a Task

1. **Identify the domain** from context — keywords, explicit mention, or ask
2. **Route to correct list** using the routing table
3. **Determine priority** — Pickpacer/Running/Health = urgent. Family/Love = high/urgent. Admin = normal.
4. **Set ABC Task Category** based on decision guide
5. **Set Categorize** based on decision guide
6. **Check for duplicates** — search by name in the target list
7. **Create the task** with all fields populated
8. **If financial** → also set Budget, tags per financial-budgeting skill
9. **If scheduled** → also set start_date, due_date per calendar-scheduling skill
10. **Report** — confirm task created with ID, link, and summary

## Workflow: Joey Asks Task Status

1. Get the task by ID or search by name
2. Show: name, status, priority, due date, custom fields
3. If parent: show subtask status summary
4. If overdue: flag it clearly

## Workflow: Joey Asks to Update a Task

1. Fetch current task state
2. Apply the requested changes
3. Confirm what changed

## Batch Operations

When creating multiple related tasks:
1. Create parent first, capture its ID
2. Create all children using that parent ID
3. Set custom fields on each
4. Report all created IDs in summary

## Domain Keywords for Routing

Use these to auto-detect which domain a task belongs to:

| Domain | Keywords |
|--------|----------|
| Personal | `personal`, `habit`, `routine`, `self`, `goal`, `log`, `travel`, `commute` |
| Family | `family`, `mama`, `papa`, `RJ`, `ate joyce`, `xyrah`, `atis`, `allowance family` |
| Love/Wife | `wife`, `love`, `baby`, `gensan`, `apartment`, `binaliw`, `house`, `iphone`, `credit card love` |
| Running | `run`, `training`, `session`, `race`, `km`, `mileage`, `shoes`, `nutrition`, `massage` |
| Athletes | `coaching`, `athlete`, `runsmartwithlee`, `RSWL` |
| Pickpacer | `pickpacer`, `startup`, `product`, `feature`, `bug`, `deploy`, `marketing`, `sales`, `hr`, `wages`, `core` |
| Hardlix | `hardlix`, `hardware`, `compliance`, `filing` |
| Work | `work`, `accenture`, `office`, `timesheet` |
