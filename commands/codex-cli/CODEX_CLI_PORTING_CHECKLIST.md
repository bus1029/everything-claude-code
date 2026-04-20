# Codex CLI 이식 체크리스트

이 문서는 `commands/` 루트의 `.md` 80개를 Codex CLI 기준으로 포팅하기 위한 실행 문서다. 다른 에이전트는 이 문서만 읽고도 각 command를 어떤 방식으로 옮겨야 하는지, 지금 당장 옮길 수 있는지, 선행 작업이 필요한지를 판단할 수 있어야 한다.

기준점은 두 가지다.

- 원본 command 문서가 문서 수준에서 Codex로 재사용 가능한가
- 현재 이 repo와 Codex 실행 환경에서 그 workflow를 실제로 재현할 수 있는가

참고 문서:

- [commands/CURSOR_PORTING_NOTES.md](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/commands/CURSOR_PORTING_NOTES.md)
- [agents/codex-cli/CODEX_CLI_AGENT_PORTING_CHECKLIST.md](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/CODEX_CLI_AGENT_PORTING_CHECKLIST.md)

## 현재 Codex 기준 사실

- 포팅 대상은 `commands/` 바로 아래 `.md` 파일 80개다
- `commands/CURSOR_PORTING_NOTES.md`는 참고 문서이며 포팅 대상이 아니다
- Codex 포팅의 기본 표면은 `command -> skill`이다
- `agents/*.md` 파일이 있다고 해서 Codex에서 그 이름으로 바로 spawn 가능한 것은 아니다
- repo-local custom role의 소스는 `.codex/config.toml`의 `[agents.<name>]` 섹션이다
- 현재 repo-local custom role은 `explorer`, `reviewer`, `docs_researcher` 세 개뿐이다
- `.codex/agents/*.toml` 파일에는 `name` 필드가 없으므로, agent 이름을 TOML 내부 `name`으로 해석하면 안 된다
- 현재 Codex 실행 환경에는 별도의 built-in role 표면도 있다
- 이번 포팅에서 바로 써도 되는 built-in role은 최소한 아래 정도로 본다
  - `planner`
  - `code-architect`
  - `refactor-cleaner`
  - `reviewer`
  - `security-reviewer`
  - `tdd-guide`
  - `comment-analyzer`
  - `pr-test-analyzer`
  - `silent-failure-hunter`
  - `type-design-analyzer`
  - `code-simplifier`
  - `go-build-resolver`
  - `go-reviewer`
  - `python-reviewer`
  - `java-build-resolver`
- 반대로 아래 이름들은 repo 안에 `agents/*.md`는 있어도 현재 Codex role 표면으로는 보장되지 않는다
  - `build-error-resolver`
  - `harness-optimizer`
  - `loop-operator`
  - `cpp-build-resolver`
  - `cpp-reviewer`
  - `dart-build-resolver`
  - `flutter-reviewer`
  - `kotlin-build-resolver`
  - `kotlin-reviewer`
  - `rust-build-resolver`
  - `rust-reviewer`
  - `gan-planner`
  - `gan-generator`
  - `gan-evaluator`

## 포팅 원칙

### 1. 먼저 command의 목표 표면을 정한다

- 기존 command를 그대로 Codex command처럼 흉내 내지 않는다
- 우선순위는 `standalone skill`, `legacy shim`, `skill + role orchestration`, `구현 포팅`, `재설계` 순서다

### 2. role 이름은 실제 Codex 표면에 맞춘다

- repo-local role은 `.codex/config.toml`에 있는 이름만 사용한다
- built-in role을 쓸 때는 현재 Codex 환경에 실제로 있는 이름만 사용한다
- `agents/*.md` 파일명이나 문서 속 agent 이름을 그대로 옮기지 않는다

### 3. 구현 의존이 있는 command는 문서만 옮기지 않는다

- 원본이 스크립트를 source of truth로 삼으면, 스크립트가 Codex 중립적인지 먼저 확인한다
- 스크립트가 `.claude/*`, `CLAUDE_PACKAGE_MANAGER`, `CLAUDE_PLUGIN_ROOT`, hook 설정, 세션 저장소를 직접 읽으면 구현 포팅이 먼저다

### 4. dirty shim은 원본 정리부터 한다

- `legacy shim`이어도 본문 뒤에 예전 playbook이 그대로 붙어 있으면 그 파일은 깨끗한 shim이 아니다
- 이런 파일은 먼저 command 원본을 정리한 뒤에 포팅한다

### 5. 경로는 가능한 한 중립화한다

- `.claude/*` 경로를 그대로 남기지 않는다
- 필요하면 `<REPO>`, `<HOME>`, `<DOCS_DIR>`, `<REPORTS_DIR>`, `<CODEMAP_DIR>` 같은 플레이스홀더를 쓴다
- repo에 이미 Codex 전용 경로가 정해져 있지 않다면 `.codex/*`를 함부로 새 표준처럼 만들지 않는다

