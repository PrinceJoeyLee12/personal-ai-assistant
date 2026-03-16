---
name: calendar-scheduling
description: Create, query, and manage Joey's daily schedule in ClickUp. Handles daily block-time tasks, routine scheduling, time-range queries, and date awareness across all life domains.
---

# Calendar & Daily Scheduling

Manage Joey's daily calendar via ClickUp tasks with start/due dates. This skill handles creating daily schedules, querying what's on today, building tomorrow's plan, and managing time blocks across all domains.

## Core Rules

1. **Timezone:** Always `Asia/Manila` (UTC+8). All timestamps in API are Unix milliseconds (UTC) — always convert.
2. **Tags are always lowercase**
3. **Never schedule during protected routines:**
   - Morning Routine (prayer, meditation, Bible, run) — typically 05:00–07:00
   - Evening Routine — typically 20:00–20:30
   - Sleep — never suggest late-night tasks
4. **Ichigo Ichie** — One domain at a time. Don't overlap work and personal blocks.
5. **Ma** — Leave breathing room. Never stack tasks back-to-back without gaps.
6. **Hara Hachi Bu** — Stop at 80%. Don't pack the day to full capacity.
7. **Shizen** — Align with natural energy: deep work (Pickpacer) post-run when sharpest, lighter tasks in afternoon.
8. **Check before creating** — Always verify if a schedule already exists for the target date before creating one.

## Timezone Conversion

```
Manila time to UTC: subtract 8 hours
UTC to Manila time: add 8 hours
Manila midnight = 16:00 UTC previous day
```

**Unix timestamp helpers:**
- Manila 05:00 on March 15, 2026 = `2026-03-14T21:00:00Z` = `1773622800000`
- To get a full day in Manila: start_date >= `YYYY-MM-DDT16:00:00Z` (prev day) AND due_date < `YYYY-MM-DDT16:00:00Z` (target day)

## Joey's Ideal Daily Schedule Template (Feb 23 reference)

This is the proven template from Joey's actual schedule. Use it as the baseline when building new days.

| # | Time (Manila) | Duration | Task | List (ID) | Folder | Priority | Tags |
|---|--------------|----------|------|-----------|--------|----------|------|
| 1 | 04:00–04:00 | all-day | Daily Check in Checklist [Date] | GEN - General List (`901604386916`) | General (`90165706716`) in General List Space | urgent | `routine` |
| 2 | 05:00–06:00 | 1h | Morning Routine | Personal List (`901604362025`) | Personal (`90162704137`) | urgent | `block time` |
| 3 | 06:00–07:00 | 1h | Morning Session | Run List (`901604361974`) | Runs (`90162704128`) | urgent | — |
| 4 | 07:00–07:30 | 30m | Settle down | Others (`901604409717`) | Personal (`90162704137`) | urgent | — |
| 5 | 07:30– | — | Breakfast | Others (`901604409717`) | Personal (`90162704137`) | urgent | — |
| 6 | 08:00–11:00 | 3h | Work | work (`901604362284`) | hidden (`90162704357`) | urgent | — |
| 7 | 11:00–11:30 | 30m | Sleep (Power Nap) | Others (`901604409717`) | Personal (`90162704137`) | urgent | — |
| 8 | 12:00–13:00 | 1h | Noon Session [optional] | Run List (`901604361974`) | Runs (`90162704128`) | urgent | — |
| 9 | 14:30–16:00 | 1.5h | Pickpacer | Others (`901604409717`) | Personal (`90162704137`) | urgent | — |
| 10 | 16:00– | — | Prepare for a run | Others (`901604409717`) | Personal (`90162704137`) | none | — |
| 11 | 17:00–18:30 | 1.5h | Evening Session | Run List (`901604361974`) | Runs (`90162704128`) | urgent | `block time` |
| 12 | 19:00–19:30 | 30m | Settle down | Others (`901604409717`) | Personal (`90162704137`) | none | — |
| 13 | 19:30– | — | Dinner | Others (`901604409717`) | Personal (`90162704137`) | urgent | — |
| 14 | 20:00–20:30 | 30m | Evening Routine | Personal List (`901604362025`) | Personal (`90162704137`) | urgent | — |

### Current Season Adjustments (March–June 2026 — Baby Season)

- **Running is reduced** to ~50-60 km/week, ~30 min/day
- Morning Session may be shorter (30 min instead of 1h)
- Noon Session is optional / skip most days
- Evening Session may be shorter or skipped
- **Wife time is elevated** — protect evening blocks for her
- Pickpacer remains priority A — deep work block stays

## Where Schedule Tasks Live — List Mapping

| Task Type | List Name | List ID | Folder | Notes |
|-----------|-----------|---------|--------|-------|
| Morning Routine | Personal List | `901604362025` | Personal | Sacred — prayer, meditation, Bible |
| Evening Routine | Personal List | `901604362025` | Personal | Wind-down, protected |
| Running sessions | Run List | `901604361974` | Runs | Morning/Noon/Evening sessions |
| Work (Accenture) | work | `901604362284` | hidden | Day job block |
| Pickpacer deep work | Others | `901604409717` | Personal | Main business focus |
| Meals & transitions | Others | `901604409717` | Personal | Breakfast, dinner, settle down, nap |
| Daily Check-in | GEN - General List | `901604386916` | General (Pickpacer) | Routine daily checklist |

