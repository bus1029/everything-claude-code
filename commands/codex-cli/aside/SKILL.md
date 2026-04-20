---
name: aside
description: Answer a short side question during active work without losing the main task state.
---

# Aside

Use this skill when the user asks a brief side question that should not derail
the current task.

## Canonical Surface

- This is a standalone workflow.
- Handle the question in the current session.
- Prefer read-only checks and avoid file edits.

## When to use

- A short question comes up while active work is already in progress.
- The user wants a quick explanation of code intent or behavior.
- The user wants clarification without changing task direction.
- The user wants a small answer without opening a separate workflow.

## Workflow

1. State the current task briefly.
2. Answer the question directly and briefly.
3. Read files only if needed to answer accurately.
4. End with a one-line summary of the task being resumed.
5. If there is no blocker, return to the main task immediately.

## Response shape

```text
ASIDE: [question summary]

[short direct answer]

- Back to task: [current task]
```

## Guardrails

- Do not edit files during an aside.
- Do not treat a real scope change as an aside.
- If the answer exposes a flaw in the current approach, warn and wait for user direction.
- If a long explanation is required, answer the core point first and offer a deeper follow-up.

## Edge cases

- If the question is empty, ask one minimal clarifying question.
- If there is no active task, end with `Back to task: no active task to resume`.
- If the question is about code, prefer citing `file:line` when practical.
- If several asides happen in a row, resume the main task after the last one.
- If the question is ambiguous, ask only one clarifying question.
