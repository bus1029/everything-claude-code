---
description: Codex CLI port for creating a detailed implementation plan from a feature description or PRD-like document.
---

# PRP Plan Skill Port

Codex CLI용 `prp-plan` 포트다. 구현 중 검색이 거의 필요 없을 정도로, 필요한 코드베이스 문맥과 패턴을 plan에 미리 담는 workflow다.

## Canonical Surface

- 입력은 feature 설명 또는 PRD-like 문서다
- PRP artifact는 `<PRP_ROOT>` 아래에 둔다
- 기본 중립 구조는 `<PRP_ROOT>/plans`, `<PRP_ROOT>/reports`, `<PRP_ROOT>/prds`, `<PRP_ROOT>/reviews`다
- 출력은 `<PRP_ROOT>/plans` 아래 self-contained plan 문서다
- 애매하면 추측하지 말고 질문한다

## Workflow

1. 입력이 free-form인지, PRD인지, reference file인지 판별한다
2. PRD라면 다음 pending phase를 찾는다
3. 기능 요구사항을 요약하고 user story를 만든다
4. 복잡도를 분류한다
5. ambiguity가 있으면 멈추고 질문한다
6. 코드베이스를 탐색해 아래 정보를 모은다

- similar implementations
- naming conventions
- error handling
- logging
- types
- tests
- config
- dependencies

7. 아래 trace를 실제 코드에서 확인한다

- entry points
- data flow
- state changes
- contracts
- architectural patterns

8. 필요하면 외부 문서를 조사한다
9. UX 변화가 있으면 before/after와 touchpoint를 정리한다
10. 설계 접근과 out-of-scope를 정리한다
11. unified discovery table과 구체적 task template를 포함한 self-contained plan 문서를 `<PRP_ROOT>/plans`에 작성한다

## Plan Expectations

- summary
- requirements
- discovery table
- patterns to mirror
- files to change
- step-by-step tasks
- validation commands
- acceptance criteria
- risks and gotchas

각 task는 가능하면 아래 항목을 포함한다

- ACTION
- IMPLEMENT
- MIRROR
- IMPORTS
- GOTCHA
- VALIDATE

## Guardrails

- 구현 중 다시 코드 검색이 필요할 정도로 plan을 비워두지 않는다
- 성공 기준이 불명확하면 먼저 질문한다
- out-of-scope를 명시해 scope creep를 막는다
