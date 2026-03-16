---
name: financial-budgeting
description: Create, track, and manage Joey's monthly financial budgets across all ClickUp domains — Family, Love, Running, Pickpacer, Hardlix. Handles recurring expenses, tags, custom fields, parent/child task hierarchy, and payment tracking.
---

# Financial Budgeting & Expense Tracking

Manage all of Joey's financial life in ClickUp. This skill handles monthly expense creation, budget tracking, payment status, and rollover for recurring obligations.

## Core Rules

1. **Timezone:** Always use `Asia/Manila` (UTC+8) for all dates
2. **Tags are always lowercase** — `needs budget`, `march 2026`, never `March 2026` or `Needs Budget`
3. **Month tags format:** `[month] [year]` — e.g., `march 2026`, `april 2026`, `december 2026`
4. **Month tags are ONLY for financial tasks** — expenses, payments, income, budget items, wages. Never on non-financial tasks.
5. **Always tag `needs budget`** on any financial task requiring allocation
6. **Always tag `routine`** on recurring monthly expenses
7. **Parent tasks first** — Always create the parent expense group BEFORE creating its sub-tasks
8. **Custom fields are mandatory** — Set `Budget` on every financial task at creation. Set `Is paid`, `Actual Spend`, `Partial Payment` as payments occur.

## ClickUp API Reference

**Base URL:** `https://api.clickup.com/api/v2`
**Auth Header:** `Authorization: {CLICKUP_API_TOKEN}` (from `~/.openclaw/openclaw.json` env)
**Workspace ID:** `9016539972`

## Custom Fields for Financial Tasks

| Field | ID | Type | Usage |
|-------|----|------|-------|
| Budget | `72b72734-93dd-411f-a33f-3058b4d79875` | currency | Allocated amount. Set on creation. |
| Actual Spend | `82595661-6cb3-46b1-99df-e57a1ec842b6` | currency | Actual amount spent. Update when confirmed. |
| Income | `b3ddf778-72a7-4863-9eea-b11e25c4fda0` | currency | Revenue tied to a task. |
| Partial Payment | `482687ed-96ad-46d7-9636-4229fcfcb87f` | currency | Staged/partial payments. |
| Is paid | `0b5aeafb-e514-40fd-878f-517516fa5d46` | checkbox | `true` when payment confirmed. |
| In Debt To | `bdf3bf3f-5f76-4789-8c92-5c8bfffb3239` | short_text | Person/entity owed. |
| Categorize | `ec149710-5cf6-42f0-b24e-3eb241182914` | drop_down | `Non-negotiable` (index 0), `Delegate` (1), `Negotiable` (2), `Eliminate` (3) |
| ABC Task Category | `241293c9-b8fb-4d0b-8563-7091c3c27eb7` | drop_down | `A Task - 1` (0), `A Task - 2` (1), `B Task - 1` (2), `B Task - 2` (3), `routine - 1` (4), `routine - 2` (5) |
| progress | `708a825f-8719-4e06-8322-4d1594636a02` | manual_progress | 0–100 completion. |

### Setting Custom Fields via API

```bash
# Set Budget to 5000
curl -X POST "https://api.clickup.com/api/v2/task/{task_id}/field/72b72734-93dd-411f-a33f-3058b4d79875" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{"value": 5000}'

# Set Is paid to true
curl -X POST "https://api.clickup.com/api/v2/task/{task_id}/field/0b5aeafb-e514-40fd-878f-517516fa5d46" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{"value": true}'

# Set Categorize to "Non-negotiable" (index 0)
curl -X POST "https://api.clickup.com/api/v2/task/{task_id}/field/ec149710-5cf6-42f0-b24e-3eb241182914" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{"value": 0}'
```

## Where Financial Tasks Live — List Mapping

