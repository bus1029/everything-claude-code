---
name: go-review
description: Codex CLI port for Go-focused review using the built-in go-reviewer role.
---

# Go Review Skill Port

Codex CLI용 `go-review` 포트다. 이 문서는 Go 변경분을 대상으로 idiomatic Go, concurrency, error handling, security를 함께 점검하는 review workflow를 정의한다.

## Canonical Surface

- 권장 role은 built-in `go-reviewer`다.
- 기본 범위는 현재 변경된 `.go` 파일이지만, 필요하면 패키지 또는 디렉터리 단위로 넓힌다.
- review는 수정이 아니라 finding 생산이 목적이다.

## Workflow

1. 리뷰 범위를 정한다. 기본은 `git diff` 기준 Go 변경 파일이다.
2. 가능하면 `go vet`, `staticcheck`, `golangci-lint`, 관련 테스트를 먼저 돌려 기계적 신호를 확보한다.
3. 명시적으로 서브에이전트 `go-reviewer`를 호출하여 correctness, concurrency safety, context propagation, error handling, API shape를 검토한다.
4. 도구 출력과 reviewer findings를 합쳐 severity별로 정리한다.
5. blocker를 먼저 해결하고, 필요하면 같은 범위로 재리뷰한다.

## Suggested Checks

```bash
go vet ./...
staticcheck ./...
golangci-lint run
go build -race ./...
govulncheck ./...
go test ./...
```

## Review Focus

- race condition, goroutine leak, channel deadlock
- known vulnerability exposure와 취약한 dependency usage
- context 누락과 cancellation 전파 문제
- error wrapping/context 부족
- 잘못된 interface 설계 또는 zero-value misuse
- injection, secret handling, unsafe shell/SQL 사용
- non-idiomatic API와 유지보수 비용이 큰 패턴

## Parallelism

- `go-reviewer`는 단일 주 리뷰어로 본다.
- 로컬 정적 분석은 병렬로 돌릴 수 있지만, findings 합치기는 한 번에 한다.

## Merge Rules

- 같은 root cause를 가리키는 도구 경고와 reviewer finding은 하나로 합친다.
- severity는 더 높은 쪽으로 승격한다.
- style-only 제안은 correctness/security/test gap과 분리해 advisory로 둔다.

## Output Expectations

- 리뷰 범위
- 실행한 검증 명령
- severity별 findings
- merge blocker 여부
- 재검토가 필요한 항목
