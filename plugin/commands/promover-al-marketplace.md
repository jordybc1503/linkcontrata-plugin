---
description: Promote a project to the LinkContrata marketplace (publishes it as an opportunity). Requires read & write permission. · Promueve un proyecto al marketplace de LinkContrata (lo publica como oportunidad). Requiere permiso de lectura y escritura.
argument-hint: "[id-o-nombre del proyecto]"
---

Promueve un proyecto al marketplace de LinkContrata. Proyecto indicado: **$ARGUMENTS**.

Sigue la skill `promover-proyecto-al-marketplace`:
1. Identifica el proyecto (por id; si es un nombre, resuélvelo con el comando `list_projects` vía
   `mcp__plugin_linkcontrata_linkcontrata__batch`).
2. Confirma con el usuario qué se publicará (publicar lo hace **visible públicamente** y
   puede tener costo de plan); ofrece `publish: false` para dejar un borrador.
3. Ejecuta el comando `promote_project_to_marketplace` con `mcp__plugin_linkcontrata_linkcontrata__execute` y reporta estado, id y enlace
   público de la oportunidad.

Si recibes `402 plan_limit`, explica que el plan no habilita publicar y ofrece mejorar el
plan o reintentar con `publish: false`. Responde en el idioma del usuario. / Reply in the
user's language.
