---
description: Codex CLI port for Kotlin TDD with Kotest-style tests and coverage verification.
---

# Kotlin Test Skill Port

Codex CLI용 `kotlin-test` 포트다. Kotlin 코드에 대해 RED -> GREEN -> REFACTOR TDD 흐름을 적용한다.

## Canonical Surface

- 이 문서는 standalone TDD workflow다
- `./gradlew test`와 coverage 도구가 있으면 그것을 따른다

## Workflow

1. 타입과 함수 계약을 먼저 고정한다
2. Kotest 또는 현재 프로젝트 테스트 패턴으로 failing test를 작성한다
3. `./gradlew test`로 RED를 확인한다
4. 최소 구현으로 GREEN을 만든다
5. 다시 테스트를 실행한다
6. 필요하면 refactor한다
7. Kover 등 가능한 coverage 표면으로 확인한다

## Test Guidance

- valid input
- invalid input
- multiple error aggregation
- nullability와 boundary case
- coroutine, spec style, matcher 패턴이 이미 있으면 그것을 따른다

## Verification

```bash
./gradlew test
./gradlew koverHtmlReport
./gradlew koverVerify
```

## Output Expectations

- 추가한 test spec
- RED/GREEN 증거
- coverage 결과
- 남은 테스트 갭
