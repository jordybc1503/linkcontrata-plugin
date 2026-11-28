---
description: Work an AI flow (Flujos con IA) — do the AI's steps with sources and stop when it is the company's turn. · Trabaja un flujo con IA: hace los pasos de la IA con fuentes y se detiene cuando le toca a la empresa.
argument-hint: "[id del flujo]"
---

Trabaja el flujo con IA **$ARGUMENTS** de LinkContrata.

Sigue la skill `trabajar-flujo`: lee el flujo con el comando `get_flow` (vía `mcp__plugin_linkcontrata_linkcontrata__batch`),
haz el paso actual de la IA según su `instruction`, repórtalo con el comando `submit_flow_step` (vía
`mcp__plugin_linkcontrata_linkcontrata__execute`; fuentes y la `revision` de `get_flow`) y sigue con el siguiente paso de
la IA. Detente cuando el paso sea de la empresa y di qué debe decidir en `https://linkcontrata.lat/flujos/<id>`. Ante
cualquier duda pregunta con el comando `ask_company` (vía `execute`). Mientras trabajas el flujo no ejecutes `submit_bid`,
`publish_opportunity` ni `promote_project_to_marketplace`: el servidor no lo impide, pero eso lo hace una persona en la
web. Si no hay id, lista los abiertos con el comando `list_flows` (vía `batch`) y pregunta cuál.

Responde en el idioma del usuario. / Reply in the user's language.
