---
description: Cursor로 이식된 훅들( hooks/cursor ) 분석/제약/사용 가이드
---

# Cursor Hooks 이식 분석 노트

이 문서는 레포에 추가된 Cursor용 훅 세트(`hooks/cursor`)를 분석하면서 확인한 **이식 가능 범위**, **Cursor에서 바로 쓰기 위한 전제**, **전역(User) vs 프로젝트(Project) 훅 분리 기준**, **이식이 어려운(또는 제외해야 하는) 훅과 이유**를 정리한 노트다.

> 목표: “왜 이 훅들이 동작하는지/어디서 깨질 수 있는지”를 사용자가 빠르게 이해하고, 필요한 사람만 안전하게 `.cursor/` 아래로 복사해서 사용할 수 있게 한다.

## 현재 디렉터리 구성(중요)

Cursor 훅은 적용 범위에 따라 두 세트로 분리되어 있다.

- `hooks/cursor/project/`
  - **프로젝트 훅**으로 쓰기 적합(레포마다 정책이 달라도 되는 훅 포함)
  - 파일 편집 후 포맷/타입체크/로그 점검 등 **레포 루트의 `scripts/hooks/*` 재사용**이 포함됨
- `hooks/cursor/user/`
  - **전역 훅**으로 쓰기 적합(프로젝트와 무관하게 의미 있는 감시/경고 중심)
  - 가능하면 프로젝트 의존(레포 내 파일/스크립트)을 피함

## 전체 구조(핵심 아이디어)

Cursor 훅 스크립트들은 대부분 “얇은 래퍼”이고, (특히 project 세트에서) 실제 로직은 기존 훅 구현(`scripts/hooks/*`)을 재사용한다.

- Cursor 이벤트에서 넘어오는 stdin JSON을
- **Claude Code 훅 입력 형태**에 가깝게 변환한 뒤
- 기존 `scripts/hooks/*.js`를 실행한다(중복 없이 DRY).

이 방식의 장점:

- Claude Code와 Cursor에서 **동일한 훅 로직을 공유**할 수 있다.
- 플랫폼 차이(Windows/macOS/Linux)는 Node 기반 스크립트로 흡수한다.

## Cursor `hooks.json` 포맷(스키마 v1)

