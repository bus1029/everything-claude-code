---
description: Codex CLI port for Rust TDD with #[test] and cargo coverage workflows.
---

# Rust Test Skill Port

Codex CLI용 `rust-test` 포트다. Rust 함수나 타입에 대해 테스트를 먼저 작성하고, 최소 구현으로 통과시키는 TDD workflow다.

## Canonical Surface

- 이 문서는 standalone TDD workflow다
- 표준 `cargo test`와 coverage 도구를 우선 사용한다

## Workflow

1. 타입, trait, 함수 계약을 먼저 고정한다
2. `#[test]` 기반 failing test를 먼저 쓴다
3. `cargo test`로 RED를 확인한다
4. 최소 구현으로 GREEN을 만든다
5. 테스트를 다시 실행한다
6. 필요하면 refactor한다
7. `cargo llvm-cov` 등 가능한 coverage 도구로 확인한다

## Test Guidance

- valid input
- invalid input
- ownership/borrowing edge case
- error aggregation
- `rstest`, async test, property-based test 패턴이 이미 있으면 그것을 따른다

## Verification

```bash
cargo test
cargo llvm-cov
```

## Output Expectations

- 추가한 테스트
- RED/GREEN 증거
- coverage 결과
- 남은 gap
