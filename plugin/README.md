# LinkContrata plugin (Claude Code)

**Claude Code** plugin to control LinkContrata from your AI assistant: **create
projects**, **promote them to the marketplace** and **search the Peruvian regulatory
documentation** — all with **your authentication** and **your permissions** (the
platform enforces the same per-company isolation and the same roles/plan as the web app).

It is LinkContrata's **agentic control layer**: it bundles skills + commands + agents +
hooks around LinkContrata's vendor-neutral remote **MCP server** (`https://linkcontrata.lat/mcp`), which
also works with other MCP-compatible assistants (e.g. ChatGPT via an MCP connector).

*(Versión en español más abajo — [ver §Español](#español).)*

```
Claude Code  ── "linkcontrata" plugin ──┐
ChatGPT / other ── MCP connector ────────┤
                                         ▼
         https://linkcontrata.lat/mcp  ──OAuth (sign in)──►  LinkContrata API /api/v1/*  (permissions + tenant)
         (tools · code mode · MCP Apps)
```

## What's inside

| Component | Files | Purpose |
|---|---|---|
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | The remote server `https://linkcontrata.lat/mcp` (sign-in with LinkContrata): `mcp__plugin_linkcontrata_linkcontrata__*` tools (read + write), code mode (`search_api` + `execute`) and MCP Apps screens. |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `autenticacion`. |
| **Commands** | `commands/*.md` | Shortcuts: `/linkcontrata:estado`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
| **Agents** | `agents/*.md` | `operador-linkcontrata` (management, read+write) and `analista-regulatorio` (read-only). |
| **Hooks** | `hooks/hooks.json` + `hooks/*.sh` | Audit (PostToolUse logs usage) and session context (SessionStart). |

## Authentication: sign in with LinkContrata

No token to paste. The plugin connects to the remote MCP server `https://linkcontrata.lat/mcp`, which uses
OAuth: the first time, run `/mcp` → **linkcontrata** → **Authenticate**, sign in with your LinkContrata
account in the browser and press **Autorizar**. You choose read-only or read & write on that screen; the
session renews itself. The API enforces your role, plan and company isolation exactly like the web, and you
can disconnect the assistant any time in LinkContrata → *Settings → Asistentes de IA*. Error
troubleshooting: the `autenticacion` skill.

## Installation

```bash
# Add this repo as a plugin marketplace, then install
/plugin marketplace add jordybc1503/linkcontrata-plugin
/plugin install linkcontrata@linkcontrata
```

Reload (`/reload-plugins`), authenticate with `/mcp`, and try: *"search regulations about appeal deadlines
for the award"* or *"promote my project 12 to the marketplace"*.

> Without the plugin: `claude mcp add --transport http linkcontrata https://linkcontrata.lat/mcp`. The npm
> package `@linkcontrata/mcp` (stdio + `LINKCONTRATA_TOKEN`) is deprecated in favour of this remote server.

## Marketplace: two different things

- **Claude Code marketplace** = the plugin catalog (`.claude-plugin/marketplace.json`),
  how you distribute/install THIS plugin.
- **LinkContrata marketplace** = the business marketplace where opportunities are
  published and companies bid. "Promote to the marketplace" refers to **this one** (the
  `promote_project_to_marketplace` tool).

## Philosophy (toward microservices)

This feature is the **start** of moving LinkContrata toward a more service-oriented
architecture under an agentic philosophy: the LinkContrata backend exposes its capability as a
**versioned API** (`/api/v1/*`), the **MCP server** translates it into vendor-neutral
tools, and this **plugin** is the control plane for agents. As parts of the monolith are
extracted into services, the contract toward agents (the MCP tools) can stay stable while
the backend evolves behind it. It does **not** migrate anything yet: it lays the seam.

---

## Español

Plugin de **Claude Code** para controlar LinkContrata desde tu asistente de IA: **crea
proyectos**, **promuévelos al marketplace** y **busca en la documentación regulatoria**
peruana — todo con **tu autenticación** y **tus permisos** (la plataforma aplica el mismo
aislamiento por empresa y los mismos roles/plan que la web).

Es la **capa de control agéntica** de LinkContrata: empaqueta skills + comandos + agentes +
hooks alrededor del **servidor MCP** remoto y vendor-neutral de LinkContrata (`https://linkcontrata.lat/mcp`),
que también funciona con otros asistentes compatibles con MCP (p. ej. ChatGPT vía conector MCP).

### Qué trae

| Componente | Archivos | Para qué |
|---|---|---|
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | El servidor remoto `https://linkcontrata.lat/mcp` (inicio de sesión con LinkContrata): herramientas `mcp__plugin_linkcontrata_linkcontrata__*` (lectura + escritura), code mode (`search_api` + `execute`) y pantallas MCP Apps. |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `autenticacion`. |
| **Comandos** | `commands/*.md` | Atajos: `/linkcontrata:estado`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
| **Agentes** | `agents/*.md` | `operador-linkcontrata` (gestión, lectura+escritura) y `analista-regulatorio` (solo lectura). |
| **Hooks** | `hooks/hooks.json` + `hooks/*.sh` | Auditoría (PostToolUse registra el uso) y contexto de sesión (SessionStart). |

### Autenticación: inicia sesión con LinkContrata

Sin tokens que copiar. El plugin se conecta al servidor MCP remoto `https://linkcontrata.lat/mcp`, que usa
OAuth: la primera vez ejecuta `/mcp` → **linkcontrata** → **Authenticate**, inicia sesión con tu cuenta de
LinkContrata en el navegador y pulsa **Autorizar**. En esa pantalla eliges solo lectura o lectura y escritura;
la sesión se renueva sola. El API aplica tu rol, tu plan y el aislamiento por empresa igual que la web, y
puedes desconectar el asistente cuando quieras en LinkContrata → *Configuración → Asistentes de IA*.
Diagnóstico de errores: la skill `autenticacion`.

### Instalación

```bash
# Añade este repo como marketplace de plugins y luego instala
/plugin marketplace add jordybc1503/linkcontrata-plugin
/plugin install linkcontrata@linkcontrata
```

Recarga (`/reload-plugins`), autentícate con `/mcp` y prueba: *"busca normas sobre plazos de apelación de la
buena pro"* o *"promueve mi proyecto 12 al marketplace"*.

> Sin el plugin: `claude mcp add --transport http linkcontrata https://linkcontrata.lat/mcp`. El paquete npm
> `@linkcontrata/mcp` (stdio + `LINKCONTRATA_TOKEN`) queda obsoleto en favor de este servidor remoto.

### Marketplace: dos cosas distintas

- **Marketplace de Claude Code** = el catálogo de plugins (`.claude-plugin/marketplace.json`),
  cómo distribuyes/instalas ESTE plugin.
- **Marketplace de LinkContrata** = el marketplace de negocio donde se publican oportunidades
  y las empresas postulan. "Promover al marketplace" se refiere a **este** (la herramienta
  `promote_project_to_marketplace`).

### Filosofía (hacia microservicios)

Esta feature es el **inicio** de mover LinkContrata hacia una arquitectura más orientada a
servicios bajo una filosofía agéntica: el backend de LinkContrata expone su capacidad como una **API
versionada** (`/api/v1/*`), el **MCP server** la traduce a herramientas vendor-neutral, y
este **plugin** es el plano de control para agentes. A medida que partes del monolito se
extraigan a servicios, el contrato hacia los agentes (las herramientas MCP) puede
permanecer estable mientras el backend evoluciona detrás. **No** migra nada todavía: monta
la costura.
