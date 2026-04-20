---
name: model-route
description: Codex CLI port for recommending a model tier or reasoning depth based on task complexity and budget.
---

# Model Route Skill Port

Codex CLI용 `model-route` 포트다. 현재 작업에 맞는 모델 또는 추론 강도를 추천하는 lightweight guide다.

## Inputs

- task description
- optional budget: `low`, `med`, `high`

## Routing Heuristic

- low cost, mechanical task: 작은 모델 또는 낮은 reasoning
- default implementation task: 기본 모델과 중간 reasoning
- architecture, ambiguity, deep review: 강한 모델과 높은 reasoning

## Output

- recommended model tier
- confidence
- why it fits
- fallback option

## Notes

- 이 문서는 실행기가 아니라 추천 가이드다
- 현재 실제 사용 가능한 모델과 reasoning 옵션에 맞춰 표현한다
