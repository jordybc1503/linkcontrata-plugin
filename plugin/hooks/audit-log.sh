#!/usr/bin/env bash
# PostToolUse hook (every LinkContrata tool).
#
# Append an audit trail line: timestamp + tool name + the command(s) it ran + session id. It deliberately logs
# ONLY names (never the arguments or the output) so the log carries no PII or secrets.
# Best-effort and portable (no jq/node): never fails the turn.

input="$(cat 2>/dev/null || true)"

log_dir="${CLAUDE_PLUGIN_DATA:-${CLAUDE_PROJECT_DIR:-$PWD}}"
mkdir -p "${log_dir}" 2>/dev/null || true
log_file="${log_dir%/}/linkcontrata-agent-audit.log"

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo unknown)"
tool="$(printf '%s' "${input}" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
[ -z "${tool}" ] && tool="?"
# execute / show_command run one command, batch several: keep their names (catalog names, never args or output).
# Only tool_input.command / tool_input.calls[].command, and only catalog command names (anything else → "?"),
# so nothing the caller typed lands in the log. No node → tool only.
# COMMANDS = api/src/modules/mcp/catalog.ts (kept equal by api/test/unit/mcp/plugin-hooks.test.ts).
COMMANDS="whoami dashboard_summary search_regulations list_regulatory_documents get_regulatory_document list_opportunities get_opportunity list_recommendations list_projects get_project list_packages list_contracts list_bids get_bid create_project promote_project_to_marketplace create_opportunity publish_opportunity submit_bid send_contact_message get_help get_public_opportunity list_flows get_flow start_flow submit_flow_step ask_company list_my_opportunities get_brain_context search_brain get_brain_page get_brain_schema get_brain_neighbors import_brain update_brain_page decide_flow_step cancel_flow get_company_procurement_profile list_opportunity_quote_items list_bid_items save_bid_draft create_saved_search list_saved_searches run_saved_search delete_saved_search get_process_deadlines get_norm_article search_norms get_bidder_profile update_bidder_profile add_bidder_experience delete_bidder_experience check_experience_threshold update_company"
commands="$(printf '%s' "${input}" | COMMANDS="${COMMANDS}" node -e '
  let d = ""; process.stdin.on("data", (c) => (d += c)).on("end", () => {
    try {
      const i = JSON.parse(d).tool_input || {};
      const names = [i.command, ...(Array.isArray(i.calls) ? i.calls.map((c) => c && c.command) : [])];
      const known = new Set(process.env.COMMANDS.split(" "));
      process.stdout.write(names.filter((n) => n !== undefined).slice(0, 10).map((n) => (known.has(n) ? n : "?")).join(","));
    } catch {}
  });' 2>/dev/null || true)"
[ -n "${commands}" ] && tool="${tool}(${commands})"

printf '%s\t%s\tsession=%s\n' "${ts}" "${tool}" "${CLAUDE_SESSION_ID:-?}" >> "${log_file}" 2>/dev/null || true

exit 0
