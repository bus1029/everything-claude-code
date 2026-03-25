# `/harness-audit` — 저장소의 harness 품질을 “결정론적 점수표”로 감사하는 커맨드

`/harness-audit`는 저장소의 hooks, skills, commands, agents 구성을 **정해진 스크립트 기준으로 감사(audit)**하고, 결과를 **재현 가능한 점수표**로 정리해 주는 슬래시 커맨드입니다.  
핵심은 임의 평가가 아니라, **`scripts/harness-audit.js` 출력값을 그대로 소스로 삼아 우선순위 액션까지 도출**하는 데 있습니다.

# 한눈에 보기(요약)

### 역할

- 지정한 범위(`repo`, `hooks`, `skills`, `commands`, `agents`)를 감사
- `node scripts/harness-audit.js ...`를 실행해 점수 계산
- 카테고리별 점수와 실패 체크를 정리
- `top_actions`를 기반으로 다음 액션 우선순위 제시

### 언제 쓰나

- 저장소 harness 구성이 얼마나 잘 갖춰져 있는지 빠르게 점검하고 싶을 때
- hooks/skills/commands/agents 중 특정 영역만 진단하고 싶을 때
- 리팩터링이나 정리 작업 전에 현재 상태를 점수표로 파악하고 싶을 때
- 팀에 “어디를 먼저 손봐야 하는지” 근거 있는 목록이 필요할 때

### 출력(결과물)

- 전체 점수(`overall_score / max_score`)
- 카테고리별 점수
- 실패 체크 목록과 정확한 파일 경로
- `top_actions` 기준 상위 3개 개선 과제
- 후속으로 적용할 만한 스킬 또는 커맨드 제안

# 어떻게 쓰나(1분 사용법)

1. `/harness-audit`만 실행하면 저장소 전체(`repo`)를 감사합니다.
2. 범위를 좁히려면 `hooks`, `skills`, `commands`, `agents` 중 하나를 붙입니다.
3. 자동화용 결과가 필요하면 `--format json`을 사용합니다.

사용 형식:

`/harness-audit [scope] [--format text|json]`

# 이 커맨드가 하는 일(진행 흐름)

### 1) 감사 범위 결정

- 기본값은 `repo`
- 부분 감사가 필요하면 `hooks`, `skills`, `commands`, `agents` 중 하나를 사용합니다

### 2) 결정론적 스크립트 실행

아래 스크립트를 항상 기준으로 사용합니다.

```bash
node scripts/harness-audit.js <scope> --format <text|json>
```

- 점수 계산 로직은 이 스크립트가 전부 담당합니다
- 에이전트가 임의로 새 평가 기준을 추가하면 안 됩니다

### 3) 결과 해석

스크립트는 아래 7개 고정 카테고리를 계산합니다.

- Tool Coverage
- Context Efficiency
- Quality Gates
- Memory Persistence
- Eval Coverage
- Security Guardrails
- Cost Efficiency

### 4) 출력 형식 분기

- `--format json`: 스크립트 JSON을 그대로 반환
- 기본 텍스트: 핵심 점수, 실패 체크, `top_actions` 중심으로 요약

# 실무 팁 / 주의사항(중요)

- 이 커맨드는 **점수 생성**보다 **개선 우선순위 도출**에 더 큰 가치가 있습니다
- `json` 출력은 대시보드나 자동화 파이프라인에 연결할 때 유용합니다
- 점수를 사람이 다시 해석하더라도, 원본 기준은 항상 스크립트 출력이어야 합니다

# Quick Commands(실행 예)

```text
/harness-audit
/harness-audit hooks
/harness-audit commands --format json
/harness-audit skills
```
