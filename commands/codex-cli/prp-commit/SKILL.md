---
name: prp-commit
description: Codex CLI port for natural-language staging and commit creation in a PRP-style workflow.
---

# PRP Commit Skill Port

Codex CLI용 `prp-commit` 포트다. 자연어로 커밋 범위를 정하고, 그 범위만 stage해서 커밋하는 workflow다.

## Canonical Surface

- 기본 범위는 현재 working tree다
- 입력 설명에 맞는 파일만 stage한다
- 커밋 메시지는 conventional commit 형식을 따른다

## Workflow

1. `git status --short`로 변경 사항을 본다
2. 입력 설명을 아래 규칙으로 해석해 stage 범위를 정한다

예시:

- blank: 전체 stage
- `staged`: 이미 staged된 것만 사용
- glob: 해당 패턴만 stage
- `except tests`: 테스트를 제외하고 stage
- 자연어 범위: 상태와 diff를 읽고 관련 파일만 선택
- `only new files`: untracked만 stage

3. 아무 것도 바뀌지 않았으면 중단한다
4. 매칭되는 파일이 없으면 중단한다
5. `git diff --cached --stat`으로 staging 결과를 검증한다
6. conventional commit 메시지를 만든다
7. `git commit -m`으로 커밋한다

## Interpretation Rules

- 빈 입력: `git add -A`
- `staged`: 추가 stage 없이 현재 staged만 사용
- glob: 해당 패턴만 stage
- `except tests`: 전체 stage 후 테스트 패턴 unstage
- 자연어: status와 diff를 보고 관련 파일만 선택
- `only new files`: untracked만 stage

## Commit Message Rules

- `feat`
- `fix`
- `refactor`
- `docs`
- `test`
- `chore`
- `perf`
- `ci`
- imperative mood
- 72자 안팎
- 마침표 없음

## Output Expectations

- 커밋 SHA
- 커밋 메시지
- 포함 파일 수
- 다음 단계 제안
