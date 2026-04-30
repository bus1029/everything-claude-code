---
name: plan
description: Codex CLI port for explicit planning with the built-in planner role and a hard approval gate before implementation.
---

# Plan Skill Port

Codex CLI용 `plan` 포트다. 구현 전 계획 수립과 승인 게이트가 목적이며, 이 문서를 읽는 것만으로 코드를 만지기 시작하면 안 된다.

## Canonical Surface

- 권장 role은 built-in `planner`다.
- 계획 단계의 핵심 산출물은 요구사항 재정리, 단계별 실행안, 리스크, open question이다.
- 사용자 승인 전에는 구현, 리팩터링, 대규모 파일 수정으로 넘어가지 않는다.

## Workflow

1. 요청을 다시 서술해 목표, 비목표, 제약, acceptance criteria를 고정한다.
2. 서브에이전트 `planner`를 호출해 구현 단계를 나눈다.
3. 호출한 `planner` 서브에이전트 결과는 반드시 `wait_agent`로 완료까지 기다린다.
4. 서브에이전트 결과를 검토해 최종 계획에 반영한다. 반영하지 않는 제안은 이유를 적는다.
5. 각 단계에 대해 파일/모듈 영향 범위, 선행조건, 테스트 전략, rollback risk를 적는다.
6. 불명확한 점은 질문 또는 가정으로 분리한다.
7. 계획안을 사용자에게 보여주고 명시적 승인 또는 수정 요청을 기다린다.
8. 승인 후에만 다음 구현 workflow로 넘긴다.

## Required Plan Shape

- Requirements Restatement
- Scope and Non-Goals
- Phase-by-Phase Execution Plan
- Dependencies
- Risks and Open Questions
- Verification Strategy
- Explicit Approval Gate

## Parallelism

- planning 자체는 단일 owner가 정리하는 것이 기본이다.
- 필요한 경우 read-only evidence gathering을 별도 역할에 병렬 위임할 수 있지만, 최종 계획 문서는 하나로 합친다.
- `planner` 서브에이전트를 호출했다면 최종 계획 작성 전에 반드시 완료를 기다리고 결과를 통합한다.

## Merge Rules

- 계획 중 나온 가정과 확정 사실을 섞지 않는다.
- 탐색 결과가 있으면 plan에 인용하되, 확인되지 않은 내용은 risk 또는 open question으로 남긴다.
- 승인 후 변경되는 범위가 생기면 기존 계획 대비 diff를 따로 표시한다.

## Output Expectations

- 승인 가능한 구현 계획
- 위험 요소와 선행조건
- 검증 전략
- 사용자에게 요구되는 확인 사항
