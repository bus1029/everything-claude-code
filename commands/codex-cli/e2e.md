---
description: Codex CLI skill port for end-to-end testing with Playwright. Prefer direct execution or the existing e2e-testing skill; do not imply an automatic subagent.
---

# E2E Skill Port

Codex CLI용 `e2e` 포트다. 이 문서는 기존 command의 긴 residual example은 버리고, Codex에서 실제로 실행 가능한 E2E workflow와 운영 기대치만 남긴다.

## Canonical Surface

- 기본 표면은 `e2e-testing` skill이다.
- Codex CLI는 이 문서를 읽는다고 해서 subagent를 자동 호출하지 않는다.
- 이 workflow는 기본적으로 현재 세션에서 직접 수행한다.
- 별도 조사나 리뷰가 필요하면 메인 세션이 해당 role을 명시적으로 호출한다.

## When To Use

- 중요한 사용자 플로우에 대한 Playwright 테스트를 새로 만들 때
- 기존 E2E 테스트를 수정하거나 범위를 넓힐 때
- 릴리스 전에 핵심 경로를 다시 검증할 때
- flaky test 원인을 좁히고 artifact를 확인할 때

## Codex CLI Rules

- 자동 위임처럼 쓰지 않는다.
- 브라우저 테스트 범위는 요청된 플로우에만 맞춘다.
- 전체 스위트는 사용자가 명시적으로 요청했을 때만 돌린다.
- 실패 artifact, flaky 징후, 다음 수정 포인트를 함께 남긴다.
- release-critical flow라면 가능하면 다중 브라우저 기대치와 report 산출물을 유지한다.

## Workflow

1. 대상 플로우를 좁힌다.
2. 현재 테스트와 Playwright 설정을 읽어 기존 패턴을 확인한다.
3. 필요한 경우에만 새 spec, fixture, page object를 추가한다.
4. 관련 테스트만 먼저 실행한다.
5. 실패 시 trace, screenshot, video, HTML report를 확인한다.
6. flaky 징후가 있으면 대기 조건, selector, network synchronization을 먼저 점검한다.
7. 요청 범위가 충족되면 결과와 남은 리스크를 요약한다.

## Implementation Guidance

- selector는 가능하면 `data-testid`를 우선한다.
- 임의 timeout보다 locator wait, response wait, URL/state assertion을 우선한다.
- 기존 repo가 Page Object Model을 쓰면 같은 구조를 따른다.
- 새 테스트는 happy path만이 아니라 최소 1개의 실패 또는 empty state를 포함한다.

## Verification

- 우선 대상 spec만 실행한다.
- 필요하면 관련 디렉터리 단위까지 넓힌다.
- 전체 E2E 스위트는 비용이 큰 작업으로 취급한다.
- release 전 검증이면 가능한 범위에서 Chromium, Firefox, WebKit 기대치를 확인한다.
- HTML report, JUnit/JSON reporter, failure trace/video/screenshot 같은 운영 artifact를 유지한다.
- CI에 연결되는 테스트라면 로컬에서 통과만 보지 말고 report 경로와 artifact 생성도 같이 확인한다.

예시 명령:

```bash
npx playwright test tests/e2e/path/to/spec.ts
npx playwright show-report
npx playwright test tests/e2e/path/to/spec.ts --repeat-each=10
```

## Optional Explicit Subagents

Codex CLI에서 subagent는 명시적으로 호출해야 한다. 다만 필요할 때 proactive하게 호출할 수 있으며, 이 문서만으로는 아무 role도 자동 실행되지 않는다.

- 문서나 API 동작을 검증해야 하면 명시적으로 `docs_researcher`를 호출한다.
- 변경된 테스트에 대한 추가 리뷰가 필요하면 명시적으로 `reviewer`를 호출한다.
- 사용할 role 이름은 현재 세션에서 실제로 호출 가능한 Codex 표면과 일치해야 한다.

## Output Expectations

- 추가 또는 수정한 테스트 파일
- 실행한 명령
- pass/fail 결과
- artifact 위치
- flaky risk와 후속 조치
