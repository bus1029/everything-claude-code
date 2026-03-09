#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
RTK_HOOK_PATH="${RTK_HOOK_PATH:-${HOME}/.claude/hooks/rtk-rewrite.sh}"

# Cursor의 모든 preToolUse 이벤트 중 Shell만 RTK 대상으로 변환한다.
if ! printf '%s' "$INPUT" | jq -e '.tool_name == "Shell"' >/dev/null 2>&1; then
  printf '{"permission":"allow"}'
  exit 0
fi

# 로컬 Claude 설치가 없는 환경에서도 사용자 훅 세트가 그대로 로드되도록 fail-open 한다.
if [ ! -x "$RTK_HOOK_PATH" ]; then
  printf '{"permission":"allow"}'
  exit 0
fi

# Cursor preToolUse 입력을 Claude PreToolUse 입력 형태로 맞춰서 RTK hook에 넘긴다.
CLAUDE_INPUT=$(printf '%s' "$INPUT" | jq -c '{
  tool_name: "Bash",
  tool_input: {
    command: (.tool_input.command // .command // .args.command // ""),
    file_path: (.tool_input.file_path // .path // .file // "")
  },
  tool_output: {
    output: (.tool_output.output // .output // .result // "")
  }
}')

# Claude Code용 RTK hook을 재사용하고, Cursor 응답 형식으로 다시 감싼다.
CLAUDE_OUT=$(
  printf '%s' "$CLAUDE_INPUT" | "$RTK_HOOK_PATH" 2>/dev/null || true
)

UPDATED=$(printf '%s' "$CLAUDE_OUT" | jq -c '.hookSpecificOutput.updatedInput // empty' 2>/dev/null || true)

if [ -z "$UPDATED" ]; then
  printf '{"permission":"allow"}'
  exit 0
fi

jq -n --argjson updated "$UPDATED" '{
  permission: "allow",
  updated_input: $updated
}'
