---
description: Codex CLI port for generating token-lean architecture codemaps with neutral output directories.
---

# Update Codemaps Skill Port

Codex CLI용 `update-codemaps` 포트다. 코드베이스 구조를 분석해 AI가 읽기 쉬운 token-lean codemap 문서를 만든다.

## Canonical Surface

- 출력 디렉터리는 `<CODEMAP_DIR>`를 사용한다
- diff 요약은 `<REPORTS_DIR>`에 남길 수 있다
- 문서는 구현 세부사항보다 구조와 흐름을 우선한다
- 기본 codemap 세트는 `architecture.md`, `backend.md`, `frontend.md`, `data.md`, `dependencies.md`다

## Workflow

1. 프로젝트 구조와 entry point를 스캔한다
2. 아래 codemap을 생성하거나 갱신한다

- architecture
- backend
- frontend
- data
- dependencies

3. 이전 codemap이 있으면 diff 비율을 확인한다
4. 변화가 30%를 넘으면 overwrite 전에 사용자 확인을 받는다
5. freshness header와 간단한 scan metadata를 남긴다
6. 요약 리포트를 `<REPORTS_DIR>`에 남긴다

## Writing Rules

- 각 문서는 token-lean하게 유지
- file path, route, function signature 위주
- 긴 코드 블록 대신 구조 요약
- 1000 token 안팎을 목표로 압축

## Output Expectations

- 생성/수정한 codemap 파일
- 큰 구조 변화
- stale warning
- report 위치
