---
name: prp-implement
description: Codex CLI port for executing an implementation plan with validation after every step and neutral PRP paths.
---

# PRP Implement Skill Port

Codex CLI용 `prp-implement` 포트다. plan 문서를 읽고 단계별로 구현하되, 매 단계마다 검증해서 깨진 상태를 쌓지 않는 workflow다.

## Canonical Surface

- plan 파일을 입력으로 받는다
- PRP artifact는 `<PRP_ROOT>` 아래에 둔다
- 기본 중립 구조는 `<PRP_ROOT>/plans`, `<PRP_ROOT>/reports`, `<PRP_ROOT>/prds`다
- 구현보다 validation loop를 먼저 유지한다

## Workflow

1. package manager와 가능한 검증 명령을 탐지한다
2. plan 파일을 읽고 아래 항목을 추출한다

- summary
- patterns to mirror
- files to change
- tasks
- validation commands
- acceptance criteria

3. plan 파일이 유효하지 않으면 중단하고 먼저 올바른 plan을 만들게 한다
4. 현재 브랜치와 working tree 상태를 확인한다
5. 브랜치 상태에 따라 현재 브랜치를 쓰거나 feature branch를 만든다
6. 필요하면 remote sync를 수행한다
7. task를 순서대로 실행한다
8. 각 task에서 MIRROR reference와 GOTCHA를 먼저 읽는다
9. 각 파일 변경 직후 관련 typecheck, lint, test, build를 돌린다
10. 실패를 바로 수정하고 다음 단계로 넘어간다
11. 전체 validation을 마지막에 다시 실행한다
12. 구현 보고서를 `<PRP_ROOT>/reports`에 남긴다
13. 필요하면 plan을 archive하거나 PRD phase 상태를 갱신한다

## Validation Levels

- static analysis
- unit tests
- build
- integration test if applicable
- edge case verification

통합 테스트가 필요하면 server start, readiness wait, test run, cleanup 순서를 명시적으로 수행한다

## Guardrails

- validation 실패를 누적하지 않는다
- plan에서 벗어나면 deviation을 기록한다
- plan이 불완전하면 먼저 보강하거나 사용자에게 확인한다
- 같은 단계에서 반복 실패하면 failure playbook으로 원인을 분리한다
- branch 또는 rebase 충돌이 생기면 사용자에게 알리고 진행을 멈춘다

## Output Expectations

- 수행한 단계
- deviation
- validation 결과
- report 위치
- plan archive 또는 PRD status update 여부
