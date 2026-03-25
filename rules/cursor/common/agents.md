---
description: 전역 Subagent 오케스트레이션 규칙(언제 어떤 에이전트를 쓸지)
alwaysApply: true
---
# Subagent Orchestration (Cursor)

## 범위/우선순위(중요)

Cursor에서 subagent는 다음 두 위치에 존재할 수 있다.

- 프로젝트 전용: `<repo>/.cursor/agents/` (있으면 **우선**)
- 전역(개인): `~/.cursor/agents/`

아래 목록은 “현재 전역 환경에서 흔히 쓰는 subagent” **예시**다. 실제 사용 시에는 **해당 subagent가 존재하는지**를 먼저 확인하고, 없으면 가능한 범위에서 일반 지침으로 대체한다.

## 현재 적용 중인 전역 Subagents

Located in `~/.cursor/agents/`:

| Subagent | Purpose | When to Use |
|---------|---------|-------------|
| planner | 구현 계획 수립 | 기능 구현/리팩터링/큰 변경 전에 계획이 필요할 때 |
| architect | 아키텍처 설계/트레이드오프 분석 | 구조 설계/스케일링/큰 리팩터링 의사결정이 필요할 때 |
| tdd-guide | TDD(RED→GREEN→REFACTOR) 가이드 | 신규 기능/버그 수정/리팩터링을 테스트 우선으로 진행할 때 |
| code-reviewer | 코드 리뷰(품질/보안/유지보수) | 코드 변경 직후, 병합/커밋 전 품질 점검이 필요할 때 |
| security-reviewer | 보안 취약점 점검/완화 | 인증/인가, 사용자 입력, API, 시크릿, 결제/웹훅 등 민감 코드 변경 후 |
| database-reviewer | DB/SQL/스키마/성능 리뷰(Postgres 중심) | SQL/마이그레이션/인덱스/RLS 등 DB 변경 시 |
| build-error-resolver | 빌드/타입 에러 최소 변경 해결(주로 TS) | 빌드 실패/타입 에러가 발생했을 때 “최소 diff”로 복구 |
| refactor-cleaner | 죽은 코드/중복/미사용 의존성 정리 | 정리 작업을 안전하게(작게) 배치로 진행할 때 |
| e2e-runner | E2E 테스트 생성/유지/실행 | 중요한 사용자 여정 검증(E2E)과 아티팩트/플레이키 관리가 필요할 때 |
| typescript-reviewer | TypeScript/JavaScript 코드 리뷰 | TS/JS 변경에서 타입 안정성, async 안전성, 웹/Node 보안 점검이 필요할 때 |
| python-reviewer | Python 코드 리뷰 | Python 변경(PEP8/보안/성능/타입) 리뷰가 필요할 때 |
| go-reviewer | Go 코드 리뷰 | Go 변경(동시성/에러 처리/성능/관용구) 리뷰가 필요할 때 |
| go-build-resolver | Go 빌드 에러 최소 변경 해결 | `go build`/`go vet`/lint 실패를 빠르게 복구해야 할 때 |
| java-reviewer | Java/Spring 코드 리뷰 | Java/Spring 변경에서 계층 구조, JPA, 보안, 동시성 리뷰가 필요할 때 |
| java-build-resolver | Java/Maven/Gradle 빌드 에러 해결 | Java 컴파일, 의존성, Maven/Gradle 빌드 실패를 최소 변경으로 복구할 때 |
| kotlin-reviewer | Kotlin/Android/KMP 코드 리뷰 | Kotlin 변경에서 coroutine, Flow, Compose, 아키텍처 리뷰가 필요할 때 |
| kotlin-build-resolver | Kotlin/Gradle 빌드 에러 해결 | Kotlin 컴파일, Gradle, detekt/ktlint 실패를 최소 변경으로 복구할 때 |
| flutter-reviewer | Flutter/Dart 코드 리뷰 | Flutter 변경에서 위젯 구조, 상태 관리, 성능, 접근성 리뷰가 필요할 때 |
| cpp-reviewer | C++ 코드 리뷰 | C++ 변경에서 메모리 안전성, 동시성, 현대적 C++ 관용구 리뷰가 필요할 때 |
| cpp-build-resolver | C++/CMake 빌드 에러 해결 | C++ 컴파일, 링크, CMake 문제를 최소 변경으로 복구할 때 |
| rust-reviewer | Rust 코드 리뷰 | Rust 변경에서 소유권, lifetime, 에러 처리, unsafe 사용 리뷰가 필요할 때 |
| rust-build-resolver | Rust 빌드 에러 해결 | `cargo build`/`cargo check`/clippy 실패를 최소 변경으로 복구할 때 |
| pytorch-build-resolver | PyTorch 런타임/학습 에러 해결 | 텐서 shape, CUDA, gradient, DataLoader 문제를 최소 변경으로 복구할 때 |

