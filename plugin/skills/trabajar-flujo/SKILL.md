---
name: trabajar-flujo
description: Work an AI flow (Flujos con IA) in LinkContrata — do the AI's current step following its instruction, report it with sources, keep going through the AI steps and stop when it is the company's turn. Use it when the user says "trabaja el flujo 14", "work flow 14", "sigue con mi flujo", or wants an offer/publication worked step by step with a record. · Trabaja un flujo con IA de LinkContrata: hace el paso actual de la IA según su instrucción, lo reporta con fuentes, sigue con los pasos de la IA y se detiene cuando le toca a la empresa. Úsala cuando el usuario diga «trabaja el flujo 14», «sigue con mi flujo» o quiera trabajar una oferta o una publicación paso a paso dejando registro.
argument-hint: "[id del flujo]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command, mcp__plugin_linkcontrata_linkcontrata__execute
---

# Trabajar un flujo con IA

Un **flujo** es un trabajo con pasos fijos. Los pasos de la **IA** los haces tú; los de la **empresa** (confirmar,
postular o no, aprobar, marcar enviado o publicado, adjudicar) los decide una persona en la web. LinkContrata impone
el orden y rechaza que un token decida, responda o cancele: no hay comando para eso, a propósito. Lo que el
servidor **no** impide es que uses los comandos del marketplace por fuera del flujo; eso lo prohíbe esta skill
(ver Reglas).

Todo se hace con comandos de LinkContrata: las lecturas (`get_flow`, `list_flows`, `list_my_opportunities`,
`get_public_opportunity`, `search_regulations`…) van por `batch`, y puedes juntar varias en una llamada; lo que
escribe (`start_flow`, `submit_flow_step`, `ask_company`, `create_opportunity`) va por `execute`, de uno en uno. Si un
paso nombra un comando que no has usado, pide su esquema con `describe_command`.

## Bucle

1. **Lee el flujo** con `get_flow` (`id`). Si el usuario no dio un id, usa `list_flows` (`state: "open"`) y pregunta
   cuál. Mira `current_position`, el paso actual (`steps[current_position - 1]`), la `revision` y los últimos
   `events`.
2. **Si el flujo está cerrado** (`done` / `cancelled`) dilo y termina. **Si está `blocked`** (hay una pregunta sin
   responder) di que espera la respuesta de la empresa en la web y termina.
3. **Si el paso actual es de la empresa** (`actor: "company"`): detente. Resume lo hecho y di qué tiene que decidir y
   dónde: `https://linkcontrata.lat/flujos/<id>`. No intentes saltártelo.
4. **Si el paso actual es de la IA** (`actor: "ai"`): haz lo que dice su `instruction` con los comandos que nombra,
   leyendo antes los informes de los pasos anteriores y el historial (`events`): respuestas a tus preguntas y, si el
   paso fue devuelto (`sent_back`), la nota de qué corregir. Para una oportunidad privada usa el campo `opportunity`
   de `get_flow` (no `get_opportunity`); en los pasos de enviar y seguimiento de una oferta privada, la postulación
   de tu empresa está en `own_bid`; para el paso de ofertas recibidas, el campo `bids`.
5. **Repórtalo** con `execute` (`command: "submit_flow_step"`), con estos `args`:
   - `id`, `position` = `current_position` y la `revision` de `get_flow`;
   - `report`: 40 a 8 000 caracteres, en Markdown;
   - `sources`: lista de `{label, url?}` — `url` es opcional (una ficha o un dato que te dio la empresa puede ir solo
     con etiqueta); obligatorias (al menos una) si el paso tiene `needs_sources`;
   - `data` si el paso lo pide: en `shortlist`, `data.candidates` es una **lista** de 1 a 20 objetos
     `{public_opportunity_id, reason}` (ids distintos, el id que usa `get_public_opportunity`); en `prepare`,
     `data.opportunity_id`.
