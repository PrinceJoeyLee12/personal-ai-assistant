# TOOLS

## Integration Status

| Tool | Status | Scope | Notes |
|------|--------|-------|-------|
| Telegram | ✅ Active | All agents | Primary chat interface |
| ClickUp | ✅ Active | All agents | Via `clickup-api` bash scripts — no MCP needed |
| Google TTS | 📋 Roadmap | All agents | Gemini 2.5 Flash Lite Preview TTS |

---

## Telegram
- **Status:** ✅ Connected
- **Purpose:** Primary interface for Joey to interact with OpenClaw
- **Behavior:**
  - All incoming Telegram messages route through `main` first
  - `main` dispatches to the correct sub-agent
  - Responses return through Telegram in concise, mobile-friendly format
- **Formatting rules for Telegram:**
  - Keep responses under 10 lines unless detail is requested
  - Use emoji sparingly for domain context (🏃 running, 💼 work, etc.)
  - Avoid markdown that doesn't render in Telegram (e.g., tables)

---

## ClickUp
- **Status:** ✅ Active — use scripts directly, no MCP or OAuth needed
- **Skill:** `skills/clickup-api/` — full documentation and usage examples
- **Scripts dir:** `~/.openclaw/workspace/skills/clickup-api/scripts/`
- **Token:** Auto-loaded from `~/.openclaw/openclaw.json` (already configured)
- **Workspace ID:** `9016539972`
- **Main Calendar:** `https://app.clickup.com/9016539972/v/c/8cpuyu4-5256`

### How to Use ClickUp

Always set the alias first, then call the script:
```bash
S=~/.openclaw/workspace/skills/clickup-api/scripts
```

**Common operations:**
```bash
# Today's schedule (Manila TZ)
$S/cu-schedule-today.sh

# Schedule for a specific date
$S/cu-schedule-date.sh 2026-03-17

# Get a task by ID
$S/cu-task-get.sh <task_id>

# Create a task
$S/cu-task-create.sh --list <list_id> --name "Task name" --priority 2

# Search tasks
$S/cu-search.sh "keyword"

# Close a task
$S/cu-task-close.sh <task_id>
```

See `skills/clickup-api/SKILL.md` for the full script reference, list IDs, and examples.

- **Purpose:** Single source of truth for ALL tasks, projects, and calendar across every domain
- **Planned Capabilities:**
  - Create, update, complete tasks
  - Fetch due today / overdue tasks per domain
  - Morning briefing pull across all mapped spaces/folders
  - Calendar event awareness via main calendar
  - Priority and status updates via chat

### Space & Folder Mapping

| Agent | ClickUp Name | ID | Type |
|-------|-------------|-----|------|
| `agent-personal` | Personal Folder | `90162704137` | Folder |
| `agent-personal` | Others (activity log) | `90164060945` | Folder |
| `agent-running` | Runs | `90162704128` | Folder |
| `agent-athletes` | RunSmartWithLee | `90162704122` | Folder |
| `agent-family` | Family | `90162704127` | Folder |
| `agent-wife` | Love | `90162734735` | Folder |
| `agent-hardlix` | Hardlix Hardware Business | `90163472327` | Folder |
| `agent-pickpacer` | General List | `90162003414` | Space |
| `agent-pickpacer` | Core | `90161969213` | Space |
| `agent-pickpacer` | Fin & Ops | `90161987762` | Space |
| `agent-pickpacer` | Marketing | `90162203002` | Space |
| `agent-pickpacer` | Sales | `90165291868` | Space |
| `agent-pickpacer` | HR | `90162337904` | Space |

> ⛔ **Excluded:** `90163538776` (Doc Business) — skipped per Joey's instruction.

### Personal Activity Logging (`90164060945`)
- Used for general task logging with **start datetime** and **end datetime**
- Examples: travel from home to office, errands, time tracking entries
- `agent-personal` reads/writes here for time-awareness and daily logging

### Key Lists Reference

