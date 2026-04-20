---
description: Codex CLI port for analyzing coverage gaps and adding tests to reach a target threshold.
---

# Test Coverage Skill Port

Codex CLI용 `test-coverage` 포트다. coverage 보고서를 분석해 80% 미만 파일을 우선 개선하는 workflow다.

## Workflow

1. 테스트 프레임워크와 coverage 명령을 감지한다
2. coverage report를 생성한다
3. 80% 미만 파일을 worst-first로 정리한다
4. 각 파일에 대해 아래를 찾는다

- untested function
- missing branch
- error path
- dead code

5. 부족한 테스트를 추가한다
6. 전체 테스트와 coverage를 다시 실행한다

## Coverage Command Hints

- Jest: `npx jest --coverage --coverageReporters=json-summary`
- Vitest: `npx vitest run --coverage`
- Pytest: `pytest --cov=src --cov-report=json`
- Cargo: `cargo llvm-cov --json`
- JaCoCo: `mvn test jacoco:report`
- Go: `go test -coverprofile=coverage.out ./...`

## Priority

- happy path
- error handling
- edge case
- branch coverage

## Test Generation Rules

- 기존 프로젝트의 test 위치와 naming을 따른다
- 외부 의존성은 적절히 mock한다
- 각 테스트는 독립적으로 실행 가능해야 한다

## Output Expectations

- before/after coverage
- 추가한 테스트
- 아직 낮은 파일
- 다음 우선순위
