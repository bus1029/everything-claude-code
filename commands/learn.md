# /learn - Extract Reusable Patterns

Analyze the current session and extract any patterns worth saving as Cursor skills.

## Trigger

Run `/learn` at any point during a session when you've solved a non-trivial problem.

## What to Extract

Look for:

1. **Error Resolution Patterns**
   - What error occurred?
   - What was the root cause?
   - What fixed it?
   - Is this reusable for similar errors?

2. **Debugging Techniques**
   - Non-obvious debugging steps
   - Tool combinations that worked
   - Diagnostic patterns

3. **Workarounds**
   - Library quirks
   - API limitations
   - Version-specific fixes

4. **Project-Specific Patterns**
   - Codebase conventions discovered
   - Architecture decisions made
   - Integration patterns

## Output Format

Create a skill directory and `SKILL.md`.

Recommended (project-local, versionable):
- `.cursor/skills/learned-[pattern-name]/SKILL.md`

Alternative (personal, available across projects):
- `~/.cursor/skills/learned-[pattern-name]/SKILL.md`

```markdown
---
name: learned-[pattern-name]
description: [What this skill does]. Use when [trigger scenario].
disable-model-invocation: true
---

# [Descriptive Pattern Name]

**Extracted:** [Date]
**Context:** [Brief description of when this applies]

## Problem
[What problem this solves - be specific]

## Solution
[The pattern/technique/workaround]

## Example
[Code example if applicable]

## When to Use
[Trigger conditions - what should activate this skill]
```

## Process

1. Review the session for extractable patterns
2. Identify the most valuable/reusable insight
3. Draft the skill `SKILL.md`
4. Ask user to confirm before saving
5. Save to `.cursor/skills/` (project-local) or `~/.cursor/skills/` (personal)

## Notes

- Don't extract trivial fixes (typos, simple syntax errors)
- Don't extract one-time issues (specific API outages, etc.)
- Focus on patterns that will save time in future sessions
- Keep skills focused - one pattern per skill
