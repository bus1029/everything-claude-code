# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate:

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

ALWAYS handle errors comprehensively:

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

ALWAYS validate user input:

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
- [ ] No print() debug statements (use logging)
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns used)
