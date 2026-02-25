# Cursor Command 이식/정리 노트

이 문서는 `commands/` 하위 커맨드 `.md`들을 **Cursor 환경에서 재사용**하기 위해,
이번 세션에서 수행한 **조사 결과(이식 가능/불가 기준)**와 **수정 내역(경로 중립화)**을 정리한 것이다.
다른 에이전트가 이 문서를 보고 커맨드 관련 작업(선별/포팅/정리/리뷰)을 이어갈 수 있어야 한다.

---

## 목표

- `commands/`의 커맨드 문서 중 **Cursor에 그대로 이식 가능한 것**과 **Claude Code 전용으로 이식이 어려운 것**을 구분한다.
- `commands/cursor/`에 복사한 커맨드들 중, **경로 하드코딩 때문에 다른 레포에서 깨질 수 있는 부분**을
  플레이스홀더로 **중립화(범용화)**하여 재사용성을 높인다.

---

## 이식 불가 판정 기준(Claude Code 전용 의존)

아래 중 하나라도 강하게 전제하면 “그대로 Cursor 이식 불가”로 분류했다.

- **Claude Code 전용 경로/저장소**: `~/.claude/*`, `.claude/*`
- **Homunculus / instinct 시스템**: `~/.claude/homunculus/*`, `instinct-*`
- **전용 래퍼/멀티모델 런타임**: `~/.claude/bin/codeagent-wrapper`, `mcp__ace-tool__*`
- **전용 세션/체크포인트 관리**: `~/.claude/sessions/*`, `.claude/checkpoints.log`

이 범주에 해당하는 커맨드는 “포팅”이 아니라 **새로운 Cursor용 커맨드로 재작성**이 필요하다.

---

## 이번 세션에서 “이식 불가”로 분류한 커맨드(대표 범주)

다음 파일들은 위 기준에 의해 Cursor로 그대로 옮기면 의미/동작이 유지되지 않는다.

- **세션/체크포인트(Claude 세션 시스템 의존)**:
  - `commands/sessions.md`
- **Instinct/학습/진화(continuous-learning-v2/Homunculus 전제)**:
  - `commands/instinct-status.md`
  - `commands/instinct-export.md`
  - `commands/instinct-import.md`
  - `commands/evolve.md`
- **멀티모델/래퍼/MCP 강결합**:
  - `commands/multi-plan.md`
  - `commands/multi-workflow.md`
  - `commands/multi-execute.md`
  - `commands/multi-frontend.md`
  - `commands/multi-backend.md`
- **`.claude/*` 산출물/설정 전제**:
  - `commands/pm2.md`

---

## Cursor로 “그대로 이식 가능”으로 본 커맨드(1차 선별)

아래 커맨드들은 `.claude/~/.claude` 같은 Claude 전용 런타임 의존이 없거나,
의존이 있더라도 **경로/문구만 정리하면** Cursor에서 의미를 유지할 수 있는 타입으로 분류했다.

> 참고: 이 목록은 “완벽히 실행 가능한 CLI”가 아니라,
> Cursor의 커맨드/에이전트가 **절차를 따르도록 유도하는 문서**로서의 이식 가능성을 의미한다.

- `commands/code-review.md`
- `commands/git-commit.md`
- `commands/verify.md`
- `commands/setup.md`
- `commands/setup-pm.md`
- `commands/tdd.md`
- `commands/build-fix.md`
- `commands/test-coverage.md`
- `commands/refactor-clean.md`
- `commands/eval.md`
- `commands/plan.md`
- `commands/e2e.md`
- `commands/checkpoint.md`
- `commands/learn.md`
- `commands/learn-eval.md`
- `commands/python-review.md`
- `commands/go-build.md`
- `commands/go-test.md`
- `commands/go-review.md`
- `commands/update-docs.md`
- `commands/update-codemaps.md`
- `commands/orchestrate.md`

이 22개는 실제로 `commands/cursor/` 하위로 복사해 관리하기로 했다.

---

## `commands/cursor/` 현황

`commands/cursor/`에는 위 22개 커맨드가 존재한다.

- `verify.md`
- `tdd.md`
- `go-build.md`
- `go-review.md`
- `git-commit.md`
- `go-test.md`
- `update-codemaps.md`
- `test-coverage.md`
- `refactor-clean.md`
- `update-docs.md`
- `eval.md`
- `plan.md`
- `e2e.md`
- `setup-pm.md`
- `checkpoint.md`
- `learn.md`
- `learn-eval.md`
- `orchestrate.md`
- `setup.md`
- `build-fix.md`
- `python-review.md`
- `code-review.md`

---

## 경로 하드코딩 중립화(플레이스홀더 도입)

`commands/cursor/` 안에서 다른 레포에서도 그대로 쓰기 어렵게 만드는 **하드코딩 경로**를
플레이스홀더로 대체했다.

### 도입한 플레이스홀더(의미)

