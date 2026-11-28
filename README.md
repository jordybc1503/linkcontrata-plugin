# LinkContrata — Claude Code plugin

Control [LinkContrata](https://linkcontrata.lat) from your AI assistant: search Peruvian
procurement regulations, review opportunities and projects, and create/publish marketplace
opportunities — **signing in with your own LinkContrata account** (no token to paste).

This is the **public distribution** of the LinkContrata plugin. It contains no private
code: just the plugin manifest, skills, commands, agents and hooks. The work is done by
LinkContrata's remote MCP server, `https://linkcontrata.lat/mcp`.

## Install (Claude Code)

```bash
/plugin marketplace add jordybc1503/linkcontrata-plugin
/plugin install linkcontrata@linkcontrata
```

Then run `/mcp`, pick **linkcontrata** → **Authenticate**, sign in with your LinkContrata
account in the browser and press **Autorizar** (read-only or read & write). Ask in natural
language: *"busca normas sobre plazos de apelación de la buena pro"*, *"promueve mi
proyecto 12 al marketplace"* or *"prepara mi oferta para CM-658-2026-SERVIR"* (`/linkcontrata:preparar-oferta`).

**Preparing offers:** for a public OECE/SEACE process the plugin reads the Bases and gives you the requirements,
an eligibility check against the regulations and draft quotation/letter/declarations — **you present it in the
SEACE**; for a private opportunity published in LinkContrata it helps you price it and sends it there with your
confirmation.

Already installed? Update with `/plugin marketplace update linkcontrata` and reinstall.

## Use without the plugin (any MCP client)

Add a remote MCP connector with this URL and sign in when asked:

```
https://linkcontrata.lat/mcp
```

- **Claude (web / desktop):** add a custom connector with the URL.
- **Claude Code:** `claude mcp add --transport http linkcontrata https://linkcontrata.lat/mcp`
- **ChatGPT and other MCP clients:** add a remote MCP server with the URL.

Supported assistants also show interactive screens (MCP Apps) for opportunities, regulations,
your dashboard and projects, and can run multi-step queries with code mode (`search_api` +
`execute`).

Full step-by-step guide (Spanish): https://linkcontrata.lat/ayuda/asistente-ia-mcp-y-api

## Security

Sign-in uses OAuth: your password never reaches the assistant. The assistant can only do
what you could do on the web — every call is scoped to your company and your role/plan, and
a read-only connection cannot create or publish anything. See and disconnect connected
assistants anytime in LinkContrata → *Configuración → Asistentes de IA*.

The npm package `@linkcontrata/mcp` (stdio + personal token) is deprecated.

---

Plugin details and component docs: [`plugin/README.md`](plugin/README.md). License: MIT.
