---
description: 전역 보안 가이드(시크릿/입력검증/인증/CSRF 등 체크리스트)
alwaysApply: true
---
# Security Guidelines

## Scope / Precedence

- 이 문서는 **전역 Rules 기본값**이다.
- 프로젝트/조직의 보안 정책(예: 사고 대응, 취약점 공개, 로깅/마스킹, 키 관리, SAST/DAST, 승인 절차)이 있으면 **그 정책이 우선**이다.
- 아래 체크리스트는 “기본 안전장치”이며, 프로젝트 성격에 따라 항목을 추가/강화한다.

## Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management

원칙: 시크릿은 **코드/문서/로그에 절대 포함하지 않는다**. 필요 시 예시는 항상 마스킹한다.
- NEVER hardcode secrets in source code
- ALWAYS use environment variables or a secret manager
- Validate that required secrets are present at startup
- Rotate any secrets that may have been exposed

```python
import os

# NEVER: Hardcoded secrets
# api_key = "sk-proj-xxxxx"

# ALWAYS: Environment variables
api_key = os.environ.get("OPENAI_API_KEY")
if not api_key:
    raise RuntimeError("OPENAI_API_KEY not configured")
```

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** subagent (if enabled). If not available, use **code-reviewer** and **architect** to assess impact and remediation.
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
