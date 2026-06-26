---
name: crear-proyecto
description: Create a project in LinkContrata from the assistant. Use it when the user asks to create/register/add a project (work, contract, initiative) in their LinkContrata account. · Crea un proyecto en LinkContrata desde el asistente. Úsala cuando el usuario pida crear/registrar/dar de alta un proyecto (obra, contrato, iniciativa) en su cuenta de LinkContrata.
argument-hint: "[nombre del proyecto]"
allowed-tools: mcp__linkcontrata__whoami, mcp__linkcontrata__list_projects, mcp__linkcontrata__create_project
---

# Crear un proyecto

Crea un `Projects::Project` en la empresa del usuario vía `mcp__linkcontrata__create_project`.
Requiere un token con scope **read_write** (si falta, el hook lo avisa; ver la skill
[[autenticacion]]).

## Flujo

1. **Reúne los datos mínimos.** Solo `name` es obligatorio. Campos opcionales útiles:
   `description`, `status` (`draft` | `active` | `on_hold` | `completed` | `cancelled`),
   `priority` (`low` | `medium` | `high` | `urgent`), `code`, `location`,
   `start_date` / `end_date` (ISO `YYYY-MM-DD`). Si el usuario no da estado, deja que el
   servidor use su default; no inventes presupuestos ni fechas.
2. **Crea** con `create_project`. Pasa solo los campos que tengas; no rellenes con valores
   ficticios.
3. **Confirma** al usuario el proyecto creado: id, nombre y estado. Si después quiere
   exponerlo a proveedores, encadena con la skill [[promover-proyecto-al-marketplace]].

## Errores frecuentes

- `402 plan_limit` → alcanzó el límite de proyectos de su plan (debe mejorar el plan).
- `403 insufficient_scope` → su token es de solo lectura.
- `422 validation` → datos inválidos; muestra los `details` del error y corrige.

> No crees proyectos por tu cuenta: confirma nombre y datos clave con el usuario antes de
> llamar a la herramienta de escritura.