### 6. 승인 대기와 사용자 상호작용은 workflow 핵심일 때만 유지한다

- 단순 slash 사용 예시는 제거한다
- 실제로 사용자 확인이 필요한 workflow라면 Codex 문맥에 맞게 유지한다

## 버킷 요약

- 참고 문서: 1개
- 즉시 포팅 가능한 clean legacy shim: 9개
- 원본 정리 후 포팅해야 하는 dirty shim: 3개
- standalone skill로 문서 재작성 가능한 항목: 22개
- 현재 role 표면으로 바로 orchestration 가능한 항목: 8개
- role이 없거나 부분 대응만 가능한 항목: 11개
- 구현 포팅이 먼저 필요한 항목: 2개
- Claude 전용 런타임 전제가 강해 재설계 또는 보류가 필요한 항목: 24개

합계는 80개다.

## 버킷 A

### 참고 문서

- `CURSOR_PORTING_NOTES.md`

처리 방식:

- Codex 분류의 참고 자료로만 사용
- 포팅 대상 체크리스트에는 포함하지 않음

## 버킷 B

### 즉시 포팅 가능한 clean legacy shim

이 그룹은 이미 `skills/<name>/SKILL.md`가 있고, 원본 command도 짧고 깨끗하다. Codex에서는 command 자체를 유지하기보다 “해당 skill로 연결하는 얇은 shim” 또는 “skill을 직접 쓰라는 안내 문서”로 포팅하면 된다.

- `agent-sort.md`
- `claw.md`
- `context-budget.md`
- `devfleet.md`
- `docs.md`
- `eval.md`
- `prompt-optimize.md`
- `rules-distill.md`
- `verify.md`

포팅 규칙:

- slash 예시는 제거
- Canonical surface를 skill 기준으로 다시 쓴다
- skill 이름과 목적만 남기고 중복 playbook은 넣지 않는다
- skill이 이미 canonical body라면 command 쪽에 workflow를 다시 복사하지 않는다

## 버킷 C

### 원본 정리 후 포팅해야 하는 dirty shim

겉으로는 shim인데, 실제 파일 뒤에 예전 playbook이 붙어 있다. 이 상태로 포팅하면 Codex용 문서도 중복과 충돌이 생긴다.

- `e2e.md`
- `orchestrate.md`
- `tdd.md`

포팅 규칙:

- 먼저 원본 command를 진짜 shim으로 정리
- 정리 후에는 버킷 B와 같은 방식으로 포팅
- 포팅 전에 “현재 본문에 남아 있는 residual content를 유지할지 폐기할지”를 source cleanup 관점에서 결정

주의:

- `tdd.md`는 shim 선언 뒤에 긴 예시 본문이 남아 있다
- `e2e.md`도 shim 본문 뒤에 장문의 Playwright playbook이 남아 있다
- `orchestrate.md`도 shim 선언 뒤에 별도 orchestration spec이 이어진다

## 버킷 D

### standalone skill로 문서 재작성 가능한 항목

이 그룹은 Codex role이 꼭 없어도 된다. 핵심은 문서 재작성, 경로 중립화, Claude 문맥 제거다.

- `aside.md` — `Claude` 지칭을 Codex 문맥으로 교체
- `checkpoint.md` — `.claude/checkpoints.log`를 중립 경로 또는 플레이스홀더로 교체
- `code-review.md` — `.claude/PRPs/*`, `CLAUDE.md` 참조를 중립화
- `cpp-test.md` — slash 예시 제거, 테스트 절차형 skill로 재작성
- `flutter-test.md` — review/build agent 참조를 제거하거나 선택 사항으로 격하
- `go-test.md` — slash 예시 제거, 테스트 절차형 skill로 재작성
- `jira.md` — Jira skill 또는 MCP 사용 문맥으로 재작성
- `learn.md` — learned skill 저장 경로를 중립화
- `learn-eval.md` — learned skill 경로와 검색 경로를 중립화
- `model-route.md` — standalone routing guide로 포팅
- `prp-commit.md` — 다음 단계 slash 참조를 Codex 흐름으로 재작성
- `prp-implement.md` — `.claude/PRPs/*` 출력 경로를 중립화
- `prp-plan.md` — `.claude/PRPs/plans` 경로를 중립화
- `prp-pr.md` — `.claude/PRPs/*` 참조를 중립화
- `prp-prd.md` — `.claude/PRPs/prds` 경로를 중립화
- `quality-gate.md` — standalone verification skill로 포팅
- `skill-create.md` — Claude skill/instinct 문맥을 Codex skill 생성 문맥으로 재작성
- `test-coverage.md` — 특정 폴더 가정과 예시 경로를 플레이스홀더로 교체
- `update-codemaps.md` — `docs/CODEMAPS`, `.reports` 경로를 플레이스홀더로 교체
- `update-docs.md` — 문서 출력 위치를 프로젝트 중립적으로 교체
- `kotlin-test.md` — slash 예시 제거, 테스트 절차형 skill로 재작성
- `rust-test.md` — slash 예시 제거, 테스트 절차형 skill로 재작성

