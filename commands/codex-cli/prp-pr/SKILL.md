---
name: prp-pr
description: Codex CLI port for creating a GitHub PR from the current branch with template discovery, push, and verification.
---

# PRP PR Skill Port

Codex CLI용 `prp-pr` 포트다. 현재 브랜치의 변경을 GitHub PR로 올리는 workflow다.

## Canonical Surface

- GitHub CLI `gh`를 사용한다
- PR template이 있으면 우선 적용한다
- base branch 기본값은 `main`이다
- `--draft` 같은 recognized flag를 먼저 분리해 해석한다

## Workflow

1. precondition을 확인한다

- feature branch인지
- working tree가 깨끗한지
- base보다 앞선 commit이 있는지
- 이미 열린 PR이 없는지

2. PR template 경로를 찾는다
3. template이 여러 개인 경우 우선순위나 선택 규칙을 적용한다
4. commit과 changed file을 분석한다
5. 관련 `<PRP_ROOT>/plans`, `<PRP_ROOT>/reports`, `<PRP_ROOT>/prds` 산출물이 있으면 참조한다
6. 브랜치를 push한다
7. divergence가 있으면 fetch/rebase 후 다시 push한다
8. template이 없으면 기본 PR body 구조를 사용한다
9. `gh pr create`로 PR을 만든다
10. `gh pr view`, `gh pr checks`로 결과를 확인한다

## Template Discovery Order

- `.github/PULL_REQUEST_TEMPLATE/`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/pull_request_template.md`
- `docs/pull_request_template.md`

## Default PR Body

- summary
- changes
- files changed
- testing
- related issues

## Edge Cases

- `gh` 미설치
- `gh auth` 미완료
- PR already exists
- rebase conflict
- force push가 필요할 때는 `--force-with-lease`

## Output Expectations

- PR 번호와 URL
- head -> base
- 변경 규모
- CI 상태
- 참조한 산출물
