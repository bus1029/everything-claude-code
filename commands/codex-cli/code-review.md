---
description: Codex CLI port for local change review or GitHub PR review with neutral paths and explicit review criteria.
---

# Code Review Skill Port

Codex CLI용 `code-review` 포트다. 로컬 변경분이나 GitHub PR을 검토하는 문서형 workflow다.

## Canonical Surface

- 기본 동작은 현재 세션에서 직접 review를 수행한다
- PR review와 local review를 모두 지원한다
- 프로젝트 규칙, PRP 산출물, 구현 문맥은 중립 경로로 읽는다
- review 산출물은 필요하면 `<PRP_ROOT>/reviews` 아래에 남긴다

## Modes

- local review
- PR review

## Local Review

1. `git diff --name-only HEAD`로 범위를 잡는다
2. 변경 파일을 전체 문맥으로 읽는다
3. 아래 항목을 우선 검토한다

- correctness
- security
- error handling
- missing tests
- maintainability

4. findings를 심각도별로 정리한다

## PR Review

1. PR 번호나 URL에서 대상을 식별한다
2. `gh pr view`, `gh pr diff`로 메타데이터와 diff를 가져온다
3. 필요하면 PR head 기준 전체 파일을 읽는다
4. 프로젝트 규칙과 구현 문맥을 함께 읽는다

문맥 후보:

- `AGENTS.md`
- 기여 가이드
- `<PRP_ROOT>/plans`
- `<PRP_ROOT>/reports`

5. 검증 명령이 있으면 프로젝트 유형에 맞게 실행한다
6. findings와 최종 verdict를 정리한다

## Review Categories

- correctness
- type safety
- pattern compliance
- security
- performance
- completeness
- maintainability

## Severity

- `CRITICAL`: 보안, 데이터 손실, 심각한 correctness 문제
- `HIGH`: 병합 전에 고쳐야 할 버그나 누락
- `MEDIUM`: 추천 수정
- `LOW`: 선택적 개선

## Validation Commands

프로젝트 유형에 맞는 검증 명령을 선택한다.

- Node/TypeScript: typecheck, lint, test, build
- Rust: clippy, test, build
- Go: vet, test, build
- Python: test와 타입/린트 도구가 있으면 함께 실행

실행 가능한 명령만 돌리고, skip한 이유를 남긴다

## Decision Matrix

- `APPROVE`: `CRITICAL/HIGH` 없음, 검증 통과
- `APPROVE WITH COMMENTS`: `MEDIUM/LOW`만 존재
- `REQUEST CHANGES`: `HIGH` 이슈 또는 검증 실패
- `BLOCK`: `CRITICAL` 이슈 존재

## Optional Explicit Subagents

리뷰를 역할별로 나누고 싶다면 메인 세션이 callable한 role을 명시적으로 호출한다. 자동 체인은 없다.

- 일반 리뷰: `reviewer`
- 문서/주석 검토: callable하다면 `comment-analyzer`
- 테스트 관점: callable하다면 `pr-test-analyzer`
- silent failure 관점: callable하다면 `silent-failure-hunter`

## Review Artifact

필요하면 아래 항목을 `<PRP_ROOT>/reviews` 아래 문서로 남긴다.

- PR 번호와 제목
- findings by severity
- validation results
- files reviewed
- final verdict

## Publish

GitHub PR review를 실제로 게시할 때는 `gh pr review` 또는 inline comment 표면을 사용한다. draft PR이면 comment-only 흐름을 우선한다.

## Output Expectations

- 리뷰 범위
- findings
- 검증 명령 결과
- 최종 verdict