## Custom Fields for Schedule Tasks

| Field | ID | Type | When to Set |
|-------|----|------|-------------|
| ABC Task Category | `241293c9-b8fb-4d0b-8563-7091c3c27eb7` | drop_down | Morning Routine = `routine - 1` (index 4). Running = `A Task - 1` (index 0). Pickpacer = `A Task - 1` (index 0). |
| Categorize | `ec149710-5cf6-42f0-b24e-3eb241182914` | drop_down | `Non-negotiable` (index 0) for routines, running, Pickpacer. `Negotiable` (index 2) for optional items. |
| time_estimate | — | native | Set via task creation: value in milliseconds. 1h = 3600000, 30m = 1800000, 1.5h = 5400000 |

## Workflow: Query Today's Schedule

When Joey asks "What's my schedule today?" or "Give me my schedule":

### Step 1: Calculate today's date range in UTC

```
Manila day start: YYYY-MM-DDT00:00:00+08:00 → (YYYY-MM-DD - 1)T16:00:00Z
Manila day end: YYYY-MM-DDT23:59:59+08:00 → YYYY-MM-DDT15:59:59Z
```

### Step 2: Query tasks across all relevant lists

For each list (Personal List, Others, Run List, work, GEN - General List):

```bash
curl -s "https://api.clickup.com/api/v2/list/{list_id}/task?date_updated_gt=0&start_date_gt={day_start_ms}&start_date_lt={day_end_ms}&include_closed=true&subtasks=true" \
  -H "Authorization: {token}"
```

Also query tasks where due_date falls in range (some tasks have due but no start).

Also include tasks where the date range **spans** today (start_date <= today AND due_date >= today) for multi-day tasks.

### Step 3: Sort by start_date ascending

### Step 4: Present as timeline

```
📅 Today — March 15, 2026 (Saturday)

04:00  ☑️ Daily Check-in Checklist [routine]
05:00–06:00  🙏 Morning Routine [1h]
06:00–07:00  🏃 Morning Session [1h]
07:00–07:30  🧘 Settle down [30m]
07:30  🍳 Breakfast
08:00–11:00  💼 Work [3h]
11:00–11:30  😴 Power Nap [30m]
14:30–16:00  🚀 Pickpacer [1.5h]
17:00–18:30  🏃 Evening Session [1.5h]
19:00–19:30  🧘 Settle down [30m]
19:30  🍽️ Dinner
20:00–20:30  🌙 Evening Routine [30m]
```

## Workflow: Create Tomorrow's Schedule (or Specific Date)

When Joey asks to build a schedule for a date:

### Step 1: Check if schedule already exists
- Query tasks for that date using the method above
- If tasks exist, show them and ask Joey if he wants modifications

### Step 2: Create tasks following the template
- Use the Ideal Daily Schedule Template as baseline
- Apply Current Season Adjustments
- Create each task in the correct list with correct start/due times
- Set priorities, tags, and custom fields

### Step 3: Task creation order
1. Daily Check-in Checklist (GEN - General List)
2. Morning Routine (Personal List)
3. Morning Session (Run List)
4. Settle down — morning (Others)
5. Breakfast (Others)
6. Work (work list)
7. Sleep/Power Nap (Others)
8. Noon Session — if applicable (Run List)
9. Pickpacer (Others)
10. Prepare for a run — if applicable (Others)
11. Evening Session — if applicable (Run List)
12. Settle down — evening (Others)
13. Dinner (Others)
14. Evening Routine (Personal List)

### Step 4: Report
- Show the created schedule as a timeline
- Note total scheduled hours vs free time (Ma principle)

## Workflow: Create a Specific Task/Event

When Joey says "schedule X at Y time on Z date":

1. Determine the correct list based on the domain
2. Convert Manila time to UTC milliseconds
3. Create the task with start_date and due_date
4. Set appropriate fields
5. Check for conflicts with existing scheduled tasks
6. If conflict, warn Joey and suggest alternatives

## API: Create a Scheduled Task

```bash
# Create task with start and due date (times in Unix ms, UTC)
curl -X POST "https://api.clickup.com/api/v2/list/{list_id}/task" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{
    "name": "Morning Routine",
    "status": "to do",
    "priority": 1,
    "start_date": 1773622800000,
    "due_date": 1773626400000,
    "time_estimate": 3600000,
    "tags": ["block time"]
  }'
```

## Statuses (Universal)

- `to do` — Not started / upcoming
- `inprogress` — Currently active
- `complete` — Done

## Day of Week Awareness

When building schedules, consider:
- **Weekdays (Mon–Fri):** Include Work block (Accenture)
- **Weekends (Sat–Sun):** No Work block. More time for Pickpacer, family, wife, running
- **Sunday:** May include church/faith activities

## Multi-Day Task Handling

Some tasks span multiple days (e.g., a project deadline from Monday to Friday). When querying "today's schedule":
- Include any task where `start_date <= end_of_today AND due_date >= start_of_today`
- Show these separately as "Ongoing this period" below the daily timeline
