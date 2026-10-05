---
name: daily-brief
description: Produce a short, cited morning brief from tasks/recurring.md jobs (news, monitoring, status), or a single [brief] task.
---

# Daily brief

1. Read `tasks/recurring.md`, or the single `[brief]` task if one was given.
2. For each job, search for what is new **since the previous brief**. Compare against the latest file in
   `outputs/briefs/` so the same items aren't repeated. Use WebSearch and WebFetch, and favor the last 24–48h.
3. For status jobs, read `tasks/done.md`, yesterday's `logs/` file and open PRs (use `gh pr list` when it is available).
4. Write `outputs/briefs/YYYY-MM-DD.md` (or `YYYY-MM-DD-<slug>.md` for a one-off), skimmable in 2 minutes:
   ```
   # Brief: <date>
   ## Needs your attention (blocked tasks, PRs to review, anything urgent)
   ## <Job 1>: 3–5 bullets, each = what happened + why it matters + [source](url)
   ## <Job 2> ...
   ## Suggested tasks for the inbox (optional, max 3; don't add them yourself)
   ```
If there is nothing new for a job, write "Nothing notable." and don't pad.
