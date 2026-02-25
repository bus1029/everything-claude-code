---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Security

> This file extends [common/security.md](../common/security.md) with Python specific content.

## Secret Management

```python
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.environ["OPENAI_API_KEY"]  # Raises KeyError if missing
```

## Security Scanning

- Use **bandit** for static security analysis:
  - 전역 Rule에서는 프로젝트 구조가 제각각이므로, `<APP_DIR>`를 본인 프로젝트의 애플리케이션 루트로 치환한다.
  - 예: `src/`, `app/`, `your_package/`
  ```bash
  bandit -r <APP_DIR>
  # 또는(프로젝트 구조가 단순/소규모일 때)
  bandit -r .
  ```

## Reference

See skill: `django-security` for Django-specific security guidelines (if applicable).