6. **Vuelve al paso 1** con el flujo que devolvió el reporte, hasta llegar a un paso de la empresa o al final.

## Reglas

- **Pregunta en vez de adivinar.** Ante cualquier ambigüedad o dato que no tengas (precios, metrados, plazos
  ofrecidos), ejecuta `ask_company` con `execute` (`question` y, si sirve, hasta 6 `options`) y detente: el flujo queda «Te toca a ti»
  hasta que una persona responda en la web.
- **Datos de la empresa:** `whoami` trae su identidad (razón social, RUC), no su inscripción en el RNP, su capítulo,
  su experiencia facturada ni sus constancias. Para elegibilidad y requisitos pídelos con `ask_company`; nunca los
  supongas.
- **Nunca inventes datos** (montos, RUC, experiencia, artículos de normas). Cita la fuente de cada dato.
- **Mientras trabajas un flujo no hagas ninguna acción del marketplace que le toque a una persona**: no ejecutes
  `submit_bid` (enviar o presentar una postulación), `publish_opportunity` (publicar una oportunidad) ni
  `promote_project_to_marketplace` (promover un proyecto al marketplace) con `execute`, ni la publiques por ningún otro
  camino. El servidor no te lo impide; lo hace una persona en la web («Postular», «Publicar») y después lo marca en
  el flujo. Una oferta a un proceso público se presenta en el SEACE, no en LinkContrata.
- **Paso `prepare`: un solo borrador por flujo.** Antes de crear nada, busca si ya existe uno:
  1. en `get_flow`: el campo `opportunity`; en los `events` de tipo `report`, `body.data.opportunity_id`; en los de
     tipo `sent_back`, `body.cleared.opportunity_id` (o la entrada del paso `prepare` en `body.reset`);
  2. en `list_my_opportunities` (muestra los borradores de tu empresa, solo las 100 más recientes; `list_opportunities`
     no, solo las publicadas), uno en `draft` con el título y el paquete de este flujo.
  Reúsalo (repórtalo en `data.opportunity_id`) **solo si coincide claramente** con el alcance aprobado de este flujo;
  si hay varios candidatos o dudas, pregunta con `ask_company` en vez de elegir. Un borrador ya enlazado a otro flujo
  abierto no sirve: el servidor lo rechaza. Si no hay ninguno, confírmalo con el usuario y crea **uno** en borrador con
  `execute` (`create_opportunity`; `package_id` de `list_packages`, `deadline_at` y el presupuesto aprobado; necesita una cuenta
  de administrador o gestor). Nunca crees un segundo borrador en el mismo intento ni a ciegas: si un intento anterior
  falló o no viste su respuesta (tiempo de espera, respuesta perdida), búscalo en `get_flow` y `list_my_opportunities`
  y usa el que se haya creado; si no lo encuentras, pregunta con `ask_company` antes de crear otro.
- **Si la API dice que el flujo cambió** (`stale`, «vuelve a leerlo»): no reintentes sin más con la `revision` nueva.
  Vuelve a leer `get_flow` y mira los últimos `events`: si alguien devolvió el paso (`sent_back`, aunque sea la misma
  posición), lo reportó desde la web o respondió una pregunta, lee la nota o la respuesta, rehaz lo que cambió y solo
  entonces reporta con la `revision` vigente. Si el paso actual ya es otro, empieza el bucle de nuevo. Si la API dice
  que el paso lo decide la empresa, detente como en el paso 3.
- Para abrir un flujo nuevo ejecuta `start_flow` con `execute` (confirma antes con el usuario); si ya hay uno abierto para esa
  oportunidad la API lo dice: búscalo con `list_flows` (`state: "open"`) y trabaja ese.
- Reportar y preguntar necesitan el conector con permiso de **lectura y escritura**; si falla por permisos, ve la
  skill `autenticacion`.

Responde en el idioma del usuario. / Reply in the user's language.
