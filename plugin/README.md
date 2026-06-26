# LinkContrata plugin (Claude Code)

**Claude Code** plugin to control LinkContrata from your AI assistant: **create
projects**, **promote them to the marketplace** and **search the Peruvian regulatory
documentation** — all with **your authentication** and **your permissions** (the
platform enforces the same per-company isolation and the same roles/plan as the web app).

It is LinkContrata's **agentic control layer**: it bundles skills + commands + agents +
hooks around the vendor-neutral **MCP server** (`@linkcontrata/mcp`), which also works
with other MCP-compatible assistants (e.g. ChatGPT via an MCP connector).

*(Versión en español más abajo — [ver §Español](#español).)*

```
Claude Code  ── "linkcontrata" plugin ──┐
ChatGPT / other ── MCP connector ────────┤
                                         ▼
                       MCP server  ──Bearer lct_…──►  Rails /api/v1/*  (Pundit + tenant)
                       (@linkcontrata/mcp)
```

## What's inside

| Component | Files | Purpose |
|---|---|---|
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | Exposes 20 `mcp__linkcontrata__*` tools (read + write). |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `autenticacion`. |
| **Commands** | `commands/*.md` | Shortcuts: `/linkcontrata:estado`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
| **Agents** | `agents/*.md` | `operador-linkcontrata` (management, read+write) and `analista-regulatorio` (read-only). |
| **Hooks** | `hooks/hooks.json` + `hooks/*.sh` | Auth (PreToolUse requires a token on writes), audit (PostToolUse logs usage) and session context (SessionStart). |

## Authentication (required)

The plugin **asks for the token at install time** (a sensitive `userConfig` field, stored
in the keychain):

- **LinkContrata API token** — generate it in LinkContrata → *Settings → API Tokens*.
  Scope **`read`** for read-only; **`read_write`** to create projects / promote to the
  marketplace / submit bids.
- **LinkContrata URL** — defaults to `https://linkcontrata.lat`.

In addition, the `require-auth.sh` hook **blocks any write** when there is no token, and
the Rails API rejects missing/invalid tokens (401) or read-only tokens on mutations
(403). Three layers of defense. Error troubleshooting: the `autenticacion` skill.

## Installation

```bash
# Add this repo as a plugin marketplace, then install
/plugin marketplace add jordybc1503/LinkContratav2
/plugin install linkcontrata@linkcontrata
```

Claude Code will ask for the token and URL. Reload (`/reload-plugins`) and try:
*"search regulations about appeal deadlines for the award"* or *"promote my project 12 to
the marketplace"*.

> The plugin's `mcpServers` launches the server with `npx -y @linkcontrata/mcp`, which is
> **published on npm** — no extra setup. (To run a local build instead, point the
> `mcpServers` command at `node <abs-path>/LinkContratav2/mcp/dist/index.js` after running
> `npm install && npm run build` in `mcp/`.)

## Marketplace: two different things

- **Claude Code marketplace** = the plugin catalog (`.claude-plugin/marketplace.json`),
  how you distribute/install THIS plugin.
- **LinkContrata marketplace** = the business marketplace where opportunities are
  published and companies bid. "Promote to the marketplace" refers to **this one** (the
  `promote_project_to_marketplace` tool).

## Philosophy (toward microservices)

This feature is the **start** of moving LinkContrata toward a more service-oriented
architecture under an agentic philosophy: the Rails monolith exposes its capability as a
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
hooks alrededor del **servidor MCP** vendor-neutral (`@linkcontrata/mcp`), que también
funciona con otros asistentes compatibles con MCP (p. ej. ChatGPT vía conector MCP).

### Qué trae

| Componente | Archivos | Para qué |
|---|---|---|
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | Expone 20 herramientas `mcp__linkcontrata__*` (lectura + escritura). |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `autenticacion`. |
| **Comandos** | `commands/*.md` | Atajos: `/linkcontrata:estado`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
| **Agentes** | `agents/*.md` | `operador-linkcontrata` (gestión, lectura+escritura) y `analista-regulatorio` (solo lectura). |
| **Hooks** | `hooks/hooks.json` + `hooks/*.sh` | Autenticación (PreToolUse exige token en escrituras), auditoría (PostToolUse registra el uso) y contexto de sesión (SessionStart). |

### Autenticación (obligatoria)

El plugin **pide el token al instalarse** (campo `userConfig` sensible, guardado en keychain):

- **Token de API de LinkContrata** — genéralo en LinkContrata → *Configuración → Tokens de
  API*. Scope **`read`** para solo lectura; **`read_write`** para crear proyectos / promover
  al marketplace / pujar.
- **URL de LinkContrata** — default `https://linkcontrata.lat`.

Además, el hook `require-auth.sh` **bloquea cualquier escritura** si no hay token, y el API
de Rails rechaza tokens ausentes/inválidos (401) o de solo lectura en mutaciones (403). Tres
capas de defensa. Diagnóstico de errores: skill `autenticacion`.

### Instalación

```bash
# Añade este repo como marketplace de plugins y luego instala
/plugin marketplace add jordybc1503/LinkContratav2
/plugin install linkcontrata@linkcontrata
```

Claude Code te pedirá el token y la URL. Recarga (`/reload-plugins`) y prueba:
*"busca normas sobre plazos de apelación de la buena pro"* o *"promueve mi proyecto 12 al
marketplace"*.

> El `mcpServers` del plugin lanza el servidor con `npx -y @linkcontrata/mcp`, que ya está
> **publicado en npm** — sin pasos extra. (Para usar un build local, apunta el comando a
> `node <ruta-abs>/LinkContratav2/mcp/dist/index.js` tras correr `npm install && npm run
> build` en `mcp/`.)

### Marketplace: dos cosas distintas

- **Marketplace de Claude Code** = el catálogo de plugins (`.claude-plugin/marketplace.json`),
  cómo distribuyes/instalas ESTE plugin.
- **Marketplace de LinkContrata** = el marketplace de negocio donde se publican oportunidades
  y las empresas postulan. "Promover al marketplace" se refiere a **este** (la herramienta
  `promote_project_to_marketplace`).

### Filosofía (hacia microservicios)

Esta feature es el **inicio** de mover LinkContrata hacia una arquitectura más orientada a
servicios bajo una filosofía agéntica: el monolito Rails expone su capacidad como una **API
versionada** (`/api/v1/*`), el **MCP server** la traduce a herramientas vendor-neutral, y
este **plugin** es el plano de control para agentes. A medida que partes del monolito se
extraigan a servicios, el contrato hacia los agentes (las herramientas MCP) puede
permanecer estable mientras el backend evoluciona detrás. **No** migra nada todavía: monta
la costura.
