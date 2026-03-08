---
description: Standup report prep — today's calendar, priority tasks, urgent messages, and upcoming deadlines
disable-model-invocation: false
---

## Description
Every morning, a standup is conducted between team members. A standup report
is to be created to log all meetings, priority tasks, and ad hoc work (whether
from slack or email) to respond to.

This was adapted from [https://github.com/mimurchison/claude-chief-of-staff/blob/main/commands/gm.md](mimurchison/claude-chief-of-staff/gm.md).

## Instructions

You are to generate a standup report for this user. Follow these steps
in order, and collate a report for the user.

### Step 1: Get Current Time (if calendar MCP is connected)

Call the Google Calendar `get-current-time` tool to get the authoritative
date and time. Extract the day of week, date, and timezone. Never guess
the day of week — always verify.

### Step 1: Calendar Review (if calendar MCP is connected)

Fetch today's calendar events using `list-events` with today's date range.

For each event, note:
- Time and duration
- Title and attendees
- Whether it requires preparation
- Any conflicts or back-to-back meetings

Flag:
- Meetings that conflict with hard constraints (e.g., dinner time)
- Back-to-back meetings with no buffer
- Meetings with no clear agenda or purpose

### Step 2: Task Review (if Jira Atlassian MCP is connected)

From, Jira (MCP connection with Atlassian), identify:
- Tasks due TODAY (urgent)
- Tasks OVERDUE (critical — should have been done)
- Tasks due in the next 3 days (approaching)
- Tasks that can be completed today given the calendar

### Step 3: Threads Quick Scan (if slack or email MCP are connected)

Do a quick scan of slack and email for anything urgent:
- Search for emails from the last 12 hours
- Flag Tier 1 items (from key contacts, marked urgent, or time-sensitive)
- Don't do a full triage — just surface what's critical

### Step 4: Present the Briefing

Format the briefing as follows:

```
Good morning. It's [Day], [Date]. Here's your standup report:

MEETINGS ([count] meetings)
- [time]  [title] ([duration]) [any flags]
- ...

[If applicable: "Heads up: [conflict or concern]"]

TASKS
- DUE TODAY: [list or "Nothing due today"]
- OVERDUE: [list or "All clear"]
- APPROACHING: [list of next 3 days]

URGENT
- [Any Tier 1 items from inbox, or "No urgent items"]

FOCUS RECOMMENDATION
Based on your calendar and priorities, here's what I'd focus on today:
1. [Top priority]
2. [Second priority]
3. [Third priority, if time allows]
```

### Guidelines

- Be concise. The whole briefing should fit on one screen.
- Lead with the most important information.
- If there are no urgent items, say so — that's good news.
- The focus recommendation should reflect goal alignment.
