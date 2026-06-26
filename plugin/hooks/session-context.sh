#!/usr/bin/env bash
# SessionStart hook.
#
# Orients the assistant about the plugin's capabilities and flags whether authentication
# is configured (so it can tell the user to set the token before attempting writes).
# Best-effort: uses node (already required by the MCP server) to emit valid JSON; if node
# is unavailable it simply emits nothing and the session proceeds.

cat >/dev/null 2>&1 || true # consume stdin

node -e '
  const has = !!(process.env.CLAUDE_PLUGIN_OPTION_LINKCONTRATA_TOKEN || process.env.LINKCONTRATA_TOKEN);
  const auth = has
    ? "Autenticación configurada (token presente)."
    : "SIN token configurado: las operaciones de escritura se bloquearán hasta configurarlo (config del plugin \"linkcontrata\" o variable LINKCONTRATA_TOKEN).";
  const ctx = "Plugin LinkContrata activo. Capacidades vía herramientas mcp__linkcontrata__*: " +
    "search_regulations (búsqueda semántica de normativa peruana, RAG), create_project (crear proyecto), " +
    "promote_project_to_marketplace (promover un proyecto al marketplace en un paso, idempotente), y lecturas " +
    "de proyectos, oportunidades, paquetes, contratos y pujas. " + auth +
    " Todas las acciones respetan los permisos (rol + plan) y el aislamiento por empresa del usuario, igual que la web.";
  process.stdout.write(JSON.stringify({ hookSpecificOutput: { hookEventName: "SessionStart", additionalContext: ctx } }));
' 2>/dev/null || true

exit 0
