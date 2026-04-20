---
name: code-review
description: Review local changes or a GitHub pull request with explicit criteria and neutral artifact paths.
---

# Code Review

Use this skill when the user wants a local diff review or a GitHub PR review.

## Canonical Surface

- Perform the review in the current session by default.
- Support both local review and PR review.
- Read project rules, plans, and reports from neutral paths.
- If needed, store review artifacts under `<PRP_ROOT>/reviews`.

## Modes

- local review
- PR review

## Local review

1. Scope the review with `git diff --name-only HEAD`.
2. Read changed files in full context.
3. Prioritize these review categories:

- correctness
- security
- error handling
- missing tests
- maintainability

4. Report findings by severity.

## PR review

1. Identify the PR from its number or URL.
2. Use `gh pr view` and `gh pr diff` to inspect metadata and diff.
3. Read full files from the PR head when needed.
4. Review against project context such as:

- `AGENTS.md`
- contribution guides
- `<PRP_ROOT>/plans`
- `<PRP_ROOT>/reports`

5. Run project-appropriate validation commands when available.
6. Summarize findings and final verdict.

## Review categories

- correctness
- type safety
- pattern compliance
- security
- performance
- completeness
- maintainability

## Severity

- `CRITICAL`: security, data loss, or severe correctness issues
- `HIGH`: bugs or gaps that should be fixed before merge
- `MEDIUM`: recommended changes
- `LOW`: optional improvements

## Validation commands

Select only commands that make sense for the project type.

- Node or TypeScript: typecheck, lint, test, build
- Rust: clippy, test, build
- Go: vet, test, build
- Python: test plus type or lint tools when available

If a command is skipped, say why.

## Decision matrix

- `APPROVE`: no `CRITICAL` or `HIGH` findings and validation passed
- `APPROVE WITH COMMENTS`: only `MEDIUM` or `LOW` findings
- `REQUEST CHANGES`: a `HIGH` finding or validation failure exists
- `BLOCK`: a `CRITICAL` finding exists

## Optional explicit subagents

If the review benefits from split perspectives, call subagents explicitly. Do not assume an automatic chain.

- general review: `reviewer`
- docs or comments: `comment-analyzer` when callable
- test coverage perspective: `pr-test-analyzer` when callable
- silent failure perspective: `silent-failure-hunter` when callable

## Review artifact

If you save the review under `<PRP_ROOT>/reviews`, include:

- PR number and title
- findings by severity
- validation results
- files reviewed
- final verdict

## Publish

When posting a GitHub review, use `gh pr review` or inline comments. Prefer comment-only flow for draft PRs.

## Output expectations

- review scope
- findings
- validation command results
- final verdict
