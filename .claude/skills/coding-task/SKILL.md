---
name: coding-task
description: Implement a code change unattended on a branch, test it, and leave it for review as a PR or patch. Use for [code] tasks.
---

# Coding task

## Setup
- Work out which repo the task names. For a local path, work there. For a GitHub `owner/repo` that isn't
  cloned yet, clone it next to this workflow folder (`../<repo>`). If no repo is named, mark the task BLOCKED.
- `git status`: if the working tree has uncommitted changes that aren't yours, **don't touch them**. Use
  `git worktree add ../<repo>-ai-<slug> -b ai/<slug>` instead, so the owner's work in progress stays safe.
- Otherwise run `git checkout -b ai/<slug>` from the default branch, after pulling first if it has a remote.

## Do the work
1. Read the README, the build files, and the code nearby. Match the existing style.
2. Plan briefly, then implement in small steps.
3. Run whatever checks the project has (tests, lint, typecheck, build). Add tests for new logic where the
   project already has tests. Fix what you broke. For web projects, run the build and, if possible,
   check the page in a preview.
4. Commit with clear messages ending in `Co-Authored-By: Claude <noreply@anthropic.com>`.

## Hand off (never merge, never push to main or master, never force-push)
- If the repo has a GitHub remote and the `gh` CLI is installed and logged in, push the branch and open a
  **draft** PR with the summary below as the body.
- Otherwise leave the branch in place and save `git format-patch` output to `outputs/code/`.
- Write `outputs/code/YYYY-MM-DD-<slug>.md` with: the goal, assumptions, what changed (files), how it was
  tested (commands and results), known gaps, the PR link or branch name, and how to review it.
