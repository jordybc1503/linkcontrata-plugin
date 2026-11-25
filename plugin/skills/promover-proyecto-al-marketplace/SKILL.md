---
name: promover-proyecto-al-marketplace
description: Promote a LinkContrata project to the marketplace (turn it into a public opportunity to receive bids) in one step. Use it when the user asks to publish/promote/expose/list a project to the marketplace, or to "find suppliers/contractors" for one of their projects. · Promueve un proyecto de LinkContrata al marketplace (lo convierte en una oportunidad pública para recibir pujas) en un solo paso. Úsala cuando el usuario pida publicar/promocionar/exponer/sacar al marketplace un proyecto, o "buscar proveedores/contratistas" para un proyecto suyo.
argument-hint: "[id-o-nombre del proyecto]"
allowed-tools: mcp__linkcontrata__whoami, mcp__linkcontrata__list_projects, mcp__linkcontrata__get_project, mcp__linkcontrata__promote_project_to_marketplace, mcp__linkcontrata__get_opportunity
---

# Promover un proyecto al marketplace

Operación de **un solo paso** respaldada por `mcp__linkcontrata__promote_project_to_marketplace`:
crea (o reutiliza) el paquete de contratación del proyecto, deriva la oportunidad y la
**publica** en el marketplace. Es **atómica** e **idempotente** (promover dos veces no
duplica). Requiere permiso de **lectura y escritura**.

> Marketplace aquí = el **marketplace de negocio de LinkContrata** (donde otras empresas ven
> la oportunidad y postulan), NO el marketplace de plugins de Claude Code.

## Flujo

1. **Identifica el proyecto.** Si el usuario da un id, úsalo. Si da un nombre, usa
   `list_projects` para encontrar el id; si hay ambigüedad, pregunta cuál.
2. **Confirma antes de publicar.** Publicar hace la oportunidad **visible públicamente** y
   puede tener costo de plan. Resume al usuario qué se publicará (título, descripción,
   cierre, presupuesto) y pide OK. Para solo **preparar un borrador** sin publicar, pasa
   `publish: false`.
3. **Promueve** con `promote_project_to_marketplace`:
   - `project_id` (obligatorio).
   - Overrides opcionales (si no, se derivan del proyecto): `title`, `description`,
     `deadline_at` (ISO; default 30 días si publicas sin fecha), `budget_min`/`budget_max`
     (default: presupuesto total del proyecto), `category_name`, `location_name`,
     `contract_type` (`suma_alzada` | `precios_unitarios` | `llave_en_mano` |
     `administracion` | `mixto`).
   - `publish` (default `true`).
4. **Reporta el resultado:** estado de la oportunidad (`published`/`draft`), su id y, si
   publicó, su enlace público (`/marketplace/oportunidades/<id>`).

## Manejo de errores (importante)

- **`402 plan_limit`** al publicar → el plan del usuario **no habilita publicar en el
  marketplace**. Ofrécele dos caminos: (a) mejorar el plan; (b) reintentar con
  `publish: false` para dejar la oportunidad en **borrador** (no consume el gate de
  publicación) y publicarla luego al mejorar el plan.
- "Permiso insuficiente: esta conexión es de solo lectura" → reconectar aceptando lectura y escritura.
- `402` por **cuota mensual de paquetes** → alcanzó el límite de paquetes del mes.
- `422 validation` → muestra `details` y corrige (p. ej. `deadline_at` debe ser futura).

## Idempotencia

Si el proyecto ya fue promovido, la herramienta devuelve la **misma** oportunidad (no crea
duplicados). Es seguro reintentar.
