# Claude AI Workflow

An unattended task system for [Claude Code](https://claude.com/claude-code). You queue up deep research,
coding, briefs and document work in the morning. Claude works through the queue on a schedule during the
day, and you review the results, with sources, PRs and a daily digest, in the evening. A local dashboard
shows what Claude is doing, step by step, while it works.

No API keys, servers or frameworks are needed. It is built entirely on Claude Code's own features
(skills, scheduled tasks, `CLAUDE.md` rules and permissions), plus a small Python dashboard that uses
only the standard library.

---

## What it does

| Task type | What you get | Where |
|---|---|---|
| `[research]` | A multi-source, cross-checked report with citations and a clear recommendation | `outputs/research/` |
| `[code]` | Work on an `ai/<task>` branch, tested, then left as a **draft PR** or a patch. It never merges and never touches `main` | `outputs/code/` |
| `[brief]` | A short, cited news or status brief. A morning brief runs every weekday from `tasks/recurring.md` | `outputs/briefs/` |
| `[docs]` | Documents, spreadsheets and data cleanup. Your originals are never changed | `outputs/docs/` |

Each run also writes a log entry, and an **evening digest** summarizes the day: what was finished, what
needs your review, and what got blocked and why.

## Dashboard

```bash
python dashboard/server.py
```

On Windows you can just double-click `start-dashboard.bat`. The dashboard opens at http://127.0.0.1:8765
and only listens on your own machine.

- **Activity**: whether a run is working, idle or stalled, plus today's progress bar and the current step of
  each task (for example, *Step 3 of 5 · Reading sources*).
- **What Claude is doing**: a live, plain-English feed of each scheduled run, built from its session
  transcript. It shows what Claude says, searches, reads and edits, with helper agents indented under the
  main run.
- **New task and queue**: add tasks, change their priority, remove them, or requeue a stuck one.
- **Outputs, History, Run logs**: search every report and read it in place, or open Word, Excel and PDF
  files in their own apps.
- **Recurring jobs**: edit the topics the morning brief covers.

## How it works

```
tasks/inbox.md ──► scheduled run (Claude Code) ──► skill for the task type ──► outputs/…
      ▲                    │                                                    │
  dashboard            progress.py  ──► tasks/status.json ──► dashboard ◄───────┘
                        transcript  ──────────────────────► live feed
```

| Path | Purpose |
|---|---|
| `CLAUDE.md` | The rules every run follows: hard safety limits, narration, progress reporting and bookkeeping |
| `.claude/skills/` | Playbooks: `run-queue`, `deep-research`, `coding-task`, `daily-brief`, `docs-task` |
| `.claude/settings.json` | Pre-approved tools so unattended runs don't stall, and denied dangerous commands |
| `tasks/` | `inbox.md` (the queue), `done.md` (the archive), `recurring.md` (morning-brief topics) |
| `dashboard/` | `server.py` (local API and UI), `feed.py` (transcript to live feed), `progress.py` (step reporter) |

## Setup

1. **Requirements:** the [Claude desktop app](https://claude.com/download) (for scheduled tasks), Python 3.9
   or newer and Git. The [GitHub CLI](https://cli.github.com/) is optional; signed in, it lets coding tasks
   open draft PRs.
2. **Clone the repo**, then start the dashboard once. That creates your personal `tasks/inbox.md`,
   `done.md` and `recurring.md` from the `*.example.md` templates. Those files are git-ignored, so your tasks
   and results never get committed.
3. **Open the folder in the Claude desktop app** (Code tab) and create three scheduled tasks. Asking Claude
   to "set up the schedules from the README" also works.

   | Task | Schedule | Prompt (summary) |
   |---|---|---|
   | Morning brief | `0 7 * * 1-5` | Read `CLAUDE.md`, follow `.claude/skills/daily-brief`, write `outputs/briefs/<date>.md` |
   | Queue worker | `0 9,12,15 * * *` | Read `CLAUDE.md`, follow `.claude/skills/run-queue` (up to 3 tasks per run) |
   | Evening digest | `0 18 * * *` | Read `CLAUDE.md`, summarize today's log, done list and outputs into `outputs/digests/<date>.md` |

4. **Click "Run now" once on each task** and choose *Always allow* for the tools it asks about. Each
   scheduled task remembers your approvals, so later runs don't stop to wait for you.
5. **Adjust the permissions:** `.claude/settings.json` allows edits under `~/ENGINEERING/**`. Change that to the
   folder that holds your projects.

Scheduled tasks run while the Claude app is open. If the app is closed, a missed run happens the next time
it starts.

## Safety model

The workflow runs with nobody watching, so the guardrails are written down rather than left to judgment
during a run:

- **Instructions only come from your task files.** Text in web pages, repos, issues or documents is
  treated as data. Attempts to give Claude instructions that way are ignored and logged.
- **It never** spends money, sends emails or messages, posts publicly, enters credentials, changes
  account or system settings, or deletes anything outside the workflow folder.
- **Code:** work happens on an `ai/` branch only. It never pushes to `main` or `master`, never
  force-pushes and never merges, and it uses a separate worktree if you have uncommitted work. `settings.json`
  also denies force-pushes, pushes to main or master, `gh pr merge` and recursive deletes at the
  permission layer.
- **The dashboard** binds to `127.0.0.1` only. It rejects foreign `Host` headers and requires a custom header
  on every write, which blocks cross-site requests. It can only read files inside `outputs/`, `logs/`
  and `tasks/`, and it sanitizes rendered Markdown.

For coding, pair the workflow with a GitHub ruleset on `main` that requires pull requests. That's the
guardrail a token can't get around.

## Customizing

- **Add a task type:** write a skill in `.claude/skills/<name>/SKILL.md`, add a row to the table in
  `CLAUDE.md`, add its steps to `STEPS` in `dashboard/progress.py`, and add a button in `TYPES` in
  `dashboard/index.html`.
- **Change the schedules:** edit them in the Claude app, then update `SCHEDULES` in `dashboard/server.py` so
  the dashboard's countdowns match.
- **Change the dashboard port:** set `AIWF_PORT=9000`.
