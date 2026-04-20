---
name: review-pr
description: Codex CLI port for multi-role pull request review with explicit parallel fan-out and aggregation rules.
---

# Review PR Skill Port

Codex CLI용 `review-pr` 포트다. 핵심은 PR 하나를 여러 관점에서 병렬 검토하고, 마지막에 중복을 제거해 merge blocker만 남기는 것이다.

## Canonical Surface

- 기본 review stack은 repo-local `reviewer`, built-in `comment-analyzer`, `pr-test-analyzer`, `silent-failure-hunter`, `type-design-analyzer`, `code-simplifier`다.
- 보안 민감 변경이 있으면 built-in `security-reviewer`를 추가한다.
- 각 role 호출은 모두 명시적으로 이뤄져야 한다.
- 기본 보고 기준은 confidence `>= 80`인 finding만 포함하는 것이다.
- advisory는 사용자가 명시적으로 요청했을 때만 별도 섹션으로 노출한다.

## Recommended Roles

- `reviewer`
  - correctness, security, missing tests의 기본 축
- `comment-analyzer`
  - comment 정확도, rot risk, misleading docs 점검
- `pr-test-analyzer`
  - 테스트가 변경된 동작을 실제로 덮는지 검토
- `silent-failure-hunter`
  - 삼켜진 에러, weak logging, misleading fallback 탐지
- `type-design-analyzer`
  - 타입이 invariant를 충분히 encode하는지 검토
- `code-simplifier`
  - behavior-preserving simplification 가능성 검토
- `security-reviewer`
  - auth, secrets, trust boundary, injection risk가 있을 때 추가

## Workflow

1. PR 번호 또는 현재 브랜치 기준 PR을 식별한다.
2. changed files, diff, 테스트 결과, 프로젝트 규칙을 모아 공통 review packet을 만든다.
3. 위 review stack의 각 role에 대해 명시적으로 서브에이전트를 호출하여 병렬로 fan-out한다.
4. 모든 reviewer가 끝나면 confidence `>= 80`인 findings만 남기고 severity와 root cause 기준으로 합친다.
5. 중복을 제거하고 merge blocker와 should-fix로 나눈다. advisory는 명시적으로 요청된 경우에만 분리한다.
6. 필요하면 수정 후 동일한 stack 또는 축소된 stack으로 재리뷰한다.

## Parallelism

- Step 3의 review role은 공통 packet만 같다면 병렬 실행이 기본이다.
- 수정이 들어간 뒤 재리뷰는 변경 범위가 안정화된 후에 다시 fan-out한다.

## Merge Rules

- 동일 root cause를 가리키는 finding은 하나로 합치고 가장 높은 severity를 남긴다.
- confidence가 낮은 finding은 기본 보고에서 제외한다.
- style-only 제안은 사용자가 요청했을 때만 advisory로 내린다.
- code-simplifier 제안은 correctness/security blocker와 섞지 않는다.
- `security-reviewer` finding은 다른 role이 놓친 경우 별도 security 섹션으로 유지한다.

## Output Expectations

- 리뷰에 사용한 role 목록
- merge blocker
- should-fix 항목
- advisory 항목
  - 사용자가 명시적으로 요청한 경우에만 포함
- 중복 제거 후 최종 판정
