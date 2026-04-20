---
name: checkpoint
description: Create, verify, list, and prune workflow checkpoints using neutral storage paths.
---

# Checkpoint

Use this skill when you want to record a work state and compare against it later.

## Canonical Surface

- This is a standalone workflow.
- Use neutral storage such as `<REPO_STATE_DIR>/checkpoints.log`.
- The backing mechanism can be a Git commit, stash, tag, or memo log depending on the repo.

## Supported modes

- `create <name>`
- `verify <name>`
- `list`
- `clear`

## Create

1. Run a quick verification so the current state is not already broken.
2. Record the checkpoint name and current `HEAD` or working state.
3. Append time, name, SHA, and note to `<REPO_STATE_DIR>/checkpoints.log`.
4. Summarize why the checkpoint was created.

Example log entry:

```text
2026-04-20-1430 | feature-start | a1b2c3d | quick verification passed
```

## Verify

1. Find the baseline checkpoint in `<REPO_STATE_DIR>/checkpoints.log`.
2. Compare the current state against it.
3. Summarize these deltas:

- changed file count
- test status changes
- coverage changes
- build status changes

## List

Report:

- checkpoint name
- created time
- linked SHA
- current status relative to the active branch

## Clear

- Prune old checkpoints.
- Default behavior keeps the most recent five.

## Output expectations

- checkpoint name
- baseline SHA or state
- verification result
- recommended timing for the next checkpoint