포팅 규칙:

- command 문법보다 skill 문법으로 다시 쓴다
- 특정 tool invocation을 강제하지 말고 목표와 검증 기준을 중심으로 재서술한다
- 경로와 출력물 위치는 중립화한다
- PRP, learned skill, reports처럼 `.claude/*`에 묶인 저장 위치는 configurable placeholder로 바꾼다

## 버킷 E

### 현재 role 표면으로 바로 orchestration 가능한 항목

이 그룹은 Codex-native skill + explicit role orchestration으로 바로 옮길 수 있다. 다만 어떤 role이 repo-local인지, 어떤 role이 built-in인지 문서에 명시해야 한다.

- `feature-dev.md`
  - 권장 role
  - repo-local `explorer`
  - built-in `code-architect`
  - repo-local `reviewer`
- `go-build.md`
  - 권장 role
  - built-in `go-build-resolver`
- `go-review.md`
  - 권장 role
  - built-in `go-reviewer`
- `plan.md`
  - 권장 role
  - built-in `planner`
- `python-review.md`
  - 권장 role
  - built-in `python-reviewer`
- `refactor-clean.md`
  - 권장 role
  - built-in `refactor-cleaner`
- `review-pr.md`
  - 권장 role
  - repo-local `reviewer`
  - built-in `comment-analyzer`
  - built-in `pr-test-analyzer`
  - built-in `silent-failure-hunter`
  - built-in `type-design-analyzer`
  - built-in `code-simplifier`
  - optional built-in `security-reviewer`
- `santa-loop.md`
  - 권장 role
  - repo-local `reviewer`
  - built-in `security-reviewer`
  - 필요 시 외부 read-only review surface 추가

포팅 규칙:

- skill 본문에 어떤 role을 어떤 순서로 쓸지 명시
- 병렬 가능한 단계와 기다려야 하는 단계를 구분
- role 산출물의 merge 방식까지 적는다
- `feature-dev.md`처럼 승인 대기가 workflow 핵심인 문서는 그 승인 단계를 유지

## 버킷 F

### role이 없거나 부분 대응만 가능한 항목

이 그룹은 문서형 skill 초안은 가능하지만, 원래 workflow fidelity를 role-backed 방식으로 재현하려면 Codex role 표면이 더 필요하다. 이 repo에 `agents/*.md`가 있더라도 현재 Codex에서 바로 부를 수 있다고 가정하면 안 된다.

- `build-fix.md`
  - 필요한 역할: 범용 `build-error-resolver`
  - 현재 대응: `go-build-resolver`, `java-build-resolver` 정도만 부분 대응
- `cpp-build.md`
  - 필요한 역할: `cpp-build-resolver`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `cpp-review.md`
  - 필요한 역할: `cpp-reviewer`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `flutter-build.md`
  - 필요한 역할: `dart-build-resolver`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `flutter-review.md`
  - 필요한 역할: `flutter-reviewer`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `gradle-build.md`
  - 필요한 역할: `kotlin-build-resolver` 또는 Gradle 전용 resolver
  - 현재 대응: `java-build-resolver`로 Java/Android 일부만 부분 대응
- `kotlin-build.md`
  - 필요한 역할: `kotlin-build-resolver`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `kotlin-review.md`
  - 필요한 역할: `kotlin-reviewer`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `loop-status.md`
  - 필요한 역할: `loop-operator`
  - 현재 상태: role 표면 없음
- `rust-build.md`
  - 필요한 역할: `rust-build-resolver`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음
- `rust-review.md`
  - 필요한 역할: `rust-reviewer`
  - 현재 상태: repo 문서는 있으나 Codex role 표면 없음

포팅 규칙:

- 지금 당장 옮겨야 하면 “role-backed skill”이 아니라 “standalone troubleshooting guide”로 격하시킨다
- full-fidelity port라고 주장하지 않는다
- 새 role을 추가할 계획이 없다면, command 문서도 그 한계를 명시한다

## 버킷 G

### 구현 포팅이 먼저 필요한 항목

이 그룹은 문서만 옮겨서는 안 된다. 실제 스크립트가 Claude 전제에 묶여 있다.

