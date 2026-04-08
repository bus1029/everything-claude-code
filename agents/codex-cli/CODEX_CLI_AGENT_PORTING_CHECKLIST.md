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

## 요약

- 전체 top-level agent 파일: 47개
- 기존 Codex 역할로 흡수 권장: 3개
- custom agent TOML로 이식 용이: 30개
- custom agent TOML로 이식 가능하지만 보정 필요: 11개
- 재설계 필요: 3개

## 기존 Codex 역할로 흡수 권장

- [x] `code-explorer.md` — standalone 초안 생성 완료: [`explorer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/explorer.toml)
- [x] `code-reviewer.md` — standalone 초안 생성 완료: [`reviewer.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/reviewer.toml)
- [x] `docs-lookup.md` — standalone 초안 생성 완료: [`docs-researcher.toml`](/Users/seokhyunbae_1/Desktop/projects_study/everything-claude-code/agents/codex-cli/docs-researcher.toml)

## custom agent TOML로 이식 용이

- [ ] `architect.md` — 시스템 설계 전용 지시문으로 재사용 가능
- [ ] `build-error-resolver.md` — 범용 빌드 복구 worker로 전환 용이
- [ ] `code-architect.md` — 구현 설계 전용 agent로 전환 용이
- [ ] `code-simplifier.md` — 리팩터링 보조 agent로 전환 용이
- [ ] `comment-analyzer.md` — 좁고 명확한 분석 역할
- [ ] `cpp-build-resolver.md` — 언어별 build fixer로 전환 용이
- [ ] `cpp-reviewer.md` — 언어별 reviewer로 전환 용이
- [ ] `csharp-reviewer.md` — 언어별 reviewer로 전환 용이
- [ ] `dart-build-resolver.md` — Dart/Flutter build fixer로 전환 용이
- [ ] `database-reviewer.md` — DB 전용 reviewer/worker로 전환 용이
- [ ] `flutter-reviewer.md` — Flutter reviewer로 전환 용이
- [ ] `go-build-resolver.md` — Go build fixer로 전환 용이
- [ ] `go-reviewer.md` — Go reviewer로 전환 용이
- [ ] `healthcare-reviewer.md` — 도메인 특화 reviewer로 전환 용이
- [ ] `java-build-resolver.md` — Java build fixer로 전환 용이
- [ ] `java-reviewer.md` — Java reviewer로 전환 용이
- [ ] `kotlin-build-resolver.md` — Kotlin build fixer로 전환 용이
- [ ] `kotlin-reviewer.md` — Kotlin reviewer로 전환 용이
- [ ] `planner.md` — `.toml` custom planner agent로 옮기기 쉬움
- [ ] `pr-test-analyzer.md` — PR 테스트 품질 analyzer로 전환 용이
- [ ] `python-reviewer.md` — Python reviewer로 전환 용이
- [ ] `pytorch-build-resolver.md` — PyTorch 전용 build/runtime fixer로 전환 용이
- [ ] `refactor-cleaner.md` — dead code cleanup worker로 전환 용이
- [ ] `rust-build-resolver.md` — Rust build fixer로 전환 용이
- [ ] `rust-reviewer.md` — Rust reviewer로 전환 용이
- [ ] `security-reviewer.md` — 보안 reviewer로 전환 용이
- [ ] `silent-failure-hunter.md` — reviewer 보조 analyzer로 전환 용이
- [ ] `tdd-guide.md` — 테스트 우선 worker/planner로 전환 용이
- [ ] `type-design-analyzer.md` — 타입 설계 analyzer로 전환 용이
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
- [ ] `planner`, `security-reviewer`, `tdd-guide`, `typescript-reviewer`부터 `.codex/agents/*.toml` 초안 생성
- [ ] 보정 필요 11개는 browser/MCP/orchestration 의존부터 분리
- [ ] 재설계 필요 3개는 agent보다 skill 또는 별도 workflow로 옮길지 먼저 결정
