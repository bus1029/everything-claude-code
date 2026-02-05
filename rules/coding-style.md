# Coding Style

## Scope

이 문서는 **전역 Rules**로 두어도 되는 “언어/프로젝트 비종속 코딩 원칙”을 담는다.  
코드 블록은 **이해를 돕기 위한 예시**이며, 특정 언어/라이브러리에 종속되지 않게 해석한다(예시는 주로 Python).

## Immutability (CRITICAL)

원칙: **새 객체를 만들어 반환**하고, 가능하면 **in-place mutation을 피한다**.  
불가피하게 mutation이 더 안전/효율적인 경우(성능, 대용량 자료구조 등)에는 **왜 필요한지 한글 주석으로 의도를 명시**하고, 변경 범위를 최소화한다.

```python
# WRONG: Mutation
def update_user(user: dict, name: str) -> dict:
    user["name"] = name  # MUTATION!
    return user

# CORRECT: Immutability
def update_user(user: dict, name: str) -> dict:
    return {**user, "name": name}
```

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

## Error Handling

원칙: 에러는 **경계에서 검증하고**, 실패는 **예측 가능한 방식**으로 처리한다(사용자 메시지/로깅/재시도 정책 등).  
`print()`/`console.log` 같은 디버그 출력 대신 로깅을 사용한다.

```python
import logging

logger = logging.getLogger(__name__)

def risky_operation() -> str:
    try:
        result = do_work()
        return result
    except SpecificError as e:
        logger.exception("Operation failed")
        raise UserFacingError("Detailed user-friendly message") from e
```

## Input Validation

원칙: 사용자 입력/외부 입력은 **경계에서 항상 검증**한다.  
검증 도구는 스택에 맞는 것을 사용한다(예: Python의 Pydantic, TypeScript의 Zod 등).

```python
from pydantic import BaseModel, EmailStr, Field

class InputModel(BaseModel):
    email: EmailStr
    age: int = Field(ge=0, le=150)

validated = InputModel.model_validate(input_dict)
```

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No print()/console.log debug statements (use logging)
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns used)
