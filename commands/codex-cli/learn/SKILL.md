---
name: learn
description: Codex CLI port for extracting reusable session patterns into learned knowledge docs with neutral storage paths.
---

# Learn Skill Port

Codex CLI용 `learn` 포트다. 현재 세션에서 재사용 가능한 패턴을 추출해 knowledge 문서로 남기는 workflow다.

## Canonical Surface

- trivial fix는 저장하지 않는다
- 저장 위치는 특정 Claude 경로로 고정하지 않고 `<PROJECT_KNOWLEDGE_DIR>` 또는 `<GLOBAL_KNOWLEDGE_DIR>`를 쓴다
- 저장 전에는 반드시 재사용성부터 판단한다

## What To Extract

- error resolution pattern
- debugging technique
- workaround
- project-specific pattern

## Workflow

1. 세션에서 반복 가능성이 있는 문제 해결 패턴을 찾는다
2. 가장 재사용 가치가 큰 하나를 고른다
3. 아래 항목으로 초안을 만든다

- problem
- solution
- example
- when to use

4. 저장 전에 사용자 확인을 받는다
5. 아래 기준으로 저장 위치를 정한다

- 여러 프로젝트에서 재사용 가능하면 `<GLOBAL_KNOWLEDGE_DIR>`
- 현재 repo 문맥에 강하게 묶이면 `<PROJECT_KNOWLEDGE_DIR>`

6. `{pattern-name}.md` 같은 일관된 이름으로 저장한다

## Suggested Format

```markdown
---
name: pattern-name
description: concise description
origin: learned
---

# [Pattern Name]

## Problem
[무슨 문제를 푸는가]

## Solution
[핵심 패턴]

## Example
[예시]

## When To Use
[트리거]
```

## Guardrails

- typo 같은 사소한 수정은 제외
- 일회성 장애는 제외
- 너무 넓은 교훈보다 구체적이고 재실행 가능한 패턴을 우선한다