| List Name | List ID | Parent |
|-----------|---------|--------|
| Prince Joey Lee List | `901604342078` | General List Space |
| Core - General List | `901604314839` | Core General Folder |
| Core WD - Website Dev | `901604318618` | Website Development Folder |
| Core BIT - Bug Tracking | `901604318441` | Bug & Issue Tracking Folder |
| F&O Main List | `901604353987` | Fin & Ops Space |
| Expenses List | `901604354127` | Fin & Ops Space |
| F&O Wages List | `901604388639` | Fin & Ops Space |
| Marketing Main List | `901604832496` | Marketing Space |
| Run List | `901604361974` | Runs Folder |
| RunSmartWithLee List | `901604361967` | RunSmartWithLee Folder |
| Family List | `901604361973` | Family Folder |
| Family Home Renovation | `901604531431` | Family Folder |
| Personal List | `901604362025` | Personal Folder |
| Love List | `901604409689` | Love Folder |
| Apartment List | `901604765860` | Love Folder |
| House - Binaliw List | `901605383401` | Love Folder |
| Love Financial List | `901605680981` | Love Folder |
| HardlixHardware Business | `901605645075` | Hardlix Hardware Business Folder |
| HR - Hr List | `901605120956` | HR Space |
| Sales List | `901611468224` | Sales Space |
| Others | `901604409717` | Personal Folder |
| work | `901604362284` | hidden Folder (Personal Space) |
| GEN - General List | `901604386916` | General Folder (General List Space) |

### Notes
- All sub-agents query **only their mapped IDs** — no cross-contamination
- `main` has **read access to ALL spaces** for cross-domain briefings and conflict detection
- Calendar is unified — all agents surface time-based tasks to the main calendar view

---

### ClickUp Custom Fields Reference

These fields are available across tasks in the workspace. Agents must read and write them correctly when creating or updating tasks.

#### 📂 Dropdown Fields

| Field Name | Field ID | Options | When to Use |
|-----------|----------|---------|-------------|
| **ABC Task Category** | `241293c9-b8fb-4d0b-8563-7091c3c27eb7` | `A Task - 1`, `A Task - 2`, `B Task - 1`, `B Task - 2`, `routine - 1`, `routine - 2` | Classify every task by type and priority tier. A = high-value, B = medium, routine = recurring ops. Always set this on task creation. |
| **Categorize** | `ec149710-5cf6-42f0-b24e-3eb241182914` | `Non-negotiable`, `Delegate`, `Negotiable`, `Eliminate` | Triage field — how should this task be handled? Maps to Joey's Big Three logic. Non-negotiable = Priorities A/B/C. Use Eliminate aggressively for noise. |

#### 💰 Currency Fields (PHP)

| Field Name | Field ID | When to Use |
|-----------|----------|-------------|
| **Budget** | `72b72734-93dd-411f-a33f-3058b4d79875` | Allocated budget for a task or project. Set at task creation for any financial activity. |
| **Actual Spend** | `82595661-6cb3-46b1-99df-e57a1ec842b6` | Actual amount spent. Update when expense is confirmed. Compare vs Budget for variance. |
| **Income** | `b3ddf778-72a7-4863-9eea-b11e25c4fda0` | Revenue or income tied to a task. Use in Pickpacer, Hardlix, and Love Financial contexts. |
| **💵 Partial Payment** | `482687ed-96ad-46d7-9636-4229fcfcb87f` | Partial payment made or received. Use for staged payments, invoicing milestones. |

#### 📝 Short Text Fields

| Field Name | Field ID | When to Use |
|-----------|----------|-------------|
| **In Debt To** | `bdf3bf3f-5f76-4789-8c92-5c8bfffb3239` | Name of person or entity owed. Use in personal finance, Hardlix, or Love Financial tasks. |

#### ☑️ Checkbox Fields

| Field Name | Field ID | When to Use |
|-----------|----------|-------------|
| **Is Paid** | `0b5aeafb-e514-40fd-878f-517516fa5d46` | Mark `true` once payment is confirmed. Used for expense reconciliation and payables tracking. |

