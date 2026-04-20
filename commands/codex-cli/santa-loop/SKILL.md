---
name: santa-loop
description: Codex CLI port for adversarial review convergence with reviewer and security-reviewer, plus an optional external read-only review surface.
---

# Santa Loop Skill Port

Codex CLI용 `santa-loop` 포트다. 목적은 "한 번 리뷰하고 끝"이 아니라, 독립적인 검토 신호가 모두 통과할 때까지 수정과 재검토를 반복하는 것이다.

## Canonical Surface

- 기본 reviewer는 repo-local `reviewer`와 독립적인 외부 read-only review surface다.
- built-in `security-reviewer`는 추가 축으로 병렬 참여하지만, 독립 reviewer requirement를 대체하지 않는다.
- 외부 표면 예시는 다른 Codex read-only 세션, GitHub PR review, 또는 별도 모델 CLI 같은 독립 읽기 표면이다.
- 각 라운드는 fresh reviewer로 다시 시작해야 하며, `NICE` 전에는 ship, push, land로 진행하지 않는다.

## Workflow

1. 리뷰 범위를 정한다. 기본은 현재 변경분 또는 명시된 파일 집합이다.
2. correctness/security/completeness/error handling 기준의 공통 rubric을 만든다.
3. repo-local `reviewer`와 독립 외부 read-only reviewer에 대해 명시적으로 서브에이전트를 호출하여 같은 rubric으로 병렬 실행한다.
4. 필요하면 명시적으로 서브에이전트 `security-reviewer`를 추가 호출하여 security-specific blocker를 보강한다.
5. 각 라운드가 끝나면 수정 전 상태를 가리키는 안정된 checkpoint를 남기고, 결과를 합쳐 blocker를 dedupe한다.
6. blocker를 수정한 뒤 fresh reviewer들로 다시 같은 범위를 검토한다.
7. 내부 reviewer와 외부 reviewer가 모두 PASS에 해당하는 판정을 줄 때까지 반복한다.
8. 최대 3라운드를 넘기면 남은 blocker를 들고 사용자에게 escalation한다.

## Recommended Verdict Rule

- 내부 reviewer와 외부 reviewer가 모두 PASS: `NICE`
- 둘 중 하나라도 blocker를 제시: `NAUGHTY`
- 3회 반복 후에도 blocker 잔존: `ESCALATED`

## Parallelism

- `reviewer`, 외부 read-only reviewer, `security-reviewer`는 같은 라운드에서 병렬 실행한다.
- 수정 자체는 직렬로 진행하고, 수정 완료 후 다음 라운드를 연다.

## Merge Rules

- reviewer 간 동일한 문제는 한 항목으로 합치고, 교집합 여부를 표시한다.
- security finding은 correctness finding에 흡수하지 않고 별도 보존한다.
- 새 라운드에는 이전 reviewer의 기억을 넘기지 말고, 수정된 결과물과 rubric만 다시 준다.
- 각 라운드의 checkpoint는 다음 라운드의 기준선으로 남기되, `NICE` 전에는 배포/ship 체크포인트로 간주하지 않는다.

## Output Expectations

- 라운드 수
- 사용한 reviewer surface
- 공통 blocker와 개별 blocker
- 현재 verdict (`NICE`, `NAUGHTY`, `ESCALATED`)
- `NICE` 전 ship 금지 여부
- 남은 수동 확인 항목
