# Codex CLI Global Instructions

These instructions apply to Codex sessions that load `/Users/seokhyunbae_1/.codex`.
Keep this file short: put durable operating rules here, not copied framework docs or long tool inventories.

## Shell

- Use `rtk` for shell commands when available.
- Examples: `rtk git status`, `rtk cargo test`, `rtk npm run build`, `rtk pytest -q`.
- Use `rtk proxy <cmd>` only when raw, unfiltered command output is required.
- Use raw/proxy output for security scans, diffs, and audits when filtering could hide findings.
- Do not persist or forward raw secret-bearing output to logs, memory, MCP tools, or final responses.
- Redact sensitive output before reporting it.
- If `rtk` is unavailable or breaks a command, run it directly and note why.
- Useful checks: `command -v rtk`, `rtk --version`, `rtk gain`, `rtk gain --history`.

## Working Style

- Codex persistent guidance comes from `AGENTS.md`; do not rely on `CLAUDE.md`, hooks, or slash commands unless the current harness exposes them.
- Follow the active `AGENTS.md` hierarchy for the current workspace.
- Project-local `AGENTS.md` files may narrow or override this global file unless higher-priority runtime or developer instructions say otherwise.
- When instructions conflict on safety, follow the stricter safety rule.
- Prefer direct implementation when the request is clear.
- Read the local codebase before changing behavior.
- Preserve user changes. Do not revert files unless explicitly asked.
- Use `rg` / `rg --files` for search.
- Use `apply_patch` for manual file edits.
- Keep changes scoped to the requested behavior.
- Add comments only when they clarify non-obvious logic.

## Skills

- Use a skill when the user names it or the task clearly matches it.
- Read only the relevant `SKILL.md` and nearby referenced files.
- Prefer existing scripts/assets/templates from the skill over recreating them.
- Do not paste long skill inventories into this file; discover skills from the active Codex skill list.

## Agents

- Use sub-agents only when the user explicitly asks for agents, delegation, or parallel agent work.
- When agents are requested, check `.codex/config.toml` for `[features] multi_agent` and project roles under `.codex/agents/` when relevant.
- For ordinary implementation, inspect and edit locally.
- If agents are used, give each one a concrete, bounded task and avoid overlapping write ownership.
- Do not pass secrets or credentials to agents unless the user explicitly approves that scope for the current task; send the minimum needed.

## Testing And Verification

- Match verification depth to risk and blast radius.
- For code changes, run the narrowest relevant tests first, then broader checks when shared behavior is touched.
- For frontend work, verify rendered behavior in a browser when practical.
- Before push/commit, review `git diff` and run relevant lint/type/test/security checks.
- If a check cannot run, report the reason and residual risk.

## Security

- Never hardcode secrets, tokens, passwords, or private keys.
- Do not read secret-bearing files or raw secret output unless the task specifically requires that exact secret source.
- Prefer existence checks, key-name-only inspection, or redacted excerpts over full secret reads.
- Redact tokens, cookies, private keys, auth files, and `.env` values from responses, logs, memory, and MCP calls.
- Use environment variables or a secret manager for credentials.
- Validate external input at system boundaries.
- Prefer parameterized queries and framework escaping APIs.
- Do not expose sensitive details in client-visible errors or logs.
- Do not run destructive shell commands, privilege escalation, network install scripts, production deploys, cloud/database deletion, or irreversible migrations unless the user explicitly requests that exact operation.
- For destructive or privileged operations, require explicit target, environment, and operation.
- Do not expand destructive scope with globs, recursion, force flags, or production targets unless those are explicitly requested.
- Run ecosystem audits when dependencies or lockfiles change, before publish/deploy/release, and during explicit security reviews when package manifests exist: `npm audit`, `pnpm audit`, `pip-audit`, `safety`, `cargo audit`, `govulncheck`, or `bundler-audit`.
- If audit tooling is unavailable, report residual dependency risk.

## External Action Boundaries

Treat networked tools as read-only by default. Search, inspect, and draft freely within the user's requested scope, but require explicit user approval before posting, publishing, pushing, merging, opening paid jobs, dispatching remote agents, changing third-party resources, or modifying credentials.

When approval is ambiguous, produce a local plan or draft artifact instead of taking the external action. Preserve user config and private state unless the user specifically asks for a scoped change.

## Multi-Agent Support

## Code Quality

- Keep functions and files focused.
- Prefer clear data flow and explicit error handling.
- Avoid silent failure paths.
- Use existing project patterns before adding new abstractions.
- Favor immutable updates where practical, especially in application state and shared data.

## Git

- Commit messages should use conventional format: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `perf:`, or `ci:`.
- Do not commit, push, publish, or create releases unless explicitly requested.
- Push with upstream tracking for new branches when asked to push.
- Treat reset, checkout/restore of user changes, branch deletion, and force push as destructive git operations.

## MCP And Config

- Current runtime and developer instructions are authoritative over project-local config.
- Follow the active sandbox, approval, and network policy exactly; do not request unavailable approvals or weaken runtime controls.
- Treat project-local `.codex/config.toml` as the project-specific Codex config baseline when present; active runtime policy still wins.
- Add heavier MCP servers only when a task needs them.
- Use `[mcp_servers.context7]` for Context7.
- Prefer pinned MCP packages and least-privilege or read-only tools.
- Do not weaken sandbox, approval, network, or MCP permissions from project-local config without explicit user approval.
- Never pass credentials, tokens, cookies, private keys, or secret file contents to MCP tools unless the user explicitly approves that tool and scope for the current task; send the minimum needed.
- Prefer add-only config changes unless explicitly asked to update or replace managed sections.
- Preserve user config and credentials when editing Codex configuration.
