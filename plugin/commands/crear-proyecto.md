---
description: Create a project in LinkContrata (requires a read_write token). · Crea un proyecto en LinkContrata (requiere token read_write).
argument-hint: "[nombre del proyecto]"
---

Crea un proyecto en LinkContrata. Nombre/indicación del usuario: **$ARGUMENTS**.

Sigue la skill `crear-proyecto`: reúne los datos mínimos (solo `name` es obligatorio),
confirma con el usuario, y crea con `mcp__linkcontrata__create_project`. Reporta id, nombre y
estado. No inventes presupuestos ni fechas. Responde en el idioma del usuario. / Reply
in the user's language.
