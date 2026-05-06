---
name: handoff
description: Write or update a handoff document for the next Codex session. Use when the user asks to create, refresh, finalize, or clean up an 인수인계 문서, next-session note, session handoff, or work continuation memo, especially at a natural stopping point, before switching topics, before ending a long multi-step task, or when context is getting too long. If the user provides a target file path, write to that file; otherwise ask for one.
---

# Handoff

Write a concise Korean handoff document that lets the next agent continue the work with minimal re-discovery.

## Resolve The Target

1. Extract the target file path from the user's request.
2. If the path is missing or ambiguous, ask the user where to write the handoff.
3. If the file already exists, read it completely before editing.

## Gather Evidence

Collect only the context that helps the next session start quickly.

- Current conversation outcomes and explicit decisions
- Files actually changed in this session
- Relevant `spec`, `plan`, `tasks`, or existing handoff docs
- Current `git status` when code changes are involved
- Latest build, test, lint, typecheck, or manual verification results

Do not rely on editor-only state such as "currently open tabs" unless the user explicitly provided that information.

## Update Existing Handoff Carefully

If the target file already exists:

1. Keep useful structure when it still matches current reality.
2. Remove or replace stale content before adding new content.
3. Delete completed "next actions" that are no longer next.
4. Replace outdated file paths, response shapes, assumptions, and test results.
5. Prefer the current baseline over historical narration.

Do not append blindly.

## Write For The Next Agent

The handoff is not a transcript. It is a working brief for the next session.

Prioritize:

- Concrete current state over narrative history
- Real file paths, symbols, commands, and verification status
- Immediate next actions in execution order
- Constraints, risks, and closed decisions that should not be reopened

Use short, direct Korean. Keep each bullet focused on one point.

## Required Sections

Use these sections unless the user explicitly wants a different structure:

1. `짧은 요약`
2. `현재 상태`
3. `이번 세션에서 바뀐 것`
4. `다음 에이전트가 먼저 봐야 할 파일`
5. `꼭 유지해야 할 기준`
6. `다시 논의하지 말아야 할 결정`
7. `이번 세션에서 얻은 중요한 메모`
8. `테스트와 검증 상태`
9. `다음 세션의 시작 순서`
10. `마지막 액션과 바로 다음 액션`

Add `병렬 작업과 소유권` only when multiple agents, branches, or worktrees are involved.

When creating a new file from scratch, use `assets/handoff-template.md` as the base layout and then fill it with current facts.

## Writing Rules

- Write the handoff in Korean.
- Wrap file paths, commands, identifiers, and symbols in backticks.
- Record only facts the next agent needs in the first 10 minutes.
- State unverified items explicitly.
- Mark constraints and prohibitions in clear language such as `유지해야 한다`, `하지 말아야 한다`, `아직 미구현`.
- If a decision is already closed, put it under `다시 논의하지 말아야 할 결정`.

## Do Not Include

- Long conversation transcripts
- Generic project-wide coding rules already covered by `AGENTS.md` or other persistent docs
- Obsolete status that conflicts with the current state
- Low-signal activity logs
- Tentative ideas presented as settled decisions

## Workflow

1. Resolve the target file path.
2. Read the current handoff if it exists.
3. Gather evidence from the conversation, changed files, related docs, and verification status.
4. Decide what old content is stale and remove or replace it.
5. Write or refresh the handoff in Korean.
6. Re-read the result and verify that the next starting actions are concrete and current.

## Final Check

Before finishing, confirm:

- The written status matches the actual current state.
- The next session can start from 1-5 concrete actions.
- Important file paths are present.
- Test and verification status is included.
- Closed decisions are not phrased as open questions.
- The document is curated, not a pasted transcript.
