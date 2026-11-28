---
description: Prepare an offer for an opportunity — public (OECE/SEACE, presented in the SEACE) or private (sent inside LinkContrata). · Prepara una oferta para una oportunidad — pública (OECE/SEACE, se presenta en el SEACE) o privada (se envía en LinkContrata).
argument-hint: "[código, id o URL de la oportunidad]"
---

Prepara una oferta para: **$ARGUMENTS**.

1. Decide el tipo de oportunidad:
   - **Pública** (proceso del Estado: un código como `CM-…`, `LP-…`, `AS-…`, una URL
     `…/marketplace/oportunidades-publicas/…`): sigue la skill `preparar-propuesta` — lee la ficha con
     `mcp__plugin_linkcontrata_linkcontrata__get_public_opportunity`, saca los requisitos de las Bases, revisa la
     elegibilidad con la normativa y deja la cotización, la carta y las declaraciones listas **para presentarlas en
     el SEACE** (LinkContrata no la envía).
   - **Privada** (publicada por una empresa en LinkContrata: URL `…/marketplace/oportunidades/…`): sigue la skill
     `postular-oportunidad-privada` — arma los precios por ítem y la nota, el usuario crea el borrador en
     **Postular** y la envías con `submit_bid` solo con su confirmación.
   - Si no está claro (solo un nombre), busca con `mcp__plugin_linkcontrata_linkcontrata__list_opportunities` y
     pregunta cuál es.
2. Empieza diciendo cuánto falta para el cierre. Nunca inventes datos: lo desconocido va como **[completar]**.

Responde en el idioma del usuario. / Reply in the user's language.
