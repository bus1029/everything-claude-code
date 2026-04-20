---
name: python-review
description: Codex CLI port for Python-focused review using the built-in python-reviewer role.
---

# Python Review Skill Port

Codex CLI용 `python-review` 포트다. Python 변경분에 대해 correctness, type safety, security, Pythonic idiom을 함께 점검한다.

## Canonical Surface

- 권장 role은 built-in `python-reviewer`다.
- review 목적은 finding 생산과 merge risk 평가이지 자동 수정이 아니다.
- 범위는 변경된 `.py` 파일, 특정 패키지, 또는 명시된 경로로 한정한다.

## Workflow

1. 리뷰 범위를 정한다.
2. 가능하면 `ruff`, `mypy`, formatter check, 테스트를 먼저 실행해 기계적 신호를 확보한다.
3. 명시적으로 서브에이전트 `python-reviewer`를 호출하여 security, typing, exception handling, framework-specific risk를 점검한다.
4. 로컬 도구 결과와 reviewer findings를 severity별로 합친다.
5. blocker를 해결한 뒤 필요하면 같은 범위로 재리뷰한다.

## Suggested Checks

```bash
ruff check .
black --check .
isort --check-only .
mypy .
bandit -r .
pytest
```

## Review Focus

- SQL/command injection, unsafe deserialization, secret leakage
- broad `except`, swallowed exception, missing context manager
- mutable default argument, shared state, async misuse
- 약한 type hint, public API typing 누락
- framework별 validation/cors/transaction risk
- non-Pythonic loop, formatting, logging, readability 문제

## Parallelism

- `python-reviewer`가 주 리뷰어다.
- 로컬 lint/type/test는 병렬 실행 가능하지만, findings 합치기와 최종 판정은 한 번에 한다.

## Merge Rules

- 같은 원인에서 나온 lint/type/reviewer findings는 하나로 묶는다.
- severity는 가장 높은 레벨을 따른다.
- style 또는 formatting 제안은 blocker와 분리한다.

## Output Expectations

- 리뷰 범위
- 실행한 검증 명령
- severity별 findings
- merge blocker 여부
- 재검토 필요 항목