#### 📊 Progress Fields

| Field Name | Field ID | Range | When to Use |
|-----------|----------|-------|-------------|
| **progress** | `708a825f-8719-4e06-8322-4d1594636a02` | 0–100 | Manual completion percentage. Update on significant milestones. Use for project tasks, not simple to-dos. |

#### 🔗 Task Link Fields

| Field Name | Field ID | When to Use |
|-----------|----------|-------------|
| **Documentation** | `e45d579a-0b6c-4a74-8102-366d9d169d41` | Link related documentation tasks. Used primarily in Core/Pickpacer dev work. |
| **Testing Scripts** | `db39025e-7b1f-4a9d-836d-0867a2d80a8e` | Link QA/testing tasks. Used in Core Space for website and app features. |
| **deployment** | `34fd7270-a384-4872-993e-8af4607df370` | Link deployment tasks. Used in Core Space for release management. |

---

### ClickUp Tags Reference

Tags add cross-domain context and filtering. Agents must apply correct tags on task creation and updates.

#### How to Tag — Rules
1. **Always tag `routine`** on any recurring task (daily, weekly, monthly)
2. **Always tag `needs budget`** on any task that requires financial allocation before it can proceed
3. **Month tags** (e.g., `march 2026`) are **only for financial tasks** — expenses, payments, income, budget items, payables, wages. Do NOT apply to non-financial tasks.
4. **All tags must be lowercase** — always. No exceptions. `routine` not `Routine`, `march 2026` not `March 2026`

#### Tag Registry

| Tag | Color | Category | When to Apply |
|-----|-------|----------|---------------|
| `routine` | `#F76808` (orange) | Process | Any daily/weekly/monthly recurring task — check-ins, reviews, payments, training sessions |
| `needs budget` | `#ffc6a856` (amber) | Financial | Any task requiring budget approval or allocation before work starts |
| `[month] [year]` | `#fffc5b67` (red-pink) | Financial only | **Financial tasks only** — expenses, payments, wages, income entries. Format: `march 2026`, `april 2026`, `december 2026`. Enables monthly financial rollup and reconciliation. |

#### Tag Usage by Agent

| Agent | Common Tags |
|-------|-------------|
| `agent-personal` | `routine`, `[month] [year]` |
| `agent-pickpacer` | `routine`, `needs budget`, `[month] [year]` |
| `agent-hardlix` | `needs budget`, `[month] [year]` |
| `agent-wife` | `routine`, `needs budget`, `[month] [year]` |
| `agent-family` | `routine`, `[month] [year]` |
| `agent-running` | `routine` |
| `agent-finances` | `needs budget`, `[month] [year]`, `routine` |

---

## Google Text-to-Speech (Planned)
- **Status:** 📋 Roadmap — Phase 2
- **Model:** Gemini 2.5 Flash Lite Preview TTS
- **Purpose:** Convert agent responses to voice output
- **Use Cases:**
  - Morning briefings read aloud
  - Hands-free updates while running
  - Driving mode responses
- **Integration Point:** `main` level — available to all sub-agents

---

## OpenClaw System
- **Host:** GCP Compute Instance — Ubuntu
- **URL:** `https://35.206.112.132/`
- **Config Path:** `~/.openclaw/`
- **Workspace:** `~/.openclaw/workspace/`
- **Agent Config:** `~/.openclaw/agents/`
- **Cron:** `~/.openclaw/cron/` — for scheduled tasks (morning briefings, heartbeats)
- **Logs:** `~/.openclaw/logs/`

---

## Tool Usage Principles
1. **ClickUp first** — Always check ClickUp before asking Joey what's on his plate
2. **Don't duplicate** — If data exists in ClickUp, don't ask Joey to repeat it
3. **Fail gracefully** — If a tool is unavailable, inform Joey and proceed with what's possible
4. **Log tool actions** — All tool calls should be traceable in logs
