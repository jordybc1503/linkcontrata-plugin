# LinkContrata — Claude Code plugin

Control [LinkContrata](https://linkcontrata.lat) from your AI assistant: search Peruvian
procurement regulations, review projects, and create/publish marketplace opportunities —
all with **your own authentication and permissions**.

This is the **public distribution** of the LinkContrata plugin. It contains no private
code: just the plugin manifest, skills, commands, agents and hooks. The actual work is
done by the public MCP server [`@linkcontrata/mcp`](https://www.npmjs.com/package/@linkcontrata/mcp),
which calls LinkContrata's API with the personal token you provide.

## Install (Claude Code)

```bash
/plugin marketplace add jordybc1503/linkcontrata-plugin
/plugin install linkcontrata@linkcontrata
```

Claude Code will ask for your **LinkContrata API token** (generate it at LinkContrata →
*Configuración → Tokens de API*) and the instance URL (default `https://linkcontrata.lat`).
Then ask in natural language: *"busca normas sobre plazos de apelación de la buena pro"* or
*"promueve mi proyecto 12 al marketplace"*.

## Use without the plugin (any MCP client)

Don't use Claude Code? The MCP server is public on npm and works with Claude Desktop,
ChatGPT and any MCP-compatible client. Add this to your MCP config:

```json
{
  "mcpServers": {
    "linkcontrata": {
      "command": "npx",
      "args": ["-y", "@linkcontrata/mcp"],
      "env": {
        "LINKCONTRATA_TOKEN": "lct_your_token_here",
        "LINKCONTRATA_URL": "https://linkcontrata.lat"
      }
    }
  }
}
```

Full step-by-step guide (Spanish): https://linkcontrata.lat/ayuda/asistente-ia-mcp-y-api

## Security

The token travels as `Authorization: Bearer …`; LinkContrata stores only its SHA-256 hash.
The assistant can only do what you could do on the web — every call is scoped to your
company and your role/plan. A read-only token cannot create or publish anything. Revoke a
token anytime from *Configuración → Tokens de API*.

---

Plugin details and component docs: [`plugin/README.md`](plugin/README.md). License: MIT.
