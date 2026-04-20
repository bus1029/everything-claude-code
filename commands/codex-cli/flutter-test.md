---
description: Codex CLI port for Flutter and Dart test execution, failure triage, and incremental fixes.
---

# Flutter Test Skill Port

Codex CLI용 `flutter-test` 포트다. 이 문서는 Flutter/Dart 테스트를 실행하고 실패를 분류해 하나씩 고치는 workflow다.

## Canonical Surface

- 이 문서는 standalone test-run and fix workflow다
- build/review role이 필요하더라도 자동 호출하지 않는다

## When To Use

- 기능 구현 후 회귀를 확인할 때
- 특정 unit/widget/integration test가 실패할 때
- golden update 여부를 판단할 때
- coverage를 다시 확인할 때

## Workflow

1. 적절한 테스트 범위를 선택한다
2. `flutter test` 또는 더 좁은 타깃으로 실행한다
3. 실패를 유형별로 나눈다

- assertion mismatch
- widget finder mismatch
- golden failure
- plugin/mock setup 문제
- timing 문제

4. 한 번에 한 실패만 고친다
5. 관련 테스트를 다시 실행한다
6. 필요한 경우 coverage나 integration 범위까지 넓힌다

## Commands

```bash
flutter test
flutter test --coverage
flutter test test/path/to/file_test.dart
flutter test --name "CartBloc"
flutter test integration_test/
flutter test --update-goldens
```

## Guardrails

- goldens는 intentional visual change일 때만 업데이트한다
- failing assertion을 그냥 현재 출력에 맞춰 바꾸기 전에 구현 의도부터 확인한다
- Flutter review/build 관련 추가 점검은 필요할 때만 별도 workflow로 분리한다

## Related Workflows

- source command는 `flutter-reviewer`, `dart-build-resolver`를 관련 agent로 다뤘다
- 다만 이 이름들은 Codex에서 callable role로 보장되지 않으므로, 현재 세션 표면에 실제로 있을 때만 명시적으로 호출한다

## Output Expectations

- 실행 범위
- 실패 유형별 원인
- 수정 내용
- 재실행 결과
- coverage 또는 남은 리스크
