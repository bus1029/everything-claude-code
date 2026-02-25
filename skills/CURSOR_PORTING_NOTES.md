# Cursor Skill 이식/정리 노트

이 문서는 `skills/` 하위 스킬들을 **Cursor 환경에서 재사용**하기 위해,
이번 세션에서 수행한 **선별 기준**, **복사/동기화 방식**, **경로/표현 중립화 수정 내역**, **검증 방법**, **남은 TODO**를 정리한 것이다.

다른 에이전트가 이 문서만 보고도 `skills/cursor/`를 최신으로 유지하거나,
이식 불가 스킬을 Cursor용으로 재작성하는 작업을 바로 이어갈 수 있어야 한다.

---

## 목표

- `skills/`의 스킬들 중 **Cursor에서 바로 사용할 수 있는 스킬**을 `skills/cursor/`로 모은다.
- Claude Code 전용 런타임/경로 의존으로 바로 쓸 수 없는 스킬은 제외하되,
  **단순 경로 하드코딩 문제라면 `commands` 때처럼 수정(치환)하여 Cursor용으로 포함**한다.
- 최종적으로 `skills/cursor/` 안에는:
  - `.claude` / `~/.claude` 경로 하드코딩이 없어야 하고
  - `homunculus`/`instinct` 등 Claude Code 전용 시스템 전제가 없어야 하며
  - “Claude Code/Claude/claude-* 모델명” 같은 서술은 **가능하면 범용 LLM 표현으로 정리**되어야 한다.
  - 단, 레포 규칙 문서인 `CLAUDE.md`(파일명) 참조는 유지될 수 있다.

---

## “바로 이식 불가” 판정 기준(Claude Code 전용 의존)

아래 중 하나라도 **강하게 전제**하면 Cursor에서 “그대로” 이식이 어렵다고 보고 제외 후보로 분류한다.

- **Claude Code 전용 경로/저장소 전제**: `.claude/`, `~/.claude/`
- **Hook 기반 동작 전제**: `~/.claude/settings.json`에 특정 Hook을 추가해야 작동하는 설계
- **homunculus/instinct 전제**: `homunculus`, `instinct-*` (continuous-learning-v2 계열)
- **전용 스크립트/런타임 결합**: 특정 CLI/디렉터리 구조/산출물 경로가 `.claude`에 고정된 경우

단, 위가 “문서/예시의 경로 하드코딩” 정도라면 **Cursor 관례로 치환하여 이식 가능**하다.

---

## `skills/cursor/` 동기화(복사) 방식

### 1) 기본 미러링(디렉터리 구조 유지)

스킬은 대부분 `<skill-name>/SKILL.md` 형태이며 파일명이 동일(`SKILL.md`)하므로,
평탄화(copy to one folder)는 불가능하다. 반드시 디렉터리 구조를 유지해 복사한다.

권장: `rsync`로 `skills/` → `skills/cursor/`를 미러링하되, 제외 디렉터리를 `--exclude`한다.

### 2) “경로만 문제인 스킬”은 별도 포함 + 치환

업데이트 이후 스캔 결과, 일부 스킬은 개념은 유효하지만 `.claude` 경로 하드코딩만 문제였고,
이 경우 `skills/cursor/<skill-name>/...`로 복사한 뒤 `.cursor` + `<HOME>/<REPO>`로 치환해서 포함했다.

---

## 이번 세션에서 “경로만 수정해서 Cursor용으로 포함”한 스킬 목록

아래 5개는 **개념 자체는 Cursor에서도 유효**했고, 문제는 `.claude/~/.claude` 경로 하드코딩이어서
Cursor 버전으로 치환 후 `skills/cursor/`에 포함했다.

- `skills/cursor/search-first/`
  - `~/.claude/settings.json` → `<HOME>/.cursor/settings.json` (또는 Cursor 설정 UI)
  - `~/.claude/skills/` → `<HOME>/.cursor/skills/`
  - “Claude Code skills / Claude SDK” 표현을 범용 “Cursor skills / LLM SDK”로 정리
- `skills/cursor/security-scan/`
  - 스캔 대상 `.claude/` → `.cursor/`로 치환(문서/예시 커맨드)
- `skills/cursor/skill-stocktake/`
  - 문서 경로: `~/.claude/skills/`, `$PWD/.claude/skills` → `.cursor` 경로로 치환
  - 스크립트도 함께 수정:
    - `skills/cursor/skill-stocktake/scripts/scan.sh`
    - `skills/cursor/skill-stocktake/scripts/quick-diff.sh`
