---
name: tdd
description: Codex CLI skill port for strict TDD. Use the existing tdd-workflow skill and call tdd-guide only when explicitly requested.
---

# TDD Skill Port

Codex CLI용 `tdd` 포트다. 핵심은 `RED -> GREEN -> REFACTOR`를 유지하되, Codex에서는 subagent 호출이 자동이 아니라는 점을 문서에 명확히 남기는 것이다.

## Canonical Surface

- 기본 표면은 `tdd-workflow` skill이다.
- `tdd-guide`는 필요할 때 사용할 수 있지만, Codex CLI에서는 메인 세션이 명시적으로 서브에이전트로 호출해야 한다.
- 이 문서는 기존 장문 예시를 복제하지 않고, 실제 운영 규칙만 남긴다.

## When To Use

- 새 기능을 구현할 때
- 버그 재현 테스트를 먼저 만들고 수정할 때
- 리팩터링 중 회귀를 막아야 할 때
- edge case와 failure path를 먼저 고정하고 싶을 때

## Codex CLI Subagent Rule

- 테스트 전략이 불명확하거나 테스트 케이스 분해가 먼저 필요하다고 판단되면 메인 세션이 명시적으로 서브에이전트 `tdd-guide`를 호출하여 테스트 케이스, edge case, failure path를 먼저 정리한다.
- `tdd-guide`는 자동 체인처럼 호출하지 말고, 실제로 필요하다고 판단되는 시점에만 메인 세션이 명시적으로 호출 단계를 넣어야 한다.
- subagent 없이도 현재 세션에서 TDD를 수행할 수 있다.

## Workflow

1. 요구사항, 성공 기준, 사용자 여정을 짧게 고정한다.
2. 각 사용자 여정에 대해 테스트 케이스와 edge case를 먼저 쪼갠다.
3. 영향을 받는 함수, 모듈, 경로를 찾는다.
4. 먼저 failing test를 추가한다.
5. 해당 테스트를 실제로 실행해 RED를 확인한다.
6. 최소 수정으로 GREEN을 만든다.
7. 같은 타깃을 다시 실행해 GREEN을 확인한다.
8. 필요할 때만 리팩터링하고 다시 검증한다.
9. coverage 도구가 있으면 관련 범위를 확인한다.

## RED Gate

아래 중 하나가 확인돼야 RED로 인정한다.

- 새 테스트가 실행됐고 의도한 이유로 실패했다.
- 컴파일 실패 자체가 의도한 미구현 또는 타입 불일치를 드러냈다.

다음은 RED로 인정하지 않는다.

- 테스트를 쓰기만 하고 실행하지 않은 상태
- 깨진 setup, 누락된 의존성, unrelated syntax error만 있는 상태

## GREEN Gate

- 방금 추가한 재현 테스트가 통과해야 한다.
- 가능하면 관련 주변 테스트도 같이 통과해야 한다.
- fix를 넣은 뒤에는 같은 타깃을 다시 실행해 회귀가 없는지 확인한다.

## Checkpoint Discipline

- RED와 GREEN은 반드시 실행 증거를 남긴다.
- 사용자가 checkpoint commit을 원하거나 repo workflow가 이를 요구하면 RED 뒤 1개, GREEN 뒤 1개, 필요 시 refactor 뒤 1개의 작은 checkpoint commit을 남긴다.
- checkpoint commit을 만들지 않는 경우에도 같은 수준의 증거를 세션 결과에 남긴다.

## Optional Explicit Subagents

Codex CLI에서 subagent는 명시적으로 호출해야 한다.

- TDD 설계와 테스트 분해를 분리하고 싶으면 명시적으로 서브에이전트 `tdd-guide`를 호출한다.
- 구현 후 위험 검토가 필요하면 먼저 범용 리스크 검토용 `reviewer`를 호출하고, 그다음 대상 언어와 도메인에 맞는 reviewer를 추가로 호출한다.
- 기본 범용 리뷰는 통합된 `reviewer`가 담당한다.
- 언어별 reviewer는 범용 리뷰를 대체하지 않고 language-specific 리스크를 한 번 더 확인하는 용도로 사용한다.
- Python 변경이면 `reviewer` 다음에 `python-reviewer`를 추가로 사용한다.
- Java 변경이면 `reviewer` 다음에 `java-reviewer`를 추가로 사용한다.
- Go 변경이면 `reviewer` 다음에 `go-reviewer`를 추가로 사용한다.
- 데이터베이스 스키마나 쿼리 영향이 크면 `database-reviewer`를 추가로 사용한다.
- 의료/PHI 민감 경로면 `healthcare-reviewer`를 추가로 사용한다.
- 인증, 입력 검증, trust boundary, secret handling 등 보안 민감 변경이면 `security-reviewer`를 추가로 사용한다.
- 사용할 role 이름은 현재 세션에서 실제로 호출 가능한 Codex 표면과 일치해야 한다.
- 모든 서브에이전트가 완료될 때까지 기다린 후, 발견된 모든 Findings들을 종합하여 효율적으로 해결한다.

예시:

```text
먼저 필요하다고 판단되면 tdd-guide subagent를 명시적으로 호출해
테스트 케이스를 분해한 뒤, 메인 세션에서 RED -> GREEN ->
REFACTOR를 진행한다.

구현 후에는 먼저 reviewer를 호출해 범용 리스크를 확인한다.
그다음 Python 코드면 python-reviewer를, Java 코드면
java-reviewer를, Go 코드면 go-reviewer를 명시적으로 호출해
언어별 리스크를 한 번 더 검토한다.
```

## Output Expectations

- 추가한 failing test
- 사용자 여정 또는 테스트 분해 요약
- RED 확인 명령과 결과
- GREEN 확인 명령과 결과
- checkpoint evidence 또는 checkpoint commit 여부
- 리팩터링 여부
- coverage 또는 남은 테스트 갭