- `harness-audit.md`
  - 원문은 `scripts/harness-audit.js`를 source of truth로 강제한다
  - 실제 스크립트는 `.claude/settings.json`, `.claude/hooks.json`, `~/.claude/plugins/ecc/` 같은 Claude 중심 체크를 점수 기준으로 사용한다
  - 따라서 Codex용으로 옮기려면 스크립트 rubric 자체를 Codex-aware하게 포팅해야 한다
- `setup-pm.md`
  - 원문은 `scripts/setup-package-manager.js`를 호출한다
  - 실제 구현은 `CLAUDE_PACKAGE_MANAGER`, `.claude/package-manager.json`, `~/.claude/package-manager.json`을 읽고 쓴다
  - 따라서 문서에서 경로만 바꾸는 것으로는 부족하고, 스크립트와 라이브러리까지 Codex 기준으로 포팅해야 한다

포팅 규칙:

- command 문서 포팅 전에 구현 포팅 범위를 먼저 정의
- 구현 포팅이 끝나기 전까지는 “blocked by implementation” 상태로 둔다

## 버킷 H

### Claude 전용 런타임 전제가 강해 재설계 또는 보류가 필요한 항목

이 그룹은 `.claude` 저장소, hook 시스템, Homunculus, 세션 저장소, wrapper, multi-model 실행기 같은 Claude 전용 기반이 command 의미 자체를 떠받치고 있다. 문서만 옮기기보다 Codex-native 설계를 새로 해야 한다.

#### Hook 시스템 전제

- `hookify.md`
- `hookify-help.md`
- `hookify-list.md`
- `hookify-configure.md`

#### Homunculus / instinct / continuous-learning-v2 전제

- `evolve.md`
- `instinct-export.md`
- `instinct-import.md`
- `instinct-status.md`
- `projects.md`
- `promote.md`
- `prune.md`
- `skill-health.md`

#### Claude 세션 저장소 전제

- `resume-session.md`
- `save-session.md`
- `sessions.md`

#### Claude wrapper / multi-model 실행기 전제

- `multi-backend.md`
- `multi-execute.md`
- `multi-frontend.md`
- `multi-plan.md`
- `multi-workflow.md`

#### command-first 산출물과 long-running control plane 전제

- `gan-build.md`
- `gan-design.md`
- `loop-start.md`
- `orchestrate.md`의 예전 long-form body
- `pm2.md`

처리 방식:

- 포팅 대상이 아니라 재설계 대상이다
- “Codex에서 비슷한 목적을 어떻게 달성할지”를 새로 정의한 뒤 skill을 새로 만든다
- 기존 command 본문을 기계적으로 옮기지 않는다

## 우선순위

### 1순위

작업 대비 성과가 가장 좋다.

- 버킷 B 전체
- 버킷 C 전체
- 버킷 E 전체

### 2순위

문서 재작성만으로 가치가 큰 standalone skill 후보다.

- 버킷 D 전체

### 3순위

역할 표면이나 구현이 먼저 필요하다.

- 버킷 F 전체
- 버킷 G 전체

### 마지막

Codex-native 재설계를 별도 과제로 잡는다.

- 버킷 H 전체

## command 하나를 포팅할 때의 실무 체크리스트

- 원본이 clean shim인지 확인
- target이 `shim`, `standalone skill`, `skill + role orchestration`, `구현 포팅`, `재설계` 중 무엇인지 결정
- role을 쓴다면 실제 role source가 repo-local인지 built-in인지 명시
- `agents/*.md` 파일만 보고 callable role이라고 가정하지 않기
- `.claude/*`, `CLAUDE_PLUGIN_ROOT`, 세션 저장소, hook 설정, wrapper 호출이 있는지 확인
- 구현 의존이 있으면 문서 포팅 전에 스크립트 포팅 여부를 먼저 판정
- 경로와 산출물 위치를 플레이스홀더 또는 Codex 중립 경로로 바꾸기
- slash 사용 예시와 Claude 전용 표현 제거
- user approval step이 workflow 핵심이면 유지, 단순 관성적 예시는 제거
- 포팅 후에는 “이 command가 지금 이 repo의 Codex 표면에서 실제로 실행 가능한지”를 마지막에 다시 검증

## 빠른 후속 작업

- 버킷 C의 dirty shim 3개를 먼저 정리
- 버킷 B를 얇은 Codex shim 또는 skill 안내 문서로 일괄 포팅
- 버킷 E는 role 이름과 orchestration 순서를 명시한 Codex-native skill로 포팅
- 버킷 D는 경로 중립화와 Claude 문맥 제거 중심으로 포팅
- 버킷 F와 G는 “문서 포팅”과 “role 또는 구현 포팅”을 분리해서 추적
- 버킷 H는 포팅 backlog가 아니라 재설계 backlog로 관리