- `skills/cursor/eval-harness/`
  - eval 저장 위치 `.claude/evals/` → `.cursor/evals/`
  - “Claude Code/Claude” 서술을 “AI 작업/LLM 평가”로 중립화
- `skills/cursor/iterative-retrieval/`
  - `~/.claude/agents/` → `<REPO>/.cursor/agents/` / `<HOME>/.cursor/agents/`로 중립화

추가로, `skills/cursor/` 내 일부 범용 스킬에서 남아있던 `claude-*` 모델명 예시는
`llm-strong-model`, `llm-fast-cheap-model` 같은 **범용 예시 모델명**으로 변경했다.

---

## 여전히 제외 유지(경로 이상의 Claude 전용 개념/훅 전제)

아래는 경로만 바꿔서는 “바로 사용”이 어렵다고 보고 `skills/cursor/`에서 제외 유지했다.

- `skills/configure-ecc/`
  - 설치/부트스트랩 자체가 Claude Code 플러그인/설정 구조를 전제(설치 마법사 성격)
- `skills/continuous-learning/`
  - Stop hook 기반 자동 학습 + `~/.claude/skills/learned/` 저장 구조 전제
- `skills/continuous-learning-v2/`
  - observation hook + `~/.claude/homunculus/...` + instinct 커맨드 생태계 전제
- `skills/strategic-compact/`
  - PreToolUse hook 전제 + 특정 스크립트 실행 경로 전제

---

## 검증(Verification) 체크리스트

### A) Cursor 스킬 폴더에 Claude 전용 경로/시스템 흔적이 없는지

다음 키워드가 `skills/cursor/`에서 0건이어야 한다.

- `.claude` / `~/.claude`
- `homunculus`
- `instinct-`
- `codeagent-wrapper`
- `mcp__`

### B) 서술 레벨 “Claude/Claude Code” 잔존 확인

가능하면 다음 표현도 0건으로 맞춘다.

- `Claude Code`, `Claude`, `claude-` (모델명 예시 포함)

단, `CLAUDE.md`는 이 레포에서 “규칙/가이드 문서 파일명”으로 쓰이므로,
해당 파일명을 가리키는 참조는 허용될 수 있다.

### C) 시크릿 패턴 검토(오해 방지)

`sk-...` 같은 문자열이 “금지 예시”로 등장할 수 있다.
실제 키가 아니라도 경고/필터에 걸릴 수 있으니, 필요하면 `<API_KEY>` 같은 플레이스홀더로 바꾼다.

---

## 재현 가능한 스캔/동기화 커맨드(참고)

> 아래는 한 번에 실행하기 위한 예시다. 필요에 맞게 제외 목록을 조정한다.

```bash
# 1) skills/에서 비이식 마커가 있는 디렉터리 후보 추출(대략)
rg -l "~\/\.claude\b|\B\.claude\b|homunculus\b|instinct-|codeagent-wrapper\b|mcp__" skills --glob '!cursor/**' \
  | sed -E 's|^skills/([^/]+).*|\1|' | sort -u

# 2) skills → skills/cursor 미러링(예시: exclude는 필요에 맞게 갱신)
mkdir -p skills/cursor
rsync -a --delete \
  --exclude='cursor/' \
  --exclude='configure-ecc/' \
  --exclude='continuous-learning/' \
  --exclude='continuous-learning-v2/' \
  --exclude='strategic-compact/' \
  skills/ skills/cursor/

# 3) skills/cursor 전체 검증
rg -n "~\/\.claude\b|\B\.claude\b|homunculus\b|instinct-|codeagent-wrapper\b|mcp__" skills/cursor -S
rg -n "Claude Code|\bClaude\b|claude-" skills/cursor -S
```

---

## 다음 작업 TODO(다음 에이전트용)

- [ ] `configure-ecc`를 Cursor용 설치 가이드로 재작성할지 결정
  - (권장) `.cursor/skills`, `.cursor/rules` 중심으로 재작성
- [ ] `continuous-learning`, `continuous-learning-v2`, `strategic-compact`를 Cursor 환경에서 재현 가능한 방식으로 재설계 가능성 검토
  - Cursor에서 Hook/자동 실행 모델이 다르면 “문서만”으로 남기거나,
    “수동 실행 워크플로”로 축소해 이식할지 결정
- [ ] `skills/cursor/`에서 `sk-...` 금지 예시 문자열을 전부 `<API_KEY>`로 통일할지 결정(팀 정책에 따라)

---

## 메모

- 이 문서의 목적은 “완벽한 실행 스크립트 제공”이 아니라,
  Cursor에서 스킬 문서를 읽는 에이전트가 **일관된 절차로 선별/치환/검증**을 수행하도록 만드는 것이다.

<!-- End of file -->

