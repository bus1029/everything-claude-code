---
description: Codex CLI port for Jira ticket retrieval, analysis, commenting, transition, and search through Jira MCP or REST.
---

# Jira Skill Port

Codex CLI용 `jira` 포트다. Jira 이슈를 가져오고, 요구사항을 정리하고, 코멘트와 상태 전환을 수행하는 workflow다.

## Canonical Surface

- Jira MCP가 있으면 그것을 우선 사용한다
- 없으면 REST API와 환경 변수 기반 인증을 쓴다
- 이 문서는 standalone integration workflow다

## Supported Intents

- `get <TICKET>`
- `comment <TICKET>`
- `transition <TICKET>`
- `search <JQL>`

## Get

1. 티켓 메타데이터를 가져온다
2. 설명, acceptance criteria, linked issue, priority를 읽는다
3. 아래 형태로 구조화한다

- requirements
- acceptance criteria
- test scenarios
- dependencies
- recommended next step

## Comment

- 현재 작업 진행 상황을 요약한다
- 무엇을 했는지, 무엇이 남았는지, 검증 결과가 무엇인지 남긴다

## Transition

- 가능한 전이 목록을 조회한다
- 선택 가능한 상태를 보여주고 실행한다

## Search

- JQL 결과를 요약 테이블이나 목록으로 정리한다

## Prerequisites

- Jira MCP 설정 또는 REST 인증 정보 필요
- 예시 환경 변수

```bash
export JIRA_URL="https://yourorg.atlassian.net"
export JIRA_EMAIL="you@example.com"
export JIRA_API_TOKEN="token"
```

## Output Expectations

- 티켓 키
- 핵심 요구사항
- acceptance criteria
- 다음 작업 제안
