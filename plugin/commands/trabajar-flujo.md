---
description: Work an AI flow (Flujos con IA) — do the AI's steps with sources and stop when it is the company's turn. · Trabaja un flujo con IA: hace los pasos de la IA con fuentes y se detiene cuando le toca a la empresa.
argument-hint: "[id del flujo]"
---

Trabaja el flujo con IA **$ARGUMENTS** de LinkContrata.

Sigue la skill `trabajar-flujo`: lee el flujo con `mcp__plugin_linkcontrata_linkcontrata__get_flow`, haz el paso actual
de la IA según su `instruction`, repórtalo con `mcp__plugin_linkcontrata_linkcontrata__submit_flow_step` (fuentes y la
`revision` de `get_flow`) y sigue con el siguiente paso de la IA. Detente cuando el paso sea de la empresa y di qué debe
decidir en `https://linkcontrata.lat/flujos/<id>`. Ante cualquier duda pregunta con
`mcp__plugin_linkcontrata_linkcontrata__ask_company`. Mientras trabajas el flujo no envíes postulaciones
(`submit_bid`) ni publiques o promuevas oportunidades (`publish_opportunity`, `promote_project_to_marketplace`): el
servidor no lo impide, pero eso lo hace una persona en la web. Si no hay id, lista los abiertos con `mcp__plugin_linkcontrata_linkcontrata__list_flows` y pregunta cuál.

Responde en el idioma del usuario. / Reply in the user's language.
