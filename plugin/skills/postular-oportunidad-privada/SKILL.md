---
name: postular-oportunidad-privada
description: Prepare and send an offer (bid) for a PRIVATE LinkContrata opportunity — published by a company inside the platform — reading what it asks for, pricing each item with the user, saving the draft and sending it in LinkContrata. Use it when the user wants to apply/bid/quote for a private opportunity or review a draft bid. · Prepara y envía una oferta (postulación) para una oportunidad PRIVADA de LinkContrata — publicada por una empresa dentro de la plataforma —: lee lo que pide, cotiza cada partida con el usuario, guarda el borrador y la envía en LinkContrata. Úsala cuando el usuario quiera postular/cotizar a una oportunidad privada o revisar un borrador de postulación.
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

Todo se hace con comandos. Las lecturas van por `batch` (puedes juntar varias en una llamada): `get_opportunity`,
`list_opportunity_quote_items`, `list_opportunities`, `list_recommendations`, `whoami`, `list_bids`, `get_bid`,
`list_bid_items`. Las escrituras van por `execute`, de una en una y con la confirmación del usuario: `save_bid_draft`
(guarda el borrador) y `submit_bid` (lo envía). Si no conoces los argumentos de un comando, pídelos con
`describe_command`.

## Flujo

1. **Identifica la oportunidad.** Id o URL `…/marketplace/oportunidades/12-…` (el id es el número inicial). Si el
   usuario no la tiene, ofrece sus recomendaciones (`list_recommendations`) o busca con `list_opportunities`
   (`type: "private"`).
2. **Léela** en un solo `batch`: `get_opportunity` (empresa, proyecto, paquete, presupuesto, modalidad, experiencia,
   fecha de cierre, `can_receive_bids`) y `list_opportunity_quote_items` (las partidas a cotizar: `package_item_id`,
   código, descripción, cantidad y unidad; en `meta`: `can_receive_bids`, `own_opportunity` y `my_bid` si ya hay una
   postulación de tu empresa). Si es de la propia empresa (`own_opportunity`), ya no recibe postulaciones, o `my_bid`
   ya está enviada, dilo y detente. Si `my_bid` es un borrador, léelo con `get_bid` y `list_bid_items` y continúa
   desde ahí. Una oportunidad por invitación a la que no invitaron a la empresa no aparece (404).
3. **Plazo.** Di cuánto falta para el cierre (hora de Lima). Lo que pide la descripción (alcance, experiencia,
   plazos, condiciones) resúmelo y señala lo ambiguo para que el usuario lo pregunte a la empresa.
4. **Propón los precios al usuario** (en Markdown), partida por partida: código · descripción · cantidad · unidad ·
   **precio unitario** · total — y el total general; más plazo de entrega por partida si aplica y una **nota de
   presentación** breve (quiénes son, experiencia relevante, condiciones: validez, pago, garantías). Usa solo datos
   reales del usuario (pregúntale sus precios o su base de costos); lo que no sepas va como **[completar]** y no se
   guarda hasta que el usuario lo dé. La ficha no trae el presupuesto por partida del comprador: compara solo con el
   presupuesto total publicado y avisa si el total queda fuera.
5. **Guarda el borrador** con su acuerdo: `execute` → `save_bid_draft` con `opportunity_id`, `notes`, el contacto si
   el usuario quiere otro (si no, se usan el nombre de su empresa y su email) e `items`
   `[{package_item_id, unit_price, quantity, delivery_days, notes}]` (quantity por defecto la que pide el comprador).
   Es una sola transacción: si una partida no es válida no se guarda nada y el error dice cuál (`items[2].unit_price`)
   — corrígela y vuelve a guardar. Puedes guardar varias veces (actualiza las partidas que envías; las demás quedan).
   La respuesta trae el `total_amount`, las partidas y `unpriced_items_count` (las que siguen sin precio): muéstrale
   el resumen. El borrador también se ve y edita en la web: `https://linkcontrata.lat/marketplace/bids/<id>`.
6. **Confirma y envía.** Pregunta explícitamente si la envía (enviada, la empresa ya la ve y no se puede editar). Con
   su «sí», `execute` → `submit_bid` con el `id` de la puja. Devuelve `status: "submitted"` y `submitted_at`; si se
   repite no duplica nada. Un 422 trae el motivo (la oportunidad cerró, la puja no cotiza ninguna partida, falta el
   contacto): explícaselo. Después puede seguir su estado con `list_bids` / `get_bid` (enviada, en revisión,
   aceptada, rechazada).

## Notas

- `save_bid_draft` y `submit_bid` necesitan que el usuario haya autorizado el conector con permiso de **lectura y
  escritura**; si fallan por permisos, ve la skill `autenticacion`.
- No inventes precios, experiencia ni certificaciones: pregunta o deja **[completar]**.
