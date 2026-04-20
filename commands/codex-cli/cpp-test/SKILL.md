---
name: cpp-test
description: Apply a C++ TDD workflow with GoogleTest, CTest, and coverage verification.
---

# C++ Test

Use this skill when adding or fixing C++ behavior with a test-first workflow.

## Canonical Surface

- This is a standalone TDD workflow.
- Follow the project's existing CMake, CTest, GoogleTest, and coverage setup when available.

## Workflow

1. Lock the target function or class interface first.
2. Write a failing test before implementation.
3. Use `cmake --build` and `ctest` to confirm RED.
4. Write the minimum implementation needed for GREEN.
5. Run tests again.
6. Refactor if needed.
7. Check coverage with available tools such as `gcov` or `lcov`.

## Test guidance

- happy path
- invalid input
- boundary case
- error path
- use fixtures when the existing test pattern calls for them
- use parameterized tests when they fit the existing framework pattern

## Verification

Example commands:

```bash
cmake -B build -S .
cmake --build build
ctest --test-dir build --output-on-failure
lcov --capture --directory build --output-file coverage.info
```

## Output expectations

- added test files
- RED and GREEN evidence
- coverage result
- remaining test gaps
