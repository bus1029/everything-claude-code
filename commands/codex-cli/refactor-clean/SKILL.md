---
name: refactor-clean
description: Codex CLI port for dead-code and duplicate cleanup using the built-in refactor-cleaner role.
---

# Refactor Clean Skill Port

Codex CLI용 `refactor-clean` 포트다. 핵심은 "죽은 코드와 중복을 안전하게 줄이되, 한 번에 크게 흔들지 않는다"는 점이다.

## Canonical Surface

- 권장 role은 built-in `refactor-cleaner`다.
- 이 workflow는 기능 추가가 아니라 안전한 축소와 정리다.
- 삭제 후보 식별, 위험도 분류, 작은 단위 수정, 즉시 검증의 루프를 유지한다.

## Workflow

1. 정리 범위를 정한다. 디렉터리, 패키지, 또는 변경된 파일 집합으로 좁힌다.
2. 가능한 경우 언어별 dead-code 도구를 실행해 후보를 모은다.
3. 명시적으로 서브에이전트 `refactor-cleaner`를 호출하여 후보를 SAFE, CAUTION, DANGER로 분류한다.
4. SAFE 항목부터 작은 단위로 제거하거나 통합한다.
5. 각 수정 뒤에 관련 테스트와 빌드를 다시 실행한다.
6. 실패하면 방금 변경만 되돌려 작업 트리를 복구한 뒤 다음 후보로 넘어간다.
7. CAUTION 항목은 동적 참조, public API, config wiring을 확인한 뒤에만 진행한다.
8. DANGER 항목은 별도 계획 없이 건드리지 않는다.

## Suggested Checks

```bash
npx knip
npx depcheck
npx ts-prune
vulture <PY_APP_DIR>/
deadcode ./...
cargo +nightly udeps
```

## Parallelism

- 여러 삭제 후보를 동시에 수정하지 않는다.
- read-only 후보 분석은 병렬로 가능하지만, 실제 수정과 검증은 직렬이 안전하다.
- rollback이 필요할 때도 마지막 변경 한 건만 되돌리는 방식으로 범위를 최소화한다.

## Merge Rules

- 같은 기능을 대체하는 중복 구현은 하나의 change set으로 묶는다.
- 테스트 실패를 유발한 삭제 후보는 즉시 rollback한 뒤 제외하고 다음 후보로 넘어간다.
- cleanup 범위를 넘어서는 설계 개선은 별도 작업으로 분리한다.

## Output Expectations

- 삭제/통합한 항목
- 건너뛴 항목과 이유
- 실행한 검증 명령
- 남은 cleanup 후보
