# `/checkpoint` — 작업 중간중간 “되돌아갈 수 있는 지점”을 만들고 비교하는 커맨드

`/checkpoint`는 개발 흐름에서 특정 시점을 **체크포인트로 저장(create)**하거나, 나중에 그 체크포인트 대비 현재 상태를 **비교 검증(verify)**하거나, 저장된 체크포인트를 **목록(list)**으로 확인하는 슬래시 커맨드입니다.  
체크포인트 메타데이터는 `.cursor/checkpoints.log`에 기록됩니다.

# 한눈에 보기(요약)

### 역할

- 깨끗한 상태인지 빠르게 확인한 뒤 체크포인트 생성
- 체크포인트 시점(커밋/스태시)과 현재 상태를 비교해 변경 범위를 요약
- 체크포인트 목록을 관리(조회/정리)

### 언제 쓰나

- 큰 작업 시작 전 “**돌아갈 기준점**”이 필요할 때
- 구현/리팩터링/테스트 단계 사이에 “**중간 저장**”을 남기고 싶을 때
- 현재 상태가 체크포인트 대비 **앞섰는지/뒤졌는지** 빠르게 확인하고 싶을 때

### 출력(결과물)

- 체크포인트 생성 결과(이름/시간/짧은 SHA)
- 체크포인트 대비 비교 요약(변경 파일 수, 빌드/테스트/커버리지 변화 등)
- 체크포인트 목록(이름/타임스탬프/SHA/상태)

# 어떻게 쓰나(1분 사용법)

아래 형태로 사용합니다.

`/checkpoint [create|verify|list|clear] [name]`

- `create <name>`: 이름을 붙여 체크포인트 생성
- `verify <name>`: 해당 체크포인트와 현재 상태를 비교
- `list`: 체크포인트 목록 출력
- `clear`: 오래된 체크포인트 정리(최근 5개 유지)

# 이 커맨드가 하는 일(진행 흐름)

### create

- 현재 상태가 깨끗한지 빠르게 확인하기 위해 `/verify quick`를 먼저 수행
- 체크포인트 이름으로 **git stash 또는 commit** 생성
- `.cursor/checkpoints.log`에 타임스탬프/이름/SHA를 기록

### verify

- `.cursor/checkpoints.log`에서 지정한 체크포인트를 찾음
- 체크포인트 대비 현재 상태를 비교
  - 체크포인트 이후 추가/수정된 파일
  - 테스트 통과/실패 변화
  - 커버리지 변화
  - 빌드 상태(PASS/FAIL)
- 비교 리포트를 텍스트로 출력

### list

- 체크포인트를 시간순으로 나열
- 각 항목에 대해 이름/시간/SHA 및 현재 대비 상태(current/behind/ahead)를 표시

# 실무 팁 / 주의사항(중요)

- 체크포인트는 “세이브 포인트”입니다. **작업을 크게 바꾸기 전**에 찍어두면 복구 비용이 급감합니다.
- `create` 전에 `/verify quick`로 최소한의 건강 상태를 확인해두면, 나중에 비교가 훨씬 의미 있어집니다.
- 로그 파일은 `.cursor/checkpoints.log`이므로, 팀에서 공유/버전관리할지 여부는 프로젝트 정책에 맞춰 결정하세요.

# Quick Commands(실행 예)

```text
/checkpoint create "feature-start"
/checkpoint create "core-done"
/checkpoint verify "core-done"
/checkpoint list
/checkpoint clear
```