| Domain | List Name | List ID | Parent Folder | Folder ID |
|--------|-----------|---------|---------------|-----------|
| Family | Family List | `901604361973` | Family | `90162704127` |
| Love / Wife | Love List | `901604409689` | Love | `90162734735` |
| Love / Wife | Love Financial List | `901605680981` | Love | `90162734735` |
| Love / Wife | Apartment List | `901604765860` | Love | `90162734735` |
| Love / House | House - Binaliw List | `901605383401` | Love | `90162734735` |
| Running | Run List | `901604361974` | Runs | `90162704128` |
| Pickpacer | F&O Main List | `901604353987` | Fin & Ops | `90161987762` |
| Pickpacer | Expenses List | `901604354127` | Fin & Ops | `90161987762` |
| Pickpacer | F&O Wages List | `901604388639` | Fin & Ops | `90161987762` |
| Hardlix | HardlixHardware Business | `901605645075` | Hardlix Hardware Business | `90163472327` |
| Personal | Personal List | `901604362025` | Personal | `90162704137` |

## All Statuses (Universal across these Lists)

- `to do` — Not started
- `inprogress` — In progress / partially paid
- `complete` — Fully paid / done

## Recurring Monthly Expenses — Templates

These are Joey's fixed monthly obligations. When creating a new month, replicate this structure.

### Family Expenses [Month]
**List:** Family List (`901604361973`)
**Parent task:** `Family Expenses [Month]` — tags: `needs budget`, `[month] [year]`, `routine` — priority: urgent

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| Allowance 1 - 15, [Year] | 3,000 | urgent | First half allowance for Mama/Papa |
| Allowance 16 - 30, [Year] | 4,000 | urgent | Second half allowance |
| Running Compensation Mama and Papa | 2,000 | normal | Monthly compensation |

### Love Expenses [Month]
**List:** Love List (`901604409689`)
**Parent task:** `Love Expenses [Month]` — tags: `needs budget`, `[month] [year]`, `routine`

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| IPHONE Love Payment | 3,980 | urgent | Monthly installment |
| Allowance Love Gensan | 5,000 | urgent | Monthly allowance for wife |
| Credit Card Charges - Love [Month] | varies | none | CC charges, set budget when known |

#### Government Fees [Month] (nested under Love Expenses)
**Parent:** `Government Fees [Month]` — tags: `needs budget` — nested under Love Expenses

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| SSS [Month] | 2,000 | urgent | Social Security |
| Pag-IBIG [Month] | 2,000 | urgent | Home mutual fund |
| PhilHealth [Month] | 2,000 | urgent | Health insurance |

### House Binaliw (Ongoing — under Love)
**List:** House - Binaliw List (`901605383401`)
**Parent task:** `House Binaliw` (existing: `86d0h2k6a`) — tags: `needs budget`, `[month] [year]`

| Sub-task Pattern | Budget (PHP) | Notes |
|-----------------|-------------|-------|
| [Month] - Pag-ibig Monthly [17,382.06 + 304 (Transaction Fee)] = 17,686.25 | 17,686.25 | Monthly housing loan — Categorize: Non-negotiable |

### Running Expenses [Month]
**List:** Run List (`901604361974`)
**Parent task:** `Running Expenses [Month]` — tags: `needs budget`, `[month] [year]`, `routine`

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| Pre-Nutritional Support | varies | normal | Pre-run nutrition |
| Post-Nutritional Support | varies | normal | Post-run recovery |
| Running Shoes Savings | varies | normal | Monthly savings for shoes |
| Massage Oil | varies | normal | Recovery supplies |
| Others Running Expenses [Month] | varies | normal | Catch-all |

### Personal Expenses/Income [Month]
**List:** Personal List (`901604362025`)
**Parent task:** `Personal Expenses/Income [Month]` — tags: `needs budget`, `[month] [year]` — priority: none

| Sub-task | Budget (PHP) | Income (PHP) | Priority | Notes |
|----------|-------------|-------------|----------|-------|
| Salary 1 - 15, [Year] | — | 30,000 | none | First half salary. Set Income field, not Budget. |
| Salary 16 - 30 | — | 20,000 | none | Second half salary. Set Income field, not Budget. |
| Personal Allowance [Month] | 2,000 | — | none | Monthly personal allowance |
| Capcut Subscription [Month] | varies | — | none | Monthly Capcut subscription |

#### Pickpacer Investments (nested under Personal Expenses/Income)
**Parent:** `Pickpacer Investments` — tags: `needs budget`, `[month] [year]` — nested under Personal Expenses/Income

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| AWS Fee [Month] | 500 | none | Monthly AWS hosting fee for Pickpacer |

