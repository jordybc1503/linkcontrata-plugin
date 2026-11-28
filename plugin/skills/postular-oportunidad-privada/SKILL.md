---
name: postular-oportunidad-privada
description: Prepare and send an offer (bid) for a PRIVATE LinkContrata opportunity — published by a company inside the platform — reading what it asks for, building the price per item and the cover note, then sending it in LinkContrata. Use it when the user wants to apply/bid/quote for a private opportunity or review a draft bid. · Prepara y envía una oferta (postulación) para una oportunidad PRIVADA de LinkContrata — publicada por una empresa dentro de la plataforma —: lee lo que pide, arma los precios por ítem y la nota de presentación y la envía en LinkContrata. Úsala cuando el usuario quiera postular/cotizar a una oportunidad privada o revisar un borrador de postulación.
argument-hint: "[id o URL de la oportunidad privada, o id de la postulación]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command, mcp__plugin_linkcontrata_linkcontrata__execute
---

# Postular a una oportunidad privada (dentro de LinkContrata)

Las oportunidades **privadas** las publica una empresa en LinkContrata y **la oferta se envía en LinkContrata**: la
empresa la recibe y la compara con las demás. (Si es un proceso **público** del Estado — OECE/SEACE, códigos como
`CM-…`, `LP-…` — usa la skill `preparar-propuesta`: esa oferta se presenta en el SEACE.)

## Si hay un flujo con IA

Si el usuario tiene (o quiere) un flujo con IA para esta oportunidad, usa la skill `trabajar-flujo` (`start_flow` para
abrirlo): cada paso queda registrado con su informe y sus fuentes, y las decisiones las toma la empresa en la web.
Dentro de un flujo no ejecutes `submit_bid` (el servidor no lo impide): la postulación la envía una persona con
**Postular**.

Todo se hace con comandos: las lecturas (`get_opportunity`, `list_opportunities`, `list_recommendations`, `whoami`,
`list_bids`, `get_bid`) van por `batch` —puedes juntar varias en una llamada— y `submit_bid` por `execute`. Si no
conoces los argumentos de un comando, pídelos con `describe_command`.

## Flujo

1. **Identifica la oportunidad.** Id o URL `…/marketplace/oportunidades/12-…` (el id es el número inicial). Si el
   usuario no la tiene, ofrece sus recomendaciones (`list_recommendations`) o busca con `list_opportunities`
   (`type: "private"`). Lee la ficha con `get_opportunity`: empresa, proyecto, paquete, presupuesto, modalidad,
   experiencia pedida, fecha de cierre y si sigue recibiendo ofertas.
2. **Plazo y condiciones.** Di cuánto falta para el cierre (hora de Lima). Si ya cerró, no recibe ofertas o es de la
   propia empresa del usuario (`whoami`), dilo y detente: no se puede postular a una oportunidad propia.
3. **Qué hay que cotizar.** Resume lo que pide la descripción (alcance, experiencia, plazos, condiciones) y el
   presupuesto publicado. La ficha **no trae las partidas** del paquete: se ven al cargar los precios en la
   postulación (paso 5). Pide al usuario que te las pegue para cotizarlas, o arma la oferta por el alcance descrito.
   Señala lo que falte o sea ambiguo para que el usuario lo pregunte a la empresa.
4. **Arma la oferta con el usuario** (en Markdown):
   - tabla de precios: ítem · cantidad · unidad · **precio unitario [completar]** · total — y el total general;
   - plazo de entrega/ejecución, validez de la oferta, condiciones de pago, garantías (lo que el usuario confirme);
   - **nota de presentación** breve para la empresa (quiénes son, experiencia relevante, por qué cumplen).
   Usa solo datos reales del usuario y de la ficha; lo que no sepas va como **[completar]**. Si el monto queda fuera
   del presupuesto publicado, avísalo.
5. **Cárgala en LinkContrata.** El borrador se crea en la web: botón **Postular** de la oportunidad →
   `https://linkcontrata.lat/marketplace/opportunities/<id>/postular` (datos de contacto y la nota) → en la
   postulación, agrega los **precios por ítem**. Indica el enlace exacto.
6. **Envíala.** Cuando el usuario confirme que el borrador está completo (`get_bid` para revisarlo: ítems, total,
   contacto), envíala con `execute` (`submit_bid`) **solo con su confirmación explícita** — enviada, la empresa ya la ve.
   Después puede seguir su estado con `list_bids` / `get_bid` (enviada, en revisión, aceptada, rechazada).

## Notas

- `submit_bid` necesita que el usuario haya autorizado el conector con permiso de **lectura y escritura**; si falla
  por permisos, ve la skill `autenticacion`.
- No inventes precios, experiencia ni certificaciones: pregunta o deja **[completar]**.
