# Agent Orchestration (Cursor)

## Available Subagents (Global)

Located in `~/.cursor/agents/`:

| Subagent | Purpose | When to Use |
|---------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| database-reviewer | Database review | Query/schema review, performance checks |
| python-reviewer | Python code review | Python changes, PEP 8, security, performance |

## Disabled / Not Used (present but not active)

These exist but are currently disabled (e.g., `.not_used`):

| Subagent | Purpose | Note |
|---------|---------|------|
| security-reviewer | Security analysis | Disabled |
| e2e-runner | E2E testing | Disabled |
| refactor-cleaner | Dead code cleanup | Disabled |

## Removed (not in ~/.cursor/agents)

These were removed from this list because they are not present in `~/.cursor/agents/`:

- build-error-resolver
- doc-updater

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