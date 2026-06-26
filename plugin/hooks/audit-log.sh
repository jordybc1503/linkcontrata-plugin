#!/usr/bin/env bash
# PostToolUse hook (every LinkContrata tool).
#
# Append an audit trail line: timestamp + tool name + session id. It deliberately logs
# ONLY the tool name (never the tool input/output) so the log carries no PII or secrets.
# Best-effort and portable (no jq/node): never fails the turn.

input="$(cat 2>/dev/null || true)"

log_dir="${CLAUDE_PLUGIN_DATA:-${CLAUDE_PROJECT_DIR:-$PWD}}"
mkdir -p "${log_dir}" 2>/dev/null || true
log_file="${log_dir%/}/linkcontrata-agent-audit.log"

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo unknown)"
tool="$(printf '%s' "${input}" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
[ -z "${tool}" ] && tool="?"

printf '%s\t%s\tsession=%s\n' "${ts}" "${tool}" "${CLAUDE_SESSION_ID:-?}" >> "${log_file}" 2>/dev/null || true

exit 0
