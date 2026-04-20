---
name: update-docs
description: Codex CLI port for syncing docs from source-of-truth files while preserving manual sections.
---

# Update Docs Skill Port

Codex CLI용 `update-docs` 포트다. 코드와 설정 파일을 source of truth로 삼아 문서를 갱신하는 workflow다.

## Canonical Surface

- 생성 구간과 수동 구간을 구분한다
- 출력 디렉터리는 `<DOCS_DIR>`를 사용한다
- hand-written prose는 보존한다

## Workflow

1. source of truth를 찾는다

- `package.json`, `Makefile`, `Cargo.toml`, `pyproject.toml`
- `.env.example`
- `openapi.yaml` 또는 route file
- `Dockerfile`, compose file

2. script reference를 생성하거나 갱신한다
3. environment variable 문서를 갱신한다
4. contributing guide를 갱신한다
5. runbook을 갱신한다
6. 90일 이상 갱신되지 않은 문서를 찾아 stale 후보로 표시한다

## Typical Output Mapping

- scripts source -> command reference
- `.env.example` -> environment docs
- OpenAPI/route files -> API docs
- infra files -> setup/runbook docs

## Guardrails

- generated section만 갱신한다
- 가능하면 `<!-- AUTO-GENERATED -->` marker를 쓴다
- 사용자가 원하지 않으면 새 top-level 문서를 만들지 않는다

## Output Expectations

- 갱신한 문서
- 새로 발견한 변수나 스크립트
- stale 문서
- 수동 확인이 필요한 부분
