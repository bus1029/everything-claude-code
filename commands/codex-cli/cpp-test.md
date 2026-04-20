---
description: Codex CLI port for C++ TDD with GoogleTest/CTest and coverage verification.
---

# C++ Test Skill Port

Codex CLI용 `cpp-test` 포트다. C++ 코드에 대해 GoogleTest 중심의 TDD 흐름을 적용한다.

## Canonical Surface

- 이 문서는 standalone TDD workflow다
- CMake, CTest, GoogleTest, coverage 도구가 있으면 그 표면을 따른다

## Workflow

1. 함수나 클래스의 인터페이스를 먼저 고정한다
2. failing test를 먼저 작성한다
3. `cmake --build`와 `ctest`로 RED를 확인한다
4. 최소 구현으로 GREEN을 만든다
5. 다시 테스트를 실행한다
6. 필요하면 refactor한다
7. `gcov`, `lcov` 등 가능한 coverage 도구로 범위를 확인한다

## Test Guidance

- happy path
- invalid input
- boundary case
- error path
- fixture가 필요하면 기존 패턴을 따른다
- parameterized test가 맞으면 기존 프레임워크 패턴을 따른다

## Verification

예시:

```bash
cmake -B build -S .
cmake --build build
ctest --test-dir build --output-on-failure
lcov --capture --directory build --output-file coverage.info
```

## Output Expectations

- 추가한 테스트 파일
- RED/GREEN 증거
- coverage 결과
- 남은 테스트 갭
