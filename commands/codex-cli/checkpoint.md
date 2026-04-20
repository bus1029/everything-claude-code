---
description: Codex CLI port for creating, verifying, listing, and pruning workflow checkpoints with neutral storage paths.
---

# Checkpoint Skill Port

Codex CLI용 `checkpoint` 포트다. 특정 작업 시점의 상태를 기록하고, 이후 비교와 회귀 점검에 쓰는 workflow다.

## Canonical Surface

- 이 문서는 standalone workflow다
- 저장 위치는 특정 Claude 경로로 고정하지 않고 `<REPO_STATE_DIR>/checkpoints.log` 같은 중립 경로를 쓴다
- Git commit, stash, 태그, 메모 로그 중 현재 repo에 맞는 수단을 사용한다

## Supported Modes

- `create <name>`
- `verify <name>`
- `list`
- `clear`

## Create

1. 먼저 quick verification을 수행해 현재 상태가 깨져 있지 않은지 확인한다
2. checkpoint 이름과 현재 `HEAD` 또는 작업 상태를 기록한다
3. `<REPO_STATE_DIR>/checkpoints.log`에 시간, 이름, SHA, 메모를 남긴다
4. 어떤 기준으로 checkpoint를 잡았는지 요약한다

예시 로그 형식:

```text
2026-04-20-1430 | feature-start | a1b2c3d | quick verification passed
```

## Verify

1. `<REPO_STATE_DIR>/checkpoints.log`에서 기준 checkpoint를 찾는다
2. 현재 상태와 비교한다
3. 아래 차이를 요약한다

- 변경 파일 수
- 테스트 상태 변화
- coverage 변화
- build 상태 변화

## List

- checkpoint 이름
- 생성 시각
- 연결된 SHA
- 현재 브랜치 기준 상태

## Clear

- 오래된 checkpoint를 정리한다
- 기본 동작은 최근 5개를 남기고 정리한다

## Output Expectations

- checkpoint 이름
- 기준 SHA 또는 상태
- 검증 결과
- 다음에 어느 시점에서 새 checkpoint를 찍으면 좋은지
