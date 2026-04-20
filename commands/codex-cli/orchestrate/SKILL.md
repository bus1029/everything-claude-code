---
name: orchestrate
description: Codex CLI skill port for explicit multi-agent orchestration. Use dmux-workflows for external parallelism and call every subagent explicitly.
---

# Orchestrate Skill Port

Codex CLI용 `orchestrate` 포트다. dirty shim에 붙어 있던 불필요한 예시는 버리되, 원래 command의 핵심 intent였던 explicit orchestration, dmux 분기, persistent loop/control-plane 분기는 유지한다.

## Canonical Surface

- 기본 표면은 `dmux-workflows` skill이다.
- persistent loop, governance, scheduled operation, control-plane execution이 목표면 `autonomous-agent-harness` skill도 canonical surface에 포함한다.
- Codex CLI에서는 subagent가 자동으로 연쇄 실행되지 않는다.
- 필요한 role은 모두 명시적으로 호출해야 한다.
- 병렬 pane/worktree orchestration은 `dmux-workflows`를 따른다.
- 장기 실행, 반복 루프, operator-layer control plane은 `autonomous-agent-harness`를 따른다.

## When To Use

- 복잡한 feature를 탐색, 설계, 구현, 리뷰 단계로 나눠 처리할 때
- 독립적인 검토를 병렬로 돌리고 싶을 때
- 한 세션에서 감당하기 어려운 병렬 작업을 분리할 때
- 명확한 handoff 문서가 필요한 multi-agent 작업일 때

## Codex CLI Subagent Rule

- 어떤 role도 암묵적으로 호출하지 않는다.
- 문서에 적힌 순서는 권장 순서일 뿐 자동 파이프라인이 아니다.
- 각 단계는 메인 세션이 Codex multi-agent 표면에서 명시적으로 다음 role을 호출하고, handoff를 넘기고, 다음 단계를 이어가야 한다.
- repo-local role과 built-in role을 구분하고, 실제로 callable한 이름만 사용한다.

## Callable Surface

- repo-local custom role 기준 기본 목록은 `explorer`, `reviewer`, `docs_researcher`다.
- 현재 Codex runtime이 제공하는 built-in role이 있으면 그 이름을 그대로 명시적으로 호출할 수 있다.
- `agents/*.md` 파일명만 보고 role 이름을 가정하지 않는다.

## Recommended Workflows

### Feature

- 명시적으로 서브에이전트 `explorer`를 호출하여 현재 구조와 진입점을 조사
- callable하다면 명시적으로 서브에이전트 `code-architect`를 호출하여 구현 청사진 작성
- callable하다면 명시적으로 서브에이전트 `tdd-guide`를 호출하여 테스트 분해
- 구현 후 명시적으로 서브에이전트 `reviewer`를 호출하여 검토
- 보안 민감 경로면 callable할 때 명시적으로 서브에이전트 `security-reviewer`를 추가 호출하여 검토

### Bugfix

- 명시적으로 서브에이전트 `explorer`를 호출하여 재현 경로와 영향 범위 확인
- callable하다면 명시적으로 서브에이전트 `tdd-guide`를 호출하여 재현 테스트 작성
- 수정 후 명시적으로 서브에이전트 `reviewer`를 호출하여 검토

### Refactor

- callable하다면 명시적으로 서브에이전트 `architect` 또는 `code-architect`를 호출하여 안전한 변경 범위 정의
- callable하다면 `refactor-cleaner` 또는 `code-simplifier`를 명시적으로 호출
- 변경 후 명시적으로 서브에이전트 `reviewer`를 호출하여 검토

### Review Stack

- `reviewer`
- callable하다면 `comment-analyzer`
- callable하다면 `pr-test-analyzer`
- callable하다면 `silent-failure-hunter`
- callable하다면 `type-design-analyzer`
- 필요 시 callable한 `security-reviewer`

## Explicit Invocation Pattern

문서만 읽고 자동으로 다음 role로 넘어가면 안 된다. 항상 메인 세션이 다음 중 하나를 명시적으로 결정한다.

- 어떤 role을 호출할지
- 병렬로 돌릴지
- 어떤 시점에 handoff를 넘기고 다음 명시적 호출로 넘어갈지
- 어떤 결과를 다음 단계 handoff로 넘길지

## Handoff Format

각 단계 산출물은 다음 정도로 짧게 정리한다.

```markdown
## HANDOFF

Scope: 이번 단계가 다룬 범위
Findings: 핵심 발견 또는 결정
Files: 관련 파일
Open Questions: 다음 단계가 풀어야 할 점
Next Step: 추천되는 다음 명시적 호출
```

## Parallelism Guidance

- 서로 다른 파일 집합이나 관점이면 병렬화한다.
- 같은 파일을 동시에 수정하는 worker는 피한다.
- 즉시 다음 단계가 결과를 필요로 하면 병렬보다 직렬이 낫다.

## Optional External Orchestration

tmux/worktree 기반 병렬 실행이 필요하면 `dmux-workflows`와 `scripts/orchestrate-worktrees.js`를 사용한다. `seedPaths`, worker handoff, status export, operator handoff 같은 control-plane 정보가 필요하면 그 구조를 같이 유지한다. 다만 이것도 Codex 내부 자동 파이프라인이 아니라 외부 orchestration 보조 수단이다.

## Output Expectations

- 사용한 role 목록
- 각 role을 왜 호출했는지
- 병렬/직렬 실행 구조
- handoff 요약
- 최종 결정과 남은 blocker
