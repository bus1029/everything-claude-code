---
name: git-commit
description: Generate a Korean Git commit message from a scoped diff. Use when the user asks for a commit message, says /git-commit, or wants a commit message based only on a specific file or directory path.
---

# Git Commit

Generate a Git commit message from a scoped diff.

## When to use

Use this skill when:

- the user asks for a Git commit message
- the user mentions `/git-commit`
- the user wants the message based on a specific file or folder
- the user wants only scoped changes reflected in the message

## Scope rules

Set:

- `TARGET_PATH="$ARGUMENTS"`
- if empty, treat it as `TARGET_PATH="."`

Always scope Git inspection commands with:

- `-- "$TARGET_PATH"`

Do not include out-of-scope changes in the summary or message even if they
exist elsewhere in `git status`.

## Required workflow

1. Check staged changes first:
   - `git diff --cached --name-status -- "$TARGET_PATH"`
2. If staged changes are empty, check working tree changes:
   - `git diff --name-status -- "$TARGET_PATH"`
3. Inspect the scoped diff content:
   - `git diff --cached -- "$TARGET_PATH"`
   - if staged diff is empty, use `git diff -- "$TARGET_PATH"`
4. Base the commit message only on the scoped changes you found.

## Output requirements

- Write the commit message in Korean.
- Use only these types:
  - `feat`
  - `fix`
  - `refactor`
  - `style`
  - `docs`
  - `test`
- Keep the subject within 50 characters.
- Do not end the subject with a period.
- Put one blank line between subject and body.
- Keep body lines to about 72 characters or less.
- Explain why the change is being made, not just how it was changed.
- Include intent or context that is not obvious from code alone.
- You may use flat `-` bullets in the body when helpful.

## Output format

```text
<type>: <subject>

<body>
```

## Commit message writing guide

- Prefer `docs` when the scoped change is documentation, guides, structure,
  naming, or examples.
- Prefer `refactor` only when production code structure changes without a
  feature or bug fix.
- Mention structural intent when documents are reorganized, split, renamed,
  or aligned to reduce confusion.
- If the scope includes deletions plus relocations, describe the outcome as
  a reorganization or move, not as a deletion-only change.
- If a simulation, example, or template was added to help later work, say so
  in the body.

## Example process

If the user runs `/git-commit deployment-diagram`, inspect only:

- `git diff --cached --name-status -- "deployment-diagram"`
- or `git diff --name-status -- "deployment-diagram"`
- and the matching scoped diff content

Then produce a Korean commit message that reflects only changes under
`deployment-diagram`.
