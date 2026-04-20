---
name: go-build
description: Codex CLI port for incremental Go build repair using the built-in go-build-resolver role.
---

# Go Build Skill Port

Codex CLI용 `go-build` 포트다. 핵심 표면은 built-in `go-build-resolver`이며, 목적은 리팩터링이 아니라 "가장 작은 수정으로 다시 빌드 가능 상태를 회복하는 것"이다.

## Canonical Surface

- 권장 role은 built-in `go-build-resolver`다.
- 이 workflow는 Go 빌드 실패, `go vet` 경고, 정적 분석 오류를 순차적으로 줄이는 복구 루프다.
- module drift나 의존성 깨짐도 동일한 복구 범위에 포함한다.
- 구현 범위를 넓히지 말고, 실패를 재현하고, 최소 수정 후 즉시 재검증한다.

## Workflow

1. 실패 범위를 정한다. 보통 `go build ./...`부터 시작하고 필요하면 `go vet ./...`와 추가 lint로 넓힌다.
2. dependency breakage가 의심되면 `go mod verify`와 `go mod tidy -v`로 모듈 상태를 먼저 확인한다.
3. 명시적으로 서브에이전트 `go-build-resolver`를 호출하여 현재 오류를 파일과 원인 단위로 묶는다.
4. 가장 앞선 blocker부터 최소 수정으로 해결한다.
5. 수정 후 같은 진단 명령을 다시 실행해 남은 오류 수와 새 회귀 여부를 확인한다.
6. 빌드가 복구되면 관련 테스트 또는 패키지 단위 검증까지 확장한다.
7. 구조 변경이 필요한 수준으로 번지면 여기서 멈추고 별도 계획 흐름으로 넘긴다.

## Suggested Checks

```bash
go build ./...
go vet ./...
staticcheck ./...
golangci-lint run
go mod verify
go mod tidy -v
go test ./...
```

## Parallelism

- 병렬 fan-out보다 직렬 복구가 우선이다.
- 같은 오류군을 여러 수정안으로 동시에 만지지 않는다.
- 독립 패키지의 후속 테스트는 빌드 복구 후 병렬화할 수 있다.

## Merge Rules

- 같은 root cause에서 나온 오류는 한 묶음으로 처리한다.
- resolver 제안과 직접 진단 결과가 충돌하면 실제 재현 명령 출력이 우선이다.
- 신규 리팩터링이나 스타일 개선은 merge 대상에서 제외한다.

## Stop Conditions

- 동일 오류가 반복해서 재발할 때
- 수정이 다른 패키지에 더 큰 오류를 퍼뜨릴 때
- module state를 정리해도 오류가 계속 남을 때
- 의존성/아키텍처 문제로 최소 수정 범위를 넘길 때

## Output Expectations

- 실행한 진단 명령
- 고친 대표 오류와 수정 이유
- 남은 오류 또는 중단 사유
- 최종 build/test 상태