#### Motor (nested under Personal Expenses/Income)
**Parent:** `Motor` — tags: `needs budget`, `[month] [year]` — nested under Personal Expenses/Income

| Sub-task | Budget (PHP) | Income (PHP) | Priority | Notes |
|----------|-------------|-------------|----------|-------|
| Gas | 700 | — | none | Monthly gas costs |
| Renewal | 2,000 | 2,000 | none | Motor renewal — Budget and Income both set (offset) |

### Apartment Payments [Month]
**List:** Apartment List (`901604765860`)
**Parent task:** `Apartment Payments [Month]` — tags: `needs budget`, `[month] [year]` — priority: none

| Sub-task | Budget (PHP) | Priority | Notes |
|----------|-------------|----------|-------|
| Groceries 1 - 15 | 2,500 | none | First half groceries |
| Groceries 16 -30 | 2,500 | none | Second half groceries |
| Rental Payment [Month] | 5,000 | none | Monthly apartment rent. When paid: set `Actual Spend` = 5000, `Is paid` = true, `Partial Payment` = 5000 |
| Wifi Payment [Month] | 1,400 | none | Monthly wifi bill |

## Workflow: Create Monthly Financial Tasks

When Joey asks to create financial tasks for a new month:

### Step 1: Validate
- Check if tasks for that month already exist (search ClickUp by tag `[month] [year]`)
- If they exist, report back — do NOT create duplicates

### Step 2: Create Parent Tasks First
- Create each parent expense group in the correct list
- Set tags: `needs budget`, `[month] [year]`, `routine`
- Set priority as documented above
- Set `Categorize` = `Non-negotiable` (index 0) for essential expenses

### Step 3: Create Sub-tasks
- Create each sub-task with `parent` set to the parent task ID
- Set `Budget` custom field
- Set tags: `needs budget`, `[month] [year]`
- Match priorities from templates above

### Step 4: Report Summary
- List all created tasks with IDs
- Show total budget allocated for the month
- Flag any items where budget is still unknown (marked "varies")

## Workflow: Mark Payment

When Joey says something was paid:

1. Update `Actual Spend` to the payment amount
2. Set `Is paid` = `true`
3. If partial, set `Partial Payment` instead and keep `Is paid` = `false`
4. Update status to `complete` if fully paid, `inprogress` if partial
5. Update parent task progress if all children are complete

## Workflow: Monthly Financial Summary

When Joey asks for a financial overview of a month:

1. Search all tasks tagged `[month] [year]`
2. Group by domain (Family, Love, Running, Pickpacer, Hardlix, Personal)
3. For each: show Budget vs Actual Spend vs Outstanding
4. Show total monthly budget, total spent, total remaining
5. Flag overdue unpaid items

## API Examples

### Create a parent financial task

```bash
curl -X POST "https://api.clickup.com/api/v2/list/901604361973/task" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{
    "name": "Family Expenses [March 2026]",
    "status": "to do",
    "priority": 1,
    "tags": ["needs budget", "march 2026", "routine"]
  }'
```

### Create a sub-task with Budget

```bash
# Step 1: Create the task under parent
curl -X POST "https://api.clickup.com/api/v2/list/901604361973/task" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{
    "name": "Allowance 1 - 15, 2026",
    "parent": "{parent_task_id}",
    "status": "to do",
    "priority": 1,
    "tags": ["needs budget", "march 2026"]
  }'

# Step 2: Set Budget custom field
curl -X POST "https://api.clickup.com/api/v2/task/{new_task_id}/field/72b72734-93dd-411f-a33f-3058b4d79875" \
  -H "Authorization: {token}" -H "Content-Type: application/json" \
  -d '{"value": 3000}'
```

### Search tasks by month tag

```bash
curl -s "https://api.clickup.com/api/v2/team/9016539972/task?tags[]=march%202026&include_closed=true" \
  -H "Authorization: {token}"
```

## Priority Mapping (ClickUp API values)

| Priority | API Value | Label |
|----------|-----------|-------|
| Urgent | 1 | 🔴 |
| High | 2 | 🟠 |
| Normal | 3 | 🟡 |
| Low | 4 | 🔵 |
| None | null | — |
