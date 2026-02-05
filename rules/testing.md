# Testing Requirements

## Scope / Precedence

- 이 문서는 **전역 Rules 기본값**이다.
- 프로젝트에 별도 테스트 정책(테스트 러너, 커버리지 기준/측정 방식, 필수 테스트 레벨, CI 게이트)이 있으면 **그 프로젝트 규칙이 우선**이다.

## Minimum Test Coverage: 80%

Test Types:

- **Required**
  1. **Unit Tests** - Individual functions, utilities, components
  2. **Integration Tests** - API endpoints, database operations
- **When appropriate (product/service dependent)**
  - **E2E Tests** - Cover critical user flows (Playwright or equivalent for your stack)

Note:
- “80%”는 기본 목표다. 프로젝트가 더 높은/낮은 기준을 요구하면 그 기준을 따른다.
- 커버리지 측정 도구/명령은 스택에 맞는 것을 사용한다(예: `pytest-cov`, `nyc`, `go test -cover` 등).

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+) (해당 시/측정 가능할 때)

## Troubleshooting Test Failures

1. Use **tdd-guide** subagent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Subagent Support

- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first
- **e2e-runner** - E2E testing specialist (commonly Playwright). Note: 환경에 따라 비활성(`.not_used`)일 수 있으니 **존재/활성 여부 확인 후** 사용.

## Python Notes (if applicable)

- Prefer `pytest` for unit/integration tests
- Measure coverage with `coverage.py` / `pytest-cov`
