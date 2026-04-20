---
name: go-test
description: Codex CLI port for Go TDD with table-driven tests and coverage verification.
---

# Go Test Skill Port

Codex CLI용 `go-test` 포트다. Go의 table-driven test 패턴에 맞춰 TDD를 적용한다.

## Canonical Surface

- 이 문서는 standalone TDD workflow다
- 표준 `go test`와 coverage 표면을 우선 사용한다

## Workflow

1. 함수 시그니처와 반환 계약을 먼저 고정한다
2. table-driven test를 먼저 쓴다
3. `go test`로 RED를 확인한다
4. 최소 구현으로 GREEN을 만든다
5. 다시 `go test`를 실행한다
6. 필요하면 refactor한다
7. coverage를 다시 확인한다

## Test Guidance

- table-driven test 우선
- invalid input과 edge case 포함
- public behavior를 검증하고 구현 세부사항에 과도하게 묶이지 않는다
- helper, subtest, parallel pattern이 이미 있으면 같은 스타일을 따른다

## Verification

```bash
go test ./...
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
```

## Output Expectations

- 추가한 test case
- RED/GREEN 증거
- coverage 결과
- 남은 branch gap
