# Performance Optimization

## Model Selection Strategy

OpenAI 최신 모델(공식 Models 문서 기준: Latest **gpt-5.2**)을 역할별로 사용:

- **Fast / low-cost model**:
  - 권장: **gpt-5.2** (속도/품질 균형)
  - 용도: 고빈도 subagent(탐색/요약/단순 변경), 로그/출력 많은 작업의 요약, 문서/리팩터링 보조
- **Balanced coding model**:
  - 권장: **gpt-5.2-codex-high** (범용 코딩/에이전틱 작업), 코딩 최적화가 필요하면 **gpt-5.2-codex-xhigh**
  - 용도: 대부분의 구현 작업, 멀티 파일 변경, 일반적인 디버깅/리팩터링, subagent 오케스트레이션
- **Deep reasoning / precision model**:
  - 권장: **gpt-5.2-xhigh**
  - 용도: 아키텍처 결정, 복잡한 상호작용 디버깅, 인증/보안/마이그레이션처럼 실수 비용이 큰 변경

## Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## Plan Mode

For complex tasks requiring deep reasoning:
1. Enable **Plan Mode** for structured approach
2. Do 1-2 explicit critique passes before committing to an approach
3. Use split-role subagents for diverse analysis (e.g., reviewer vs implementer)
4. Use built-in subagents when appropriate:
   - **Explore**: codebase search/exploration (keeps main context clean)
   - **Bash**: command execution/log-heavy output
   - **Browser**: DOM/screenshot-heavy output isolation

## Build Troubleshooting

If build fails:
1. Use the built-in **Bash** subagent (or terminal tool) to run the build/test commands and capture full logs
2. Analyze error messages and isolate the first failing root cause
3. Fix incrementally (one change at a time)
4. Re-run the smallest relevant verification after each fix
