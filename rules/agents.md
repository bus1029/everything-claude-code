# Subagent Orchestration (Cursor)

## 범위/우선순위(중요)

Cursor에서 subagent는 다음 두 위치에 존재할 수 있다.

- 프로젝트 전용: `<repo>/.cursor/agents/` (있으면 **우선**)
- 전역(개인): `~/.cursor/agents/`

아래 목록은 “현재 전역 환경에서 흔히 쓰는 subagent” **예시**다. 실제 사용 시에는 **해당 subagent가 존재하는지**를 먼저 확인하고, 없으면 가능한 범위에서 일반 지침으로 대체한다.

## Available Subagents (Global, 예시)

Located in `~/.cursor/agents/`:

| Subagent | Purpose | When to Use |
|---------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing or modifying code |
| database-reviewer | Database review | Query/schema review, performance checks |
| python-reviewer | Python code review | Python changes, PEP 8, security, performance |

## Optional / Disabled (해당 시)

아래 subagent들은 환경에 따라 없거나 `.not_used`로 비활성일 수 있다. **활성화되어 있고 작업에 필요할 때만** 사용한다.

| Subagent | Purpose | Note |
|---------|---------|------|
| security-reviewer | Security analysis | Often disabled |
| e2e-runner | E2E testing | Often disabled |
| refactor-cleaner | Dead code cleanup | Often disabled |

## Immediate Subagent Usage

No user prompt needed:
1. Complex feature requests -> Use **planner**
2. Code just written/modified -> Use **code-reviewer**
3. Bug fix or new feature -> Use **tdd-guide**
4. Architectural decision -> Use **architect**
5. Database-related changes -> Use **database-reviewer**
6. Python changes -> Use **python-reviewer**

## Parallel Task Execution

Always use parallel subagents for independent operations:
- Good: Run security analysis, performance review, and type checks in parallel
- Bad: Run them sequentially when unnecessary

## Multi-Perspective Analysis

For complex problems, use split role subagents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker