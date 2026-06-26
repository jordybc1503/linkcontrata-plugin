#!/usr/bin/env bash
# PreToolUse hook (LinkContrata write tools).
#
# "Tiene que pedir autenticación": before any state-changing LinkContrata tool runs,
# require that an API token is configured. This is defense-in-depth ON TOP of the API's
# own auth (Rails rejects a missing/invalid token with 401 and a read-only token with
# 403); blocking here gives the user a clear, actionable message before the call leaves
# the machine. The token comes from the plugin's userConfig (sensitive) exposed as
# CLAUDE_PLUGIN_OPTION_LINKCONTRATA_TOKEN, or from a plain LINKCONTRATA_TOKEN env var.
#
# Output contract (PreToolUse, exit 0): emit a permissionDecision to deny; emit nothing
# to let the normal permission flow proceed. Portable: no jq/node needed.

cat >/dev/null 2>&1 || true # consume stdin (we don't need the payload)

token="${CLAUDE_PLUGIN_OPTION_LINKCONTRATA_TOKEN:-${LINKCONTRATA_TOKEN:-}}"

if [ -z "${token}" ]; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"LinkContrata: falta el token de API para una operación de escritura. Configúralo en la config del plugin \"linkcontrata\" (o exporta LINKCONTRATA_TOKEN). Genera un token con scope read_write en LinkContrata → Configuración → Tokens de API."}}'
fi

exit 0
