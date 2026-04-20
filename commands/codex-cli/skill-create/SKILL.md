---
name: skill-create
description: Codex CLI port for generating reusable Codex skill docs from repository patterns and local git history.
---

# Skill Create Skill Port

Codex CLI용 `skill-create` 포트다. 로컬 git history와 repo 구조를 읽어 재사용 가능한 Codex skill 문서를 만드는 workflow다.

## Canonical Surface

- 출력 대상은 Codex skill 문서다
- 저장 위치는 `<SKILLS_DIR>` 같은 중립 경로를 쓴다
- recognized input으로 `--commits`, `--output`, `--instincts` 같은 legacy 옵션을 받을 수 있다
- `--instincts`는 repo가 아직 해당 호환 surface를 유지할 때만 optional compatibility output으로 취급한다

## Workflow

1. 최근 commit과 파일 변경 패턴을 읽는다
2. 반복되는 workflow와 conventions를 찾는다
3. 아래 관점으로 패턴을 묶는다

- commit conventions
- file co-changes
- architecture conventions
- testing patterns
- recurring workflows

4. 필요하면 commit 수와 출력 경로 옵션을 반영한다
5. 재사용 가치가 높은 패턴만 골라 skill 초안을 만든다
6. `SKILL.md` 형식으로 정리한다

## Inputs

- `--commits <n>`: 분석할 commit 수
- `--output <dir>`: 출력 디렉터리
- `--instincts`: optional compatibility output

## Git Analysis Signals

- commit message patterns
- 자주 같이 바뀌는 파일
- 테스트 위치와 naming
- 반복되는 작업 순서

## Output Expectations

- skill 이름
- 짧은 description
- 언제 써야 하는지
- 핵심 workflow
- 필요한 reference나 script가 있으면 그 위치

## Guardrails

- 단순 repo 소개를 skill로 만들지 않는다
- 한 skill에 너무 많은 unrelated pattern을 넣지 않는다
- Codex가 이미 아는 일반론보다 repo 특화 패턴을 우선한다
