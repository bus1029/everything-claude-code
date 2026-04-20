---
name: feature-dev
description: Codex CLI port for guided feature development with explicit exploration, architecture, approval, implementation, and review stages.
---

# Feature Dev Skill Port

Codex CLI용 `feature-dev` 포트다. 원본 command의 핵심인 "먼저 이해하고, 설계 승인을 받은 뒤 구현한다"는 흐름은 유지하되, Codex에서는 모든 role 호출이 명시적이라는 점을 전제로 다시 쓴다.

## Canonical Surface

- 이 문서는 operator가 직접 진행하는 feature workflow다.
- 권장 role은 repo-local `explorer`, built-in `code-architect`, repo-local `reviewer`다.
- 어떤 role도 자동으로 이어서 실행되지 않는다.
- 설계 승인 전에는 구현으로 넘어가지 않는다.

## Recommended Roles

- `explorer`
  - 기존 코드 구조, 진입점, 영향 범위를 읽는 read-only 탐색 단계
- `code-architect`
  - 구현 청사진, 파일 단위 변경 계획, 위험 요소를 정리하는 설계 단계
- `reviewer`
  - 구현 후 correctness, security, missing tests 관점에서 검토하는 마감 단계

## Workflow

1. 요청을 다시 정리하고 범위, 제약, acceptance criteria를 명확히 적는다.
2. 명시적으로 서브에이전트 `explorer`를 호출하여 관련 파일, 실행 경로, 기존 패턴, integration point를 수집한다.
3. 탐색 결과를 바탕으로 남은 모호점을 질문으로 정리하고, 답변 또는 명시적 가정 확정 전까지 여기서 멈춘다.
4. 질문이 해소되거나 가정이 승인된 뒤에만 명시적으로 서브에이전트 `code-architect`를 호출하여 구현 계획, 테스트 전략, 위험 요소, 파일별 변경 방향을 만든다.
5. 설계안을 사용자에게 보여주고 명시적 승인을 기다린다.
6. 승인 후에만 구현한다. 필요하면 테스트를 먼저 추가한 뒤 변경한다.
7. 구현이 끝나면 명시적으로 서브에이전트 `reviewer`를 호출하여 치명적 문제와 테스트 누락을 점검한다.
8. 검토 결과를 반영하고, 최종적으로 변경 내용과 남은 리스크를 요약한다.

## Parallelism

- 탐색 단계는 단일 스레드가 기본이다. 구현 직전 계획을 고정해야 하므로 `explorer`와 `code-architect`를 같은 범위에 병렬로 돌리지 않는다.
- 구현 후 검증용 명령 실행과 `reviewer` 호출은 병행할 수 있지만, 같은 파일을 추가 수정하는 시점에는 결과를 먼저 합쳐야 한다.

## Merge Rules

- `explorer` 산출물은 사실 수집과 영향 범위에 한정한다.
- `code-architect` 산출물은 구현 순서, 테스트 전략, 승인 게이트의 기준 문서가 된다.
- 구현 단계에서는 승인된 설계에서 벗어난 변경을 따로 표시한다.
- `reviewer`와 로컬 검증 결과가 겹치면 더 구체적인 재현 조건이 있는 쪽을 남기고 중복은 합친다.

## Output Expectations

- 요구사항 재정리
- 탐색 결과 요약
- 승인용 구현 계획
- 구현된 변경과 테스트 결과
- 리뷰 findings와 후속 조치
