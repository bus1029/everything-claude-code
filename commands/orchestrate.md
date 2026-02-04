# Orchestrate Command

Sequential subagent workflow for complex tasks.

## Usage

`/orchestrate [workflow-type] [task-description]`

## Workflow Types

### feature
Full feature implementation workflow:
```
planner -> tdd-guide -> code-reviewer
```
Note:
- `security-reviewer` is often disabled in Cursor setups (e.g. `.not_used`). If enabled and the work involves auth/payment/PII, run it after `code-reviewer`.

### bugfix
Bug investigation and fix workflow:
```
explore -> tdd-guide -> code-reviewer
```

### refactor
Safe refactoring workflow:
```
architect -> code-reviewer -> tdd-guide
```

### security
Security-focused review:
```
code-reviewer -> architect
```
Note:
- If `security-reviewer` is available/enabled, run: `security-reviewer -> code-reviewer -> architect`.

## Execution Pattern

For each subagent in the workflow:

1. **Invoke subagent** with context from previous subagent
2. **Collect output** as structured handoff document
3. **Pass to next subagent** in chain
4. **Aggregate results** into final report

## Handoff Document Format

Between subagents, create handoff document:

```markdown
## HANDOFF: [previous-subagent] -> [next-subagent]

### Context
[Summary of what was done]

### Findings
[Key discoveries or decisions]

### Files Modified
[List of files touched]

### Open Questions
[Unresolved items for next subagent]

### Recommendations
[Suggested next steps]
```

## Example: Feature Workflow

```
/orchestrate feature "Add user authentication"
```

Executes:

1. **Planner Subagent**
   - Analyzes requirements
   - Creates implementation plan
   - Identifies dependencies
   - Output: `HANDOFF: planner -> tdd-guide`

2. **TDD Guide Subagent**
   - Reads planner handoff
   - Writes tests first
   - Implements to pass tests
   - Output: `HANDOFF: tdd-guide -> code-reviewer`

3. **Code Reviewer Subagent**
   - Reviews implementation
   - Checks for issues
   - Suggests improvements
   - Output: `HANDOFF: code-reviewer -> (optional) security-reviewer`

4. **(Optional) Security Reviewer Subagent**
   - Only if available/enabled and the change is security-sensitive (auth/payment/PII)
   - Output: Final Report

## Final Report Format

```
ORCHESTRATION REPORT
====================
Workflow: feature
Task: Add user authentication
Subagents: planner -> tdd-guide -> code-reviewer -> (optional) security-reviewer

SUMMARY
-------
[One paragraph summary]

SUBAGENT OUTPUTS
----------------
Planner: [summary]
TDD Guide: [summary]
Code Reviewer: [summary]
Security Reviewer: [summary]

FILES CHANGED
-------------
[List all files modified]

TEST RESULTS
------------
[Test pass/fail summary]

SECURITY STATUS
---------------
[Security findings]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
```

## Parallel Execution

For independent checks, run subagents in parallel:

```markdown
### Parallel Phase
Run simultaneously:
- code-reviewer (quality)
- security-reviewer (security, optional if enabled)
- architect (design)

### Merge Results
Combine outputs into single report
```

## Arguments

$ARGUMENTS:
- `feature <description>` - Full feature workflow
- `bugfix <description>` - Bug fix workflow
- `refactor <description>` - Refactoring workflow
- `security <description>` - Security review workflow
- `custom <subagents> <description>` - Custom subagent sequence

## Custom Workflow Example

```
/orchestrate custom "architect,tdd-guide,code-reviewer" "Redesign caching layer"
```

## Tips

1. **Start with planner** for complex features
2. **Always include code-reviewer** before merge
3. **Use security-reviewer** for auth/payment/PII
4. **Keep handoffs concise** - focus on what next subagent needs
5. **Run verification** between subagents if needed
