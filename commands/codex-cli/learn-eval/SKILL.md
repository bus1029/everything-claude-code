---
name: learn-eval
description: Codex CLI port for extracting a reusable pattern, evaluating quality, choosing save location, and then saving or absorbing it.
---

# Learn Eval Skill Port

Codex CLI용 `learn-eval` 포트다. 패턴 추출 후 바로 저장하지 않고, 저장 위치와 품질을 한 번 더 평가하는 workflow다.

## Canonical Surface

- 저장 위치는 `<GLOBAL_KNOWLEDGE_DIR>` 또는 `<PROJECT_KNOWLEDGE_DIR>` 같은 중립 경로를 쓴다
- verdict를 통해 저장 여부를 결정한다
- 기존 문서와의 중복 여부를 반드시 확인한다
- 애매하면 global을 먼저 선택하고, 분명히 repo 전용일 때만 project로 내린다

## Workflow

1. 재사용 가능한 패턴 후보를 찾는다
2. global vs project 저장 위치를 판단한다
3. 초안을 작성한다
4. 아래 체크를 수행한다

- 기존 skill/knowledge 중복 검색
- 프로젝트 메모 또는 memory overlap 확인
- 새 파일이 필요한지, 기존 문서에 흡수할지 판단
- 실제 재사용 가능한 패턴인지 검토
- `<GLOBAL_KNOWLEDGE_DIR>`와 `<PROJECT_KNOWLEDGE_DIR>`를 모두 grep해 overlap을 확인한다

5. verdict를 고른다

- `Save`
- `Improve then Save`
- `Absorb into [X]`
- `Drop`

6. verdict에 맞게 사용자에게 보여주고 저장 여부를 확정한다

## Confirmation Flow

- `Save`: 저장 경로와 초안을 보여준 뒤 확인을 받는다
- `Improve then Save`: 개선점과 수정 초안을 보여준 뒤 다시 판단한다
- `Absorb into [X]`: 대상 문서와 추가 내용 diff를 보여준다
- `Drop`: 이유만 기록하고 저장하지 않는다

## Draft Format

```markdown
---
name: pattern-name
description: concise description
origin: auto-extracted
---

# [Pattern Name]

## Problem
## Solution
## When To Use
```

## Output Expectations

- checklist 결과
- verdict
- 저장 경로 또는 흡수 대상
- rationale
