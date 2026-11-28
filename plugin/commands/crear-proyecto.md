---
description: Create a project in LinkContrata (requires read & write permission). · Crea un proyecto en LinkContrata (requiere permiso de lectura y escritura).
argument-hint: "[nombre del proyecto]"
---

Crea un proyecto en LinkContrata. Nombre/indicación del usuario: **$ARGUMENTS**.

Sigue la skill `crear-proyecto`: reúne los datos mínimos (solo `name` es obligatorio),
confirma con el usuario, y crea con el comando `create_project` vía
`mcp__plugin_linkcontrata_linkcontrata__execute`. Reporta id, nombre y
estado. No inventes presupuestos ni fechas. Responde en el idioma del usuario. / Reply
in the user's language.
