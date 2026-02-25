---
description: 전역 Git 워크플로(커밋 메시지/PR 흐름/TDD/리뷰)
alwaysApply: true
---
# Git Workflow

## Scope / Precedence

- 이 문서는 **전역 Rules 기본값**이다.
- 프로젝트에 이미 Git 규칙(커밋 포맷/브랜치 전략/PR 정책)이 있으면 **그 프로젝트 규칙이 우선**이다.
- Git 저장소가 아니거나 PR/MR을 사용하지 않는 흐름이면, 해당 섹션은 **적용 가능한 범위에서만** 따른다.

## Commit Message Format

```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

Note:
- Keep commit messages small, specific, and aligned with the change intent.
- 프로젝트가 `scope`(예: `feat(auth): ...`)나 다른 템플릿을 요구하면 그 규칙을 따른다.

## Pull Request Workflow

When creating PRs/MRs (해당 시):
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes (base branch는 보통 `main`/`master` 또는 레포 기본 브랜치)
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

## Feature Implementation Workflow

1. **Plan First**
   - Use **planner** subagent to create an implementation plan
   - Identify dependencies and risks
   - Break down into phases

2. **TDD Approach**
   - Use **tdd-guide** subagent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. **Code Review**
   - Use **code-reviewer** subagent immediately after writing code
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
