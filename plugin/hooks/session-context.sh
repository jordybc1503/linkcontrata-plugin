#!/usr/bin/env bash
# SessionStart hook.
#
# Orients the assistant about the plugin's capabilities and how the user signs in (OAuth, no token).
# Best-effort: uses node (already required by the MCP server) to emit valid JSON; if node
# is unavailable it simply emits nothing and the session proceeds.

cat >/dev/null 2>&1 || true # consume stdin

node -e '
  const ctx = "Plugin LinkContrata activo (servidor MCP remoto https://linkcontrata.lat/mcp). La conexión se autoriza " +
    "iniciando sesión con la cuenta de LinkContrata del usuario (OAuth): si una herramienta responde que no hay sesión, " +
    "pide al usuario autenticarse con /mcp → linkcontrata. Todo se hace con COMANDOS detrás de cinco herramientas " +
    "mcp__plugin_linkcontrata_linkcontrata__*: list_commands (índice) y describe_command (esquema); batch para leer " +
    "(uno o varios comandos); show_command para enseñarle un resultado al usuario en pantalla; y execute para un cambio " +
    "(crear, publicar, pujar, avanzar un flujo), confirmándolo antes. " +
    "Todo respeta los permisos (rol + plan) y el aislamiento por empresa del usuario, igual que la web.";
  process.stdout.write(JSON.stringify({ hookSpecificOutput: { hookEventName: "SessionStart", additionalContext: ctx } }));
' 2>/dev/null || true

exit 0
