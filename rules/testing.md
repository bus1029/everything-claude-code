# Testing Requirements

## Minimum Test Coverage: 80%

Test Types:

- **Required**
  1. **Unit Tests** - Individual functions, utilities, components
  2. **Integration Tests** - API endpoints, database operations
- **When appropriate (product/service dependent)**
  - **E2E Tests** - Cover critical user flows (Playwright or equivalent for your stack)

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

1. Use **tdd-guide** subagent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Subagent Support

- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first
- **e2e-runner** - E2E testing specialist (commonly Playwright). Note: currently disabled in `~/.cursor/agents` (file is `.not_used`).

## Python Notes (if applicable)

- Prefer `pytest` for unit/integration tests
- Measure coverage with `coverage.py` / `pytest-cov`
