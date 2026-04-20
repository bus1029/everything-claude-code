---
description: Codex CLI port for an interactive, problem-first PRD workflow with research gates and neutral output paths.
---

# PRP PRD Skill Port

Codex CLI용 `prp-prd` 포트다. 문제를 먼저 규정하고, 질문과 research gate를 거쳐 PRD를 만드는 interactive workflow다.

## Canonical Surface

- 입력이 비어 있으면 질문부터 시작한다
- 정보가 없으면 추측하지 않고 `TBD`로 남긴다
- PRP artifact는 `<PRP_ROOT>` 아래에 둔다
- 출력은 `<PRP_ROOT>/prds` 아래 문서다

## Process

1. 문제와 만들고 싶은 대상을 확인한다
2. foundation 질문 세트를 묻고 응답을 기다린다
3. 시장과 코드베이스 문맥을 조사하고 요약을 다시 사용자에게 보여준다
4. vision, primary user, JTBD, non-user, constraints 질문 세트를 묻고 응답을 기다린다
5. 기술적 feasibility와 리스크를 다시 점검하고 사용자에게 요약을 보여준다
6. MVP, must-have, hypothesis, out-of-scope 질문 세트를 묻고 응답을 기다린다
7. PRD를 템플릿 형식으로 생성한다

## PRD Expectations

- problem statement
- evidence
- proposed solution
- key hypothesis
- what we are not building
- user and JTBD
- success metric
- constraints
- open questions
- implementation phases if needed

## Interaction Gates

- 각 질문 세트 뒤에는 사용자 응답을 기다린다
- research/grounding 결과를 보여준 뒤에는 조정 여부를 묻는다
- 정보가 부족하면 문서를 생성하기 전에 멈추고 추가 입력을 받는다

## PRD Template Expectations

- problem statement
- evidence
- proposed solution
- key hypothesis
- what we are not building
- target users and JTBD
- success metrics
- constraints
- open questions
- implementation phases table

## Guardrails

- solution보다 problem을 먼저 다룬다
- evidence가 없으면 명시적으로 validation 필요 상태로 둔다
- 불확실성은 감추지 않는다
