---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Testing

> This file extends [common/testing.md](../common/testing.md) with Python specific content.

## Framework

Use **pytest** as the testing framework.

## Coverage

전역 Rule에서는 프로젝트 구조가 제각각이므로, `<APP_PKG>`를 본인 프로젝트의 애플리케이션/패키지 이름으로 치환한다.  
예: `src`, `app`, `your_package`

```bash
pytest --cov=<APP_PKG> --cov-report=term-missing
```

## Test Organization

Use `pytest.mark` for test categorization:

```python
import pytest

@pytest.mark.unit
def test_calculate_total():
    ...

@pytest.mark.integration
def test_database_connection():
    ...
```

## Reference

See skill: `python-testing` for detailed pytest patterns and fixtures.
