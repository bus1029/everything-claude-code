# Codex CLI Agent 이식 체크리스트

`agents/*.md` 상위 47개 파일을 현재 Codex CLI의 subagent/custom agent 방식에 맞춰 1차 분류한 결과다.

- 분류 대상: `agents/` 바로 아래 `.md` 파일만 포함
- 참고 자료
  - [Codex Subagents 공식 문서](https://developers.openai.com/codex/subagents)
  - [openai/codex `docs/config.md`](https://github.com/openai/codex/blob/main/docs/config.md)
  - [`.codex/config.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/.codex/config.toml)
  - [`.codex/agents/explorer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/.codex/agents/explorer.toml)
  - [`.codex/agents/reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/.codex/agents/reviewer.toml)
  - [`.codex/agents/docs-researcher.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/.codex/agents/docs-researcher.toml)

## 현재 Codex CLI 멀티에이전트 방식

- Codex는 현재 subagent workflow를 기본 활성화 상태로 제공
- Codex는 subagent를 자동으로 상시 띄우지 않고, 사용자가 명시적으로 요청할 때만 spawn
- CLI에서 `/agent`로 활성 agent thread를 확인하고 전환 가능
- built-in agent는 `default`, `worker`, `explorer`
- custom agent는 `~/.codex/agents/` 또는 `.codex/agents/` 아래의 standalone TOML 파일로 정의
- custom agent 필수 필드는 `name`, `description`, `developer_instructions`
- 선택 필드로 `model`, `model_reasoning_effort`, `sandbox_mode`, `mcp_servers`, `skills.config`, `nickname_candidates` 사용 가능
- 글로벌 제어는 `.codex/config.toml`의 `[agents]` 아래에서 `max_threads`, `max_depth` 등으로 설정

## 이 체크리스트에서의 해석 기준

- `기존 Codex 역할로 흡수 권장`
  - 이미 공식 예시나 현재 `.codex/agents/*.toml` 역할과 거의 1:1 대응
  - 새 agent를 늘리기보다 기존 Codex role로 대체하는 편이 자연스러움
- `custom agent TOML로 이식 용이`
  - 본문 instruction은 재사용 가능
  - `.md` frontmatter를 `.toml`로 옮기고 Codex 문맥만 정리하면 됨
- `custom agent TOML로 이식 가능하지만 보정 필요`
  - instruction 본문은 살릴 수 있지만 브라우저/MCP/오케스트레이션/스크립트 전제가 강함
  - Codex용 도구 표면과 운영 방식에 맞게 보정 필요
- `재설계 필요`
  - Claude Code hook, `CLAUDE.md`, 외부 메시징 파이프라인, 강한 `.claude` 전제 등으로 인해 agent 개념 자체를 다시 설계해야 함

## 공통 포팅 메모

- [ ] 모든 `agents/*.md`는 현재 Codex custom agent 형식과 다르므로 그대로는 사용 불가
- [ ] 기존 frontmatter의 `tools:` 목록은 현재 Codex custom agent 스키마에 그대로 옮기지 말 것
- [ ] `Use PROACTIVELY` 계열 문구는 Codex의 “명시적 spawn” 모델에 맞게 재서술할 것
- [ ] 우선 `.codex/agents/*.toml`로 옮기고, 필요한 경우에만 `.codex/config.toml`의 `[agents.<name>]` 등록을 추가할 것
- [ ] 이미 있는 `explorer`, `reviewer`, `docs_researcher`와 역할이 겹치는 agent는 신규 생성보다 통합을 우선할 것
- [x] standalone custom agent 기준으로는 `name`, `description`, `developer_instructions`를 모두 포함한 TOML을 별도 산출물로 만든다
- [x] 현재 생성된 standalone 초안은 재검토 결과 스키마상 유효하며, 보강 대상도 material fidelity 기준 통과
- [ ] portability 메모: `docs_researcher`는 `context7` MCP가 실제 환경에 있어야 하고, 일부 agent는 `workspace-write`라 전역 설치 시 권한 범위를 주의할 것

## 다음 작업자를 위한 실전 메모

이 문서만 읽고 이어서 작업할 때 반드시 지켜야 할 포인트를 아래에 정리한다.

### 1. standalone custom agent 기준으로 작업할 것

- 이번 포팅의 기준은 `.codex/agents/*.toml` overlay가 아니라 `~/.codex/agents/`에 바로 복사 가능한 standalone TOML이다
- 따라서 최소 필드 `name`, `description`, `developer_instructions`를 항상 포함해야 한다
- 기존 repo의 `.codex/agents/*.toml` 예시는 overlay 성격이 강하므로 그대로 복사하지 말고 standalone 형식으로 다시 써야 한다

### 2. frontmatter는 참고만 하고, 본문 instruction을 중심으로 옮길 것

- `name`, `description`, `model`은 frontmatter에서 가져오면 된다
- 하지만 실제 포팅 품질은 본문 instruction을 얼마나 보존했는지로 결정된다
- 특히 아래는 요약하다가 자주 빠지므로 반드시 복원해야 한다
  - 고정된 workflow 단계
  - 하지 말아야 할 제약
  - severity / approval 기준
  - 체크리스트
  - output 형식
  - tool 사용 횟수 제한
  - 언제 이 agent를 써야 하는지에 대한 trigger 조건

### 3. `Use PROACTIVELY`는 그대로 옮기지 말 것

- Codex는 명시적 spawn 모델이므로 `Use PROACTIVELY`, `Automatically activated` 같은 문구를 그대로 두면 어색하다
- 대신 description이나 instructions에서 `when to use`, `responsibilities`, `workflow`로 재서술해야 한다

### 4. `tools:` 목록은 버리고 도구 의존만 의미 수준으로 복원할 것

- 현재 Codex custom agent TOML에는 Claude-style `tools:` 필드를 그대로 쓰지 않는다
- 대신 instruction 안에서 “어떤 종류의 도구/정보원이 필요했는지”만 복원한다
- 예:
  - `docs-lookup.md` → Context7 의존을 `mcp_servers = ["context7"]`와 instruction에 명시
  - `WebSearch` / `WebFetch` → Codex의 현재 웹 또는 MCP 표면 기준으로 다시 기술
  - Agent Browser 전제 → Playwright MCP 또는 Codex 브라우저 기준으로 재정의

### 5. fidelity를 떨어뜨리는 대표적인 압축 실수

초안만 빠르게 만들면 아래 정보가 빠지기 쉽다. 실제로 재검토에서 문제로 잡혔다.

- `docs_researcher`
  - tool name 차이 대응
  - Context7 의존 명시
  - resolve/query 최대 3회 제한
- `tdd-guide`
  - `80%+` coverage 기준
  - eval-driven addendum
- `database-reviewer`
  - PostgreSQL-specific rules: FK 인덱싱, partial/covering index, `SKIP LOCKED`, cursor pagination, 짧은 트랜잭션
- `healthcare-reviewer`
  - CDSS / PHI / clinical workflow / data integrity 체크리스트
- `security-reviewer`
  - false positive 가이드
  - emergency response
  - 언제 실행해야 하는지
- `refactor-cleaner`
  - `SAFE/CAREFUL/RISKY`
  - batch 단위 제거
  - batch 후 검증 / 커밋 규칙
- `reviewer`
  - React/Next.js / backend-specific checks
  - `Approve / Warning / Block`
  - 고정 summary shape

### 6. 이름과 통합 지점을 맞출 것

- standalone name은 가능한 한 repo의 role key와 충돌 없이 일관되게 맞춘다
- 실제 사례:
  - 초기에 `docs-researcher`로 썼다가 repo config의 `docs_researcher`와 drift가 생겨 `docs_researcher`로 수정했다
- built-in을 override할 의도가 없다면 built-in 이름을 그대로 쓰는지 신중하게 판단할 것
  - `explorer.toml`은 의도적으로 built-in `explorer`를 덮는 케이스다

### 7. MCP / 환경 의존은 TOML만으로 해결되지 않는다

- standalone 파일에 `mcp_servers = [...]`를 적어도, 대상 환경에 그 MCP 서버가 실제로 설치되어 있어야 한다
- 현재 portability 관점에서 가장 중요한 예외는 `docs_researcher`의 `context7` 의존이다
- 따라서 “복사 가능”과 “즉시 동작 가능”은 다르다

### 8. `sandbox_mode`는 보수적으로 잡을 것

- read-only 분석/리뷰 계열은 가능하면 `read-only`
- 실제 수정/정리/보안 remediation/TDD 수행 계열만 `workspace-write`
- 다만 `workspace-write` agent를 전역 `~/.codex/agents`에 두면 권한이 강해지므로 portability 메모를 남겨야 한다

### 9. 추천 포팅 순서

새 agent를 포팅할 때는 아래 순서를 따르는 것이 안전했다.

1. 원본 `.md`에서 frontmatter와 본문을 모두 읽는다
2. standalone TOML 초안을 만든다
3. instruction을 “축약본”으로 끝내지 말고 체크리스트/제약/출력 형식을 복원한다
4. 원본 `.md`와 나란히 비교하며 fidelity gap을 찾는다
5. 필요하면 서브에이전트 2개로 재검토한다
   - 하나는 semantic fidelity 검토
   - 하나는 Codex schema / portability 검토
6. 체크리스트 문서에 산출물과 재검토 결과를 바로 반영한다

### 10. 검토할 때 물어야 하는 질문

포팅이 끝났다고 보기 전에 최소한 아래를 확인할 것.

- 이 TOML이 standalone custom agent 스키마에 맞는가
- 원본 `.md`의 핵심 workflow와 금지사항을 잃지 않았는가
- role identity만 남고 운영 규칙이 빠진 축약본이 되지 않았는가
- MCP / 브라우저 / 외부 도구 의존을 숨기지 않았는가
- 이름, 권한, 모델 고정 여부가 전역 설치 시 문제를 만들지 않는가

## 요약

- 전체 top-level agent 파일: 47개
- 현재 `agents/codex-cli/*.toml` 기준 standalone 포팅 완료: 21개
- 현재 미포팅: 26개
- 현재 완료율: 44.7%
- 기존 Codex 역할로 흡수 권장: 3개
- custom agent TOML로 이식 용이: 30개
- custom agent TOML로 이식 가능하지만 보정 필요: 11개
- 재설계 필요: 3개

## 현재 포팅 진행률

- 완료 표시는 `agents/codex-cli` 아래에 standalone TOML 산출물이 실제 존재할 때만 부여
- 기존 Codex 역할로 흡수 권장: 3/3 완료
- custom agent TOML로 이식 용이: 18/30 완료
- custom agent TOML로 이식 가능하지만 보정 필요: 0/11 완료
- 재설계 필요: 0/3 완료

## 기존 Codex 역할로 흡수 권장

- [x] `code-explorer.md` — standalone 초안 생성 완료: [`explorer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/explorer.toml)
- [x] `code-reviewer.md` — standalone 초안 생성 완료: [`reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/reviewer.toml)
- [x] `docs-lookup.md` — standalone 초안 생성 완료: [`docs-researcher.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/docs-researcher.toml)

## custom agent TOML로 이식 용이

- [x] `architect.md` — standalone 초안 생성 완료: [`architect.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/architect.toml)
- [ ] `build-error-resolver.md` — 범용 빌드 복구 worker로 전환 용이
- [x] `code-architect.md` — standalone 초안 생성 완료: [`code-architect.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/code-architect.toml)
- [x] `code-simplifier.md` — standalone 초안 생성 완료: [`code-simplifier.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/code-simplifier.toml)
- [x] `comment-analyzer.md` — standalone 초안 생성 완료: [`comment-analyzer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/comment-analyzer.toml)
- [ ] `cpp-build-resolver.md` — 언어별 build fixer로 전환 용이
- [ ] `cpp-reviewer.md` — 언어별 reviewer로 전환 용이
- [ ] `csharp-reviewer.md` — 언어별 reviewer로 전환 용이
- [ ] `dart-build-resolver.md` — Dart/Flutter build fixer로 전환 용이
- [x] `database-reviewer.md` — standalone 초안 생성 완료: [`database-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/database-reviewer.toml)
- [ ] `flutter-reviewer.md` — Flutter reviewer로 전환 용이
- [x] `go-build-resolver.md` — standalone 초안 생성 완료: [`go-build-resolver.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/go-build-resolver.toml)
- [x] `go-reviewer.md` — standalone 초안 생성 완료: [`go-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/go-reviewer.toml)
- [x] `healthcare-reviewer.md` — standalone 초안 생성 완료: [`healthcare-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/healthcare-reviewer.toml)
- [x] `java-build-resolver.md` — standalone 초안 생성 완료: [`java-build-resolver.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/java-build-resolver.toml)
- [x] `java-reviewer.md` — standalone 초안 생성 완료: [`java-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/java-reviewer.toml)
- [ ] `kotlin-build-resolver.md` — Kotlin build fixer로 전환 용이
- [ ] `kotlin-reviewer.md` — Kotlin reviewer로 전환 용이
- [x] `planner.md` — standalone 초안 생성 완료: [`planner.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/planner.toml)
- [x] `pr-test-analyzer.md` — standalone 초안 생성 완료: [`pr-test-analyzer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/pr-test-analyzer.toml)
- [x] `python-reviewer.md` — standalone 초안 생성 완료: [`python-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/python-reviewer.toml)
- [ ] `pytorch-build-resolver.md` — PyTorch 전용 build/runtime fixer로 전환 용이
- [x] `refactor-cleaner.md` — standalone 초안 생성 완료: [`refactor-cleaner.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/refactor-cleaner.toml)
- [ ] `rust-build-resolver.md` — Rust build fixer로 전환 용이
- [ ] `rust-reviewer.md` — Rust reviewer로 전환 용이
- [x] `security-reviewer.md` — standalone 초안 생성 완료: [`security-reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/security-reviewer.toml)
- [x] `silent-failure-hunter.md` — standalone 초안 생성 완료: [`silent-failure-hunter.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/silent-failure-hunter.toml)
- [x] `tdd-guide.md` — standalone 초안 생성 완료: [`tdd-guide.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/tdd-guide.toml)
- [x] `type-design-analyzer.md` — standalone 초안 생성 완료: [`type-design-analyzer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/type-design-analyzer.toml)
- [ ] `typescript-reviewer.md` — TS/JS reviewer로 전환 용이

## custom agent TOML로 이식 가능하지만 보정 필요

- [ ] `doc-updater.md` — `/update-codemaps`, `/update-docs`, `docs/CODEMAPS/*` 전제를 Codex workflow로 치환 필요
- [ ] `e2e-runner.md` — Agent Browser 우선 전략을 Codex 브라우저 MCP 또는 Playwright MCP 기준으로 재정의 필요
- [ ] `gan-evaluator.md` — Playwright evidence 수집과 평가 루프를 Codex spawn 흐름으로 보정 필요
- [ ] `gan-generator.md` — generator loop의 parent-worker 계약을 Codex subagent orchestration에 맞게 재작성 필요
- [ ] `gan-planner.md` — planner-generator-evaluator 3자 루프를 Codex용으로 보정 필요
- [ ] `harness-optimizer.md` — `/harness-audit` 전제와 cross-harness 설명을 Codex 중심으로 정리 필요
- [ ] `loop-operator.md` — loop 상태, checkpoint, branch/worktree 운영 규칙을 Codex 실행 모델에 맞게 구체화 필요
- [ ] `opensource-forker.md` — `.claude/` 제외 규칙과 대규모 shell workflow를 Codex식 안전 규칙으로 조정 필요
- [ ] `opensource-sanitizer.md` — `.claude/settings.json` 등 Claude 흔적 패턴을 Codex 기준으로 재조정 필요
- [ ] `performance-optimizer.md` — 프로파일링·측정 루프와 실행 책임 범위를 Codex worker 기준으로 좁혀야 함
- [ ] `seo-specialist.md` — `WebSearch`, `WebFetch` 같은 옛 tool 표기를 Codex 현재 웹/MCP 표면에 맞게 치환 필요

## 재설계 필요

- [ ] `chief-of-staff.md` — 외부 채널 CLI, 캘린더 계산, PostToolUse hook, `.claude/rules/*` 전제가 강함
- [ ] `conversation-analyzer.md` — `/hookify`와 hook rule 생성을 전제로 하므로 Codex custom agent보다 별도 workflow 재설계가 적합
- [ ] `opensource-packager.md` — `CLAUDE.md` 생성과 Claude Code 최적화가 핵심이라 Codex용 결과물 정의를 다시 잡아야 함

## 빠른 후속 작업

- [x] `code-explorer`, `code-reviewer`, `docs-lookup`는 standalone custom agent 기준 TOML 초안을 [`agents/codex-cli/`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli) 아래 생성
- [x] 언어 비종속 `이식 용이` agent의 standalone custom agent 초안을 [`agents/codex-cli/`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli) 아래 생성
- [x] fidelity 재검토 결과 `docs_researcher`, `tdd-guide`, `database-reviewer`, `healthcare-reviewer`, `security-reviewer`, `refactor-cleaner`, `reviewer`는 보강 후 material fidelity 기준 통과
- [ ] 남은 언어별 reviewer/build-resolver 계열(`cpp`, `csharp`, `dart`, `flutter`, `kotlin`, `pytorch`, `rust`, `typescript`)과 경계 사례(`build-error-resolver`)를 별도로 검토
- [ ] `~/.codex/agents` 복사 전 대상 환경의 MCP(`context7`)와 권한 정책을 점검
- [ ] 보정 필요 11개는 browser/MCP/orchestration 의존부터 분리
- [ ] 재설계 필요 3개는 agent보다 skill 또는 별도 workflow로 옮길지 먼저 결정