## 선택적으로만 쓰는 Subagents (권장)

아래 subagent들은 “항상 쓰기”보다 **상황에 맞을 때만 호출**하는 편이 효율적이다(프로젝트 언어/스택에 따라 무용할 수 있음).

| Subagent | Purpose | Note |
|---------|---------|------|
| security-reviewer | Security analysis | 민감 변경(입력/인증/시크릿/외부 연동) 시에만 |
| e2e-runner | E2E testing | 제품 성격상 E2E가 유효할 때만 |
| refactor-cleaner | Dead code cleanup | 기능 개발과 분리된 정리 배치에서만 |
| build-error-resolver | Build/type error fix | 빌드가 깨졌을 때만(리팩터링 금지) |
| typescript-reviewer | TypeScript/JavaScript review | TS/JS 프로젝트에서만 |
| go-reviewer / go-build-resolver | Go 전용 | Go 프로젝트에서만 |
| java-reviewer / java-build-resolver | Java 전용 | Java/Spring 프로젝트에서만 |
| kotlin-reviewer / kotlin-build-resolver | Kotlin 전용 | Kotlin/Android/KMP 프로젝트에서만 |
| flutter-reviewer | Flutter 전용 | Flutter/Dart 프로젝트에서만 |
| cpp-reviewer / cpp-build-resolver | C++ 전용 | C++/CMake 프로젝트에서만 |
| rust-reviewer / rust-build-resolver | Rust 전용 | Rust 프로젝트에서만 |
| pytorch-build-resolver | PyTorch 전용 | PyTorch 학습/추론 오류가 있는 프로젝트에서만 |
| python-reviewer | Python 전용 | Python 프로젝트에서만 |

## Immediate Subagent Usage

No user prompt needed:
1. Complex feature requests -> Use **planner**
2. Code just written/modified -> Use **code-reviewer**
3. Bug fix or new feature -> Use **tdd-guide**
4. Architectural decision -> Use **architect**
5. Database-related changes -> Use **database-reviewer**
6. Security-sensitive changes -> Use **security-reviewer**
7. Build/type errors -> Use **build-error-resolver**
8. Dead code cleanup / consolidation -> Use **refactor-cleaner**
9. E2E needed for critical flows -> Use **e2e-runner**
10. TypeScript/JavaScript changes -> Use **typescript-reviewer**
11. Python changes -> Use **python-reviewer**
12. Go changes -> Use **go-reviewer**
13. Go build failures -> Use **go-build-resolver**
14. Java changes -> Use **java-reviewer**
15. Java build failures -> Use **java-build-resolver**
16. Kotlin changes -> Use **kotlin-reviewer**
17. Kotlin build failures -> Use **kotlin-build-resolver**
18. Flutter changes -> Use **flutter-reviewer**
19. C++ changes -> Use **cpp-reviewer**
20. C++ build failures -> Use **cpp-build-resolver**
21. Rust changes -> Use **rust-reviewer**
22. Rust build failures -> Use **rust-build-resolver**
23. PyTorch training/inference failures -> Use **pytorch-build-resolver**

## Parallel Task Execution

Always use parallel subagents for independent operations:
- Good: Run security analysis, performance review, and type checks in parallel
- Bad: Run them sequentially when unnecessary

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth module
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utilities

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

For complex problems, use split role subagents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker

Pick roles based on task complexity and risk.

<!-- End of file -->