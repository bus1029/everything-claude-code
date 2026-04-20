---
description: Codex CLI port for an operator-invoked quality pipeline over a file or project scope.
---

# Quality Gate Skill Port

Codex CLI용 `quality-gate` 포트다. 파일 또는 프로젝트 범위에 대해 formatter, lint, type, test 신호를 모아 품질 상태를 판정한다.

## Inputs

- `[path|.]`
- `--fix`
- `--strict`

## Workflow

1. 대상 경로와 언어/tooling을 감지한다
2. formatter check를 수행한다
3. lint와 type check를 수행한다
4. 필요하면 test 또는 build까지 확장한다
5. remediation list를 간결하게 정리한다

## Notes

- hook 대체가 아니라 operator-invoked pipeline이다
- `--fix`가 있을 때만 자동 수정 범위를 넓힌다
- `--strict`는 경고도 실패로 다루는 모드다
