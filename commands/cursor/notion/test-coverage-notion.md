# `/test-coverage` — 커버리지 리포트를 분석하고 80%+가 되도록 “빠진 테스트”를 채우는 커맨드

`/test-coverage`는 프로젝트의 테스트 프레임워크를 감지한 뒤, **커버리지 리포트를 파싱**해 80% 미만 파일을 찾고, **우선순위 규칙에 따라 누락된 테스트를 생성/보강**해 전체 커버리지를 80%+로 끌어올리는 커맨드입니다.

# 한눈에 보기(요약)

### 역할

- 프로젝트의 **테스트/커버리지 도구 자동 감지**
- 커버리지 리포트 실행 → 결과 파싱(JSON/터미널)
- **80% 미만 파일**을 최악(worst-first) 순으로 정렬
- 각 파일에서 미검증 함수/분기/에러 경로를 찾아 **테스트 생성**
- 전체 테스트/커버리지 재실행으로 개선 여부를 검증

### 언제 쓰나

- 커버리지가 80% 미만이라 **갭을 체계적으로 메우고 싶을 때**
- 회귀가 잦은 영역(유틸/검증/핸들러 등)을 테스트로 단단히 만들고 싶을 때
- CI에서 커버리지 게이트가 걸려 통과가 필요할 때

### 출력(결과물)

- 어떤 프레임워크/커맨드로 커버리지를 측정했는지
- 80% 미만 파일 목록(낮은 순)
- 파일별로 추가된 테스트(해피패스/에러/엣지/분기)
- Before/After 커버리지 비교 요약

# 어떻게 쓰나(1분 사용법)

1. `/test-coverage`를 실행합니다.
2. 감지된 프레임워크에 맞는 커버리지 커맨드를 실행합니다.
3. 80% 미만 파일부터 순서대로 테스트를 추가합니다.
4. 전체 테스트/커버리지를 다시 돌려 80%+ 달성을 확인합니다.

# 이 커맨드가 하는 일(진행 흐름)

### 1) 테스트 프레임워크 감지 → 커버리지 커맨드 선택

| Indicator | Coverage Command |
|-----------|-----------------|
| `jest.config.*` 또는 `package.json` jest | `npx jest --coverage --coverageReporters=json-summary` |
| `vitest.config.*` | `npx vitest run --coverage` |
| `pytest.ini` / `pyproject.toml` pytest | `pytest --cov=<PY_APP_PKG> --cov-report=json` |
| `Cargo.toml` | `cargo llvm-cov --json` |
| `pom.xml` + JaCoCo | `mvn test jacoco:report` |
| `go.mod` | `go test -coverprofile=coverage.out ./...` |

> 참고: `<PY_APP_PKG>`는 pytest 커버리지 기준 패키지/모듈 이름으로 치환합니다(예: `src`, `app`, `your_package`).

### 2) 커버리지 리포트 분석

- 전체 커버리지 리포트를 생성/수집
- **80% 미만 파일을 최악 순으로 정렬**
- 각 파일에서 아래를 집중 탐색
  - 미검증 함수/메서드
  - 분기 커버리지 누락(if/else, switch, 에러 경로)
  - 사실상 죽은 코드(분모만 키우는 코드)

### 3) 테스트 생성 우선순위(권장)

1. **Happy path**: 정상 입력/정상 흐름
2. **Error handling**: 잘못된 입력, 누락 데이터, 실패 케이스
3. **Edge cases**: 빈 배열/빈 문자열/null/undefined/경계값
4. **Branch coverage**: 모든 if/else, switch case 등 분기 채우기

### 4) 검증

- 전체 테스트 통과 확인
- 커버리지 재측정으로 개선 확인
- 80% 미만이 남아 있으면 3)으로 반복

# 실무 팁 / 주의사항(중요)

- 외부 의존성(DB/API/파일시스템)은 **mock**으로 격리해 테스트를 안정화하는 게 기본입니다.
- 테스트는 서로 **독립적**이어야 합니다(공유 mutable 상태 금지).
- 테스트 파일 위치/이름은 프로젝트 기존 컨벤션을 따르는 게 유지보수 비용이 낮습니다.

# Quick Commands(실행 예)

```bash
# Jest
npx jest --coverage --coverageReporters=json-summary

# Vitest
npx vitest run --coverage

# Pytest
pytest --cov=src --cov-report=json

# Go
go test -coverprofile=coverage.out ./...

# Rust
cargo llvm-cov --json
```

