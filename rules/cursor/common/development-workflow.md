---
description: 기능 개발을 Plan→TDD→Review→Git 순서로 강제하는 전역 개발 워크플로
alwaysApply: true
---

# Development Workflow

## Scope / Precedence

- 이 문서는 **전역 Rules 기본값**이다.
- 프로젝트에 이미 개발 워크플로(절차/게이트/CI 정책)가 있으면 **그 프로젝트 규칙이 우선**이다.
- 이 문서는 **Git 작업(커밋/PR) 이전**에 수행해야 하는 개발 프로세스를 규정한다.
- 커밋 메시지/PR 흐름 등 Git 규칙은 `git-workflow.md`를 따른다.

## Feature Implementation Workflow (Before Git)

1. **Plan First**
   - 가능하면 `/plan`을 사용해 **실행 가능한 구현 계획**을 먼저 확정한다.
   - 의존성과 리스크를 식별하고, 작업을 Phase로 쪼갠다.
   - (중요) 계획이 확정되기 전에는 큰 변경을 시작하지 않는다.

2. **TDD Approach**
   - 가능하면 `/tdd` 또는 **tdd-guide**로 TDD를 따른다.
   - 테스트 먼저(RED) → 통과 구현(GREEN) → 리팩터(REFACTOR/IMPROVE) 순서로 진행한다.
   - 커버리지 목표(기본 80%+)는 `testing.md`의 기준을 따른다.

3. **Code Review**
   - 코드 작성/수정 직후 `/code-review` 또는 **code-reviewer**로 리뷰를 수행한다.
   - **CRITICAL/HIGH 이슈는 반드시 처리**한다.
   - MEDIUM 이슈는 가능한 범위에서 수정한다.

4. **Commit & Push**
   - 커밋 메시지 포맷과 PR 프로세스는 `git-workflow.md`를 따른다.
   - 커밋 전에는 테스트/빌드가 녹색인지 확인한다(가능하면 `/verify`를 사용).