Cursor 공식 문서 기준([Hooks](https://cursor.com/docs/agent/hooks)) `hooks.json`은 다음이 핵심이다.

- 최상단에 `"version": 1`을 둔다.
- 이벤트 이름은 `hooks` 객체의 키로 이미 표현되므로, 개별 훅 항목에 `"event"` 필드는 필요 없다.
- **User hooks**(`~/.cursor/hooks.json`)는 실행 cwd가 `~/.cursor/`이므로 보통 `./hooks/...` 경로를 쓴다.
- **Project hooks**(`<repo>/.cursor/hooks.json`)는 실행 cwd가 **프로젝트 루트**이므로 보통 `.cursor/hooks/...` 경로를 쓴다.

이 레포의 `hooks/cursor/*/hooks.json`도 위 포맷(v1)에 맞춰 정리되어 있다.

## Cursor에서 “바로 사용”하기 위한 전제

아래 조건이 만족되어야 훅이 기대대로 동작한다.

- **Node.js가 설치되어 있음**

### 프로젝트 훅(Project hooks) 전제

- `<repo>/.cursor/hooks.json`과 `<repo>/.cursor/hooks/*.js`가 존재
- (해당 훅을 쓸 경우) 레포 루트에 `scripts/hooks/*`가 존재  
  - 예: `afterFileEdit`에서 포맷/타입체크 등을 `scripts/hooks/*`로 위임하는 경우
- 일부 훅은 외부 명령에 의존한다(없어도 대체로 “경고만” 발생)
  - 예: `npx prettier`, `npx tsc`, `@biomejs/biome` 등

### 전역 훅(User hooks) 전제

- `~/.cursor/hooks.json`과 `~/.cursor/hooks/*.js`가 존재
- 전역 훅 세트(`hooks/cursor/user`)는 **가능하면 레포 루트의 `scripts/hooks/*`에 의존하지 않도록 구성**되어 있다.

## 이식 가능한 훅(즉시 사용 가능 범주)

아래 훅들은 Cursor 이벤트 입력만으로도 의미 있게 동작하며, Claude Code 전용 데이터에 강하게 의존하지 않는다.  
또한 현재 구성 기준으로 “전역에 두기 적합한지” 여부가 달라서, project/user로 나눠 정리한다.

### 프로젝트 훅(project)로 두는 것(정책 충돌/차단 가능성 때문에)

- **beforeShellExecution**
  - dev 서버를 tmux 없이 실행하는 것을 차단(exit code 2)
  - 장시간 명령 tmux 리마인더(경고)
  - `git push` 리뷰 리마인더(경고)
- **beforeTabFileRead**
  - Tab이 민감 파일을 읽으려 하면 차단(exit code 2)

### 전역 훅(user)로 두기 적합한 것(프로젝트 무관하게 가치가 큰 감시/경고)

- **beforeSubmitPrompt**
  - 프롬프트에 토큰/키 패턴이 포함되면 경고(sk-, ghp_, AKIA, private key 등)
- **beforeReadFile**
  - `.env`, `.key`, `.pem`, `credentials`, `secret` 등 민감 파일 읽기 경고
- **beforeMCPExecution / afterMCPExecution**
  - MCP 서버/툴 호출과 결과(OK/FAILED)를 stderr로 로깅(감사 로그 성격)
- **subagentStart / subagentStop**
  - 에이전트 스폰/완료를 로깅(관측성)
- **afterShellExecution**
  - `gh pr create` 출력에서 PR URL 추출 리마인더
  - 빌드 커맨드 완료 메시지(경고/노티)

### 프로젝트 훅(project)에서 특히 유용한 것(레포 컨벤션/품질 자동화)

- **afterFileEdit / afterTabFileEdit**
  - JS/TS 포매터 자동 감지 후 포맷팅(Biome/Prettier)
  - `.ts/.tsx` 편집 시 `tsc --noEmit` 실행 후 해당 파일 관련 에러만 요약 출력
  - `console.log` 경고
- **sessionStart**
  - 이전 세션 요약 로드(있다면) + 패키지 매니저 감지/가이드 메시지
- **preCompact**
  - 컨텍스트 컴팩션 직전에 상태 로그를 남김
- **stop**
  - 수정된 JS/TS 파일들에서 `console.log` 존재 여부를 점검해 경고

## 이식이 “바로는 어려운” 훅과 이유

### sessionEnd (제외 권장)

`sessionEnd` 계열 로직은 기존 Claude Code 훅 구현(`scripts/hooks/session-end.js`, `scripts/hooks/evaluate-session.js`)에서 **`transcript_path`**(세션 트랜스크립트 JSONL 파일 경로)를 입력으로 받아야 제대로 동작한다.

문제:

- Cursor 훅 입력에는 `transcript_path`가 포함될 수 있으나(설정/환경에 따라 null 가능),  
  현재 훅 구현은 Claude Code 방식의 트랜스크립트 포맷/경로를 전제로 하므로 **그대로는 호환을 보장하기 어렵다.**
- 매핑이 없다면:
  - 세션 요약 추출 품질이 크게 떨어지거나(또는 건너뜀)
  - “세션 학습/패턴 평가”가 사실상 실행되지 않는다(즉시 종료).

따라서 `sessionEnd`는 “Cursor에서 트랜스크립트 제공 방식이 확정되고 매핑이 준비된 뒤”에만 다시 포함하는 편이 안전하다.

## 차단(blocking) 훅의 동작 원리(주의)

일부 훅은 “차단”을 위해 **exit code 2**를 사용한다.

- 예: dev 서버를 tmux 없이 실행하는 경우 차단
- 예: Tab이 민감 파일을 읽으려 하면 차단

이 차단은 편리하지만, 팀/개인 워크플로와 충돌할 수 있다.

권장:

- 개인 환경에 맞지 않으면 차단 훅을 제거하거나 “경고만” 하도록 완화한다.
- 특히 tmux 강제 정책은 macOS/Linux 기준이며 Windows 환경에서는 동작/의미가 다를 수 있다.

## 운영/보안 관점 체크

- 훅은 stdout으로 **원본 JSON을 그대로 반환**하고, 경고/로그는 stderr로 내보내는 패턴을 따른다.
- 시크릿 관련 훅은 “완벽한 탐지”가 아니라 **사고 예방용 경고**이다.
- 민감 파일 읽기/프롬프트 시크릿 경고가 떠도, 결과를 다른 채널(이슈/PR/노션)에 복사할 때는 **추가 유출이 없도록** 별도 주의가 필요하다.

## 추천 적용 방식(사용자 복사용)

필요한 사람만 아래 중 필요한 세트를 복사해서 활성화한다.

### 프로젝트에만 적용하고 싶을 때(Project hooks)

- `hooks/cursor/project/hooks.json` → `<repo>/.cursor/hooks.json`
- `hooks/cursor/project/hooks/` → `<repo>/.cursor/hooks/`

그리고 (해당 훅이 `scripts/hooks/*`에 위임한다면) 레포 루트에 `scripts/hooks/*`가 존재하는지 확인한다.

### 전역으로 적용하고 싶을 때(User hooks)

- `hooks/cursor/user/hooks.json` → `~/.cursor/hooks.json`
- `hooks/cursor/user/hooks/` → `~/.cursor/hooks/`

전역 훅 세트는 가능하면 레포 의존을 피하도록 구성되어 있지만,  
차단 훅(특히 tmux/dev-server 차단)은 전역에 두면 작업 흐름과 충돌할 수 있으니 주의한다.

