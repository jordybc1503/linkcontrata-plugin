---
description: Prepare an offer for an opportunity — public (OECE/SEACE, presented in the SEACE) or private (sent inside LinkContrata). · Prepara una oferta para una oportunidad — pública (OECE/SEACE, se presenta en el SEACE) o privada (se envía en LinkContrata).
argument-hint: "[código, id o URL de la oportunidad]"
---

Prepara una oferta para: **$ARGUMENTS**.

1. Decide el tipo de oportunidad:
   - **Pública** (proceso del Estado: un código como `CM-…`, `LP-…`, `AS-…`, una URL
     `…/marketplace/oportunidades-publicas/…`): sigue la skill `preparar-propuesta` — lee la ficha con el comando
     `get_public_opportunity` (vía `mcp__plugin_linkcontrata_linkcontrata__batch`), saca los requisitos de las Bases, revisa la
     elegibilidad con la normativa y deja la cotización, la carta y las declaraciones listas **para presentarlas en
     el SEACE** (LinkContrata no la envía).
   - **Privada** (publicada por una empresa en LinkContrata: URL `…/marketplace/oportunidades/…`): sigue la skill
     `postular-oportunidad-privada` — lee las partidas (`list_opportunity_quote_items`), arma los precios y la nota,
     guarda el borrador con `save_bid_draft` y lo envías con `submit_bid` (ambos vía `execute`) solo con su confirmación.
   - Si no está claro (solo un nombre), busca con el comando `list_opportunities` (vía `batch`) y
     pregunta cuál es.
2. Empieza diciendo cuánto falta para el cierre. Nunca inventes datos: lo desconocido va como **[completar]**.
3. Ofrece abrir un **flujo con IA** (comando `start_flow` vía `mcp__plugin_linkcontrata_linkcontrata__execute`, `public_offer` con
   `public_opportunity_id` o `private_offer` con `opportunity_id`) para que cada paso quede registrado y la empresa
   decida en la web; si acepta, sigue la skill `trabajar-flujo` en vez de las anteriores.

Responde en el idioma del usuario. / Reply in the user's language.
