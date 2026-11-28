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
         (5 tools → commands · MCP Apps)
```

## What's inside

| Component | Files | Purpose |
|---|---|---|
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | The remote server `https://linkcontrata.lat/mcp` (sign-in with LinkContrata): five tools — `list_commands`, `describe_command`, `batch` (reads), `show_command` (MCP Apps screens) and `execute` (writes) — that run every LinkContrata operation as a **command**. |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `preparar-propuesta` (public offers), `postular-oportunidad-privada` (private offers), `trabajar-flujo` (AI flows), `autenticacion`. |
| **Commands** | `commands/*.md` | Shortcuts: `/linkcontrata:estado`, `/linkcontrata:preparar-oferta`, `/linkcontrata:trabajar-flujo`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
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

## Preparing offers

`/linkcontrata:preparar-oferta <code, id or URL>` (or just *"prepare my offer for CM-658-2026-SERVIR"*):

- **Public process (OECE/SEACE)** → skill `preparar-propuesta`: reads the process with `get_public_opportunity`
  (timeline, items, documents and the Bases text), gives the **requirements checklist** from the Bases, checks
  **eligibility** against the regulations (RNP, impediments), drafts the **quotation, cover letter and sworn
  declarations** with your company data (unknowns as `[completar]`) and a final checklist. **You present it in the
  SEACE** — LinkContrata does not submit public offers.
- **Private opportunity (published by a company in LinkContrata)** → skill `postular-oportunidad-privada`: what
  is asked, prices per item and a cover note; you create the draft with **Postular** on the web and the assistant
  sends it with `submit_bid` only after your explicit confirmation.

## AI flows (Flujos con IA)

A **flow** is a piece of company work with fixed steps (find opportunities, offer to a public process, offer to a
private opportunity, publish an opportunity). The AI does its steps and leaves a report with sources; a person decides
the company steps in the web (go / no-go, approve, mark as sent or published, award). Say *"Trabaja el flujo 14"* or
run `/linkcontrata:trabajar-flujo 14`: skill `trabajar-flujo` reads the flow (`get_flow`), does the current AI step,
reports it (`submit_flow_step`), asks the company when something is unclear (`ask_company`) and stops when it is the
company's turn. No command can decide a company step (the server refuses it from a token). The server does not stop the marketplace
commands (send a bid, publish or promote an opportunity) outside a flow; the skill tells the assistant not to use them
while working one — a person does those on the web.
Guide: https://linkcontrata.lat/ayuda/flujos-con-ia

## Marketplace: two different things

- **Claude Code marketplace** = the plugin catalog (`.claude-plugin/marketplace.json`),
  how you distribute/install THIS plugin.
- **LinkContrata marketplace** = the business marketplace where opportunities are
  published and companies bid. "Promote to the marketplace" refers to **this one** (the
  `promote_project_to_marketplace` command).

## Philosophy (toward microservices)

This feature is the **start** of moving LinkContrata toward a more service-oriented
architecture under an agentic philosophy: the LinkContrata backend exposes its capability as a
**versioned API** (`/api/v1/*`), the **MCP server** translates it into commands behind five vendor-neutral
tools, and this **plugin** is the control plane for agents. As parts of the monolith are
extracted into services, the contract toward agents (the MCP commands) can stay stable while
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
| **MCP server** | `.claude-plugin/plugin.json` → `mcpServers` | El servidor remoto `https://linkcontrata.lat/mcp` (inicio de sesión con LinkContrata): cinco herramientas — `list_commands`, `describe_command`, `batch` (lecturas), `show_command` (pantallas MCP Apps) y `execute` (escrituras) — que ejecutan cada operación de LinkContrata como un **comando**. |
| **Skills** | `skills/*/SKILL.md` | Workflows: `crear-proyecto`, `promover-proyecto-al-marketplace`, `buscar-normativa-regulatoria`, `preparar-propuesta` (ofertas públicas), `postular-oportunidad-privada` (ofertas privadas), `trabajar-flujo` (flujos con IA), `autenticacion`. |
| **Comandos** | `commands/*.md` | Atajos: `/linkcontrata:estado`, `/linkcontrata:preparar-oferta`, `/linkcontrata:trabajar-flujo`, `/linkcontrata:crear-proyecto`, `/linkcontrata:promover-al-marketplace`, `/linkcontrata:buscar-normativa`. |
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

### Preparar ofertas

`/linkcontrata:preparar-oferta <código, id o URL>` (o simplemente *«prepara mi oferta para CM-658-2026-SERVIR»*):

- **Proceso público (OECE/SEACE)** → skill `preparar-propuesta`: lee el proceso con `get_public_opportunity`
  (cronograma, ítems, documentos y el texto de las Bases), te da la **lista de requisitos** de las Bases, revisa la
  **elegibilidad** con la normativa (RNP, impedimentos), redacta la **cotización, la carta de presentación y las
  declaraciones juradas** con los datos de tu empresa (lo desconocido va como `[completar]`) y un checklist final.
  **La presentas tú en el SEACE**: LinkContrata no envía ofertas públicas.
- **Oportunidad privada (publicada por una empresa en LinkContrata)** → skill `postular-oportunidad-privada`: qué
  pide, precios por ítem y nota de presentación; creas el borrador con **Postular** en la web y el asistente la
  envía con `submit_bid` solo con tu confirmación explícita.

### Flujos con IA

Un **flujo** es un trabajo de la empresa con pasos fijos (buscar oportunidades, oferta a un proceso público, oferta a
una oportunidad privada, publicar una oportunidad). La IA hace sus pasos y deja un informe con fuentes; una persona
decide los pasos de la empresa en la web (postular o no, aprobar, marcar enviado o publicado, adjudicar). Di
*«Trabaja el flujo 14»* o usa `/linkcontrata:trabajar-flujo 14`: la skill `trabajar-flujo` lee el flujo (`get_flow`),
hace el paso actual de la IA, lo reporta (`submit_flow_step`), pregunta a la empresa si algo no está claro
(`ask_company`) y se detiene cuando le toca a la empresa. Ningún comando puede decidir un paso de la empresa (el
servidor lo rechaza desde un token). El servidor no impide usar los comandos del marketplace (enviar una postulación,
publicar o promover una oportunidad) por fuera del flujo; la skill le indica al asistente que no lo haga mientras
trabaja uno: eso lo hace una persona en la web. Guía: https://linkcontrata.lat/ayuda/flujos-con-ia

### Marketplace: dos cosas distintas

- **Marketplace de Claude Code** = el catálogo de plugins (`.claude-plugin/marketplace.json`),
  cómo distribuyes/instalas ESTE plugin.
- **Marketplace de LinkContrata** = el marketplace de negocio donde se publican oportunidades
  y las empresas postulan. "Promover al marketplace" se refiere a **este** (el comando
  `promote_project_to_marketplace`).

### Filosofía (hacia microservicios)

Esta feature es el **inicio** de mover LinkContrata hacia una arquitectura más orientada a
servicios bajo una filosofía agéntica: el backend de LinkContrata expone su capacidad como una **API
versionada** (`/api/v1/*`), el **MCP server** la traduce a comandos detrás de cinco herramientas vendor-neutral, y
este **plugin** es el plano de control para agentes. A medida que partes del monolito se
extraigan a servicios, el contrato hacia los agentes (los comandos MCP) puede
permanecer estable mientras el backend evoluciona detrás. **No** migra nada todavía: monta
la costura.
