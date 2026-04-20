---
description: Codex CLI port for quick side questions during active work. Answer briefly without losing the main task state.
---

# Aside Skill Port

Codex CLI용 `aside` 포트다. 작업 흐름을 끊지 않고 짧은 질문에 답한 뒤, 원래 하던 일을 이어가는 문서형 workflow다.

## Canonical Surface

- 이 문서는 standalone workflow다
- 기본 동작은 현재 세션에서 직접 수행한다
- 파일 수정 없이 읽기 중심으로 처리한다

## When To Use

- 진행 중인 작업과 관련된 짧은 질문이 생겼을 때
- 현재 편집 중인 코드의 의도나 동작을 빠르게 확인할 때
- 작업 방향을 바꾸지 않고 설명만 잠깐 듣고 싶을 때
- 완전히 새 작업을 열지 않고 짧은 정보만 얻고 싶을 때

## Workflow

1. 현재 작업 상태를 짧게 고정한다
2. 질문을 직접적이고 짧게 답한다
3. 필요한 경우 읽기 전용으로 파일만 확인한다
4. 답변 끝에 원래 하던 작업 한 줄 요약을 붙인다
5. blocker가 없다면 즉시 본 작업으로 돌아간다

## Response Shape

```text
ASIDE: [질문 요약]

[짧고 직접적인 답변]

- Back to task: [원래 하던 작업]
```

## Guardrails

- aside 중에는 파일을 수정하지 않는다
- 질문이 사실상 방향 전환이면 aside로 처리하지 않는다
- 답변이 현재 접근의 결함을 드러내면 경고를 주고 사용자 판단을 기다린다
- 긴 설명이 필요하면 핵심만 답하고 나중에 더 깊게 설명할지 제안한다

## Edge Cases

- 질문이 비어 있으면 가장 짧은 확인 질문만 한다
- 현재 작업이 없으면 `Back to task: no active task to resume`로 끝낸다
- 현재 코드에 대한 질문이면 가능하면 `file:line`으로 답한다
- 여러 aside가 연속으로 오면 마지막 답변 뒤에만 본 작업으로 돌아간다
- 모호한 질문이면 한 개의 clarifying question만 한다
