# Verification Command

Run comprehensive verification on current codebase state.

## Instructions

Execute verification in this exact order:

1. **Build Check**
   - Run the build command for this project
   - If it fails, report errors and STOP

2. **Static / Type Check (if applicable)**
   - Run the project's static analysis and/or type checker (only if the project has one)
   - Report all errors with file:line
   - Examples:
     - TypeScript: `tsc --noEmit`
     - Python: `ruff check .` and `mypy .`
     - Go: `go vet ./...`

3. **Lint Check**
   - Run linter
   - Report warnings and errors

4. **Test Suite**
   - Run all tests
   - Report pass/fail count
   - Report coverage percentage

5. **Secrets Check**
   - Scan modified files for likely secrets (API keys, tokens, passwords)
   - Report any findings with file:line and redacted previews

6. **Debug Log Audit (if applicable)**
   - Search for debug logs in source files (e.g. `console.log`, `print`, `logger.debug`)
   - Report locations

7. **Git Status**
   - Show uncommitted changes
   - Show files modified since last commit

## Output

Produce a concise verification report:

```
VERIFICATION: [PASS/FAIL]

Build:    [OK/FAIL]
Static:   [OK/X errors]
Lint:     [OK/X issues]
Tests:    [X/Y passed, Z% coverage]
Secrets:  [OK/X found]
Logs:     [OK/X console.logs]

Ready for PR: [YES/NO]
```

If any critical issues, list them with fix suggestions.

## Arguments

$ARGUMENTS can be:
- `quick` - Only build + static/type checks (if applicable)
- `full` - All checks (default)
- `pre-commit` - Checks relevant for commits
- `pre-pr` - Full checks plus security scan