- `<HOME>`: 사용자 홈 디렉터리
- `<REPO>`: 현재 레포 루트
- `<APP_DIR>`: 프로젝트의 주요 소스 루트 디렉터리 (예: `src`, `app`, `lib`, `packages/<name>/src`)
- `<DOCS_DIR>`: 문서 루트 디렉터리 (예: `docs`, `documentation`, `.docs`)
- `<CODEMAP_DIR>`: 코드맵 문서 디렉터리 (예: `docs/CODEMAPS`, `documentation/codemaps`)
- `<REPORTS_DIR>`: 리포트/분석 산출물 디렉터리 (예: `.reports`, `reports`)
- `<PY_APP_DIR>`: Python 애플리케이션/패키지 루트 디렉터리 (예: `src`, `app`, `your_package`)
- `<PY_APP_PKG>`: pytest 커버리지 기준 패키지/모듈명 (예: `src`, `app`, `your_package`)
- `<CONTEXT_PACK_PATH_PRIMARY>`: 컨텍스트 팩 1순위 저장 경로(예: `docs/PROJECT_CONTEXT.md`)
- `<CONTEXT_PACK_PATH_FALLBACK>`: 컨텍스트 팩 대체 저장 경로(예: `.cursor/PROJECT_CONTEXT.md`)

---

## 중립화 적용 파일(이번 세션에서 실제 수정됨)

아래 파일들은 “경로 같은 간단한 문제로 못 쓰게 되는 상황”을 줄이기 위해 수정했다.

- `commands/cursor/tdd.md`
  - `~/.cursor/agents/tdd-guide.md` 하드코딩 제거 → `<REPO>`/`<HOME>` 경로로 일반화
- `commands/cursor/refactor-clean.md`
  - `vulture src/` → `vulture <PY_APP_DIR>/` + 치환 안내 추가
- `commands/cursor/test-coverage.md`
  - `pytest --cov=src ...` → `pytest --cov=<PY_APP_PKG> ...`
  - 샘플 리포트의 `src/...` → `<APP_DIR>/...`
  - 노트에 `<PY_APP_PKG>`, `<APP_DIR>` 추가
- `commands/cursor/update-docs.md`
  - `docs/*` 경로 → `<DOCS_DIR>/*` + 치환 안내 추가
- `commands/cursor/update-codemaps.md`
  - `docs/CODEMAPS/` → `<CODEMAP_DIR>/`
  - `.reports/*` → `<REPORTS_DIR>/*`
  - 예시 `src/*` → `<APP_DIR>/*`
  - 치환 안내 추가
- `commands/cursor/setup.md`
  - 컨텍스트 팩 저장 경로 하드코딩 제거 → `<CONTEXT_PACK_PATH_PRIMARY>` / `<CONTEXT_PACK_PATH_FALLBACK>`
  - 권장값(예시) 주석 추가
- `commands/cursor/setup-pm.md`
  - `.claude/package-manager.json` → `<REPO>/.cursor/package-manager.json`
  - `~/.claude/package-manager.json` → `<HOME>/.cursor/package-manager.json`
- `commands/cursor/python-review.md`
  - `pytest --cov=app ...` → `pytest --cov=<PY_APP_PKG> ...`
  - 예시 경로 `app/...` → `<PY_APP_DIR>/...`
  - `black app/...` → `black <PY_APP_DIR>/...`
  - 치환 안내 추가
- `commands/cursor/plan.md`
  - `~/.claude/agents/planner.md` → `<REPO>/.cursor/agents/planner.md` / `<HOME>/.cursor/agents/planner.md`
- `commands/cursor/e2e.md`
  - `~/.claude/agents/e2e-runner.md` → `<REPO>/.cursor/agents/e2e-runner.md` / `<HOME>/.cursor/agents/e2e-runner.md`
- `commands/cursor/checkpoint.md`
  - `.claude/checkpoints.log` → `<REPO>/.cursor/checkpoints.log`
- `commands/cursor/learn.md`
  - `~/.claude/skills/learned/` → `<HOME>/.cursor/skills/learned/` + `<REPO>/.cursor/skills/learned/` 옵션 추가
- `commands/cursor/learn-eval.md`
  - `~/.claude/skills/learned/` / `.claude/skills/learned/` → `<HOME>/.cursor/skills/learned/` / `<REPO>/.cursor/skills/learned/`

---

## 후속 작업 체크리스트(다음 에이전트용)

### 1) 새 커맨드가 Cursor로 이식 가능한지 빠르게 판단

- [ ] `.claude` / `~/.claude` / `CLAUDE_PLUGIN_ROOT` / `homunculus` / `mcp__` / `codeagent-wrapper` 문자열이 있는가?
  - 있으면 “그대로 이식”은 보통 불가 → Cursor용 재작성 고려
- [ ] 특정 레포 구조(`src/`, `app/`, `docs/`)를 “규칙”처럼 강제하고 있나?
  - 강제라면 플레이스홀더로 중립화

### 2) 플레이스홀더 추가 시 원칙

- 커맨드 본문에서 경로를 “정답”처럼 말하지 말고,
  - 플레이스홀더 + 치환 예시를 함께 제시한다.
- “생성/저장 위치”는 최소 2개 옵션(Primary/Fallback)을 둔다.

---

## 메모

- 이 문서의 목적은 “실행 가능한 스크립트 제공”이 아니라,
  Cursor에서 커맨드 문서를 읽는 에이전트가 **일관된 절차를 수행하도록 만드는 것**이다.
- 따라서 경로/도구는 가능하면 범용적으로 표현하고,
  프로젝트별 차이는 플레이스홀더로 흡수한다.

