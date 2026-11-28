---
name: preparar-propuesta
description: Prepare the proposal for a PUBLIC Peruvian procurement process (OECE/SEACE) — requirements checklist from the Bases, eligibility check against the regulations, and draft quotation and annexes; the user then submits it in SEACE. Use it when the user asks to prepare, draft or review a proposal/quotation/offer for a public process (a code like CM-123-2026-…, a LinkContrata URL or an id). · Prepara la propuesta para un proceso PÚBLICO del Estado peruano (OECE/SEACE) — checklist de requisitos sacado de las Bases, revisión de elegibilidad con la normativa y borrador de cotización y anexos; el usuario la presenta luego en el SEACE. Úsala cuando pida preparar, redactar o revisar una propuesta, cotización u oferta para un proceso público (un código como CM-123-2026-…, una URL de LinkContrata o un id).
argument-hint: "[id, código o URL del proceso público]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command
---

# Preparar propuesta para un proceso público (OECE/SEACE)

**La oferta de un proceso público se presenta en el SEACE, con el usuario del RNP de la empresa. LinkContrata no la
envía:** esta skill deja todo listo para que el usuario la presente. (Las oportunidades **privadas** se postulan dentro
de LinkContrata; para esas no uses esta skill.)

## Si hay un flujo con IA

Si el usuario tiene (o quiere) un flujo con IA para esta oportunidad, usa la skill `trabajar-flujo` (`start_flow` para
abrirlo): cada paso queda registrado con su informe y sus fuentes, y las decisiones las toma la empresa en la web.

Esta skill casi solo lee: los comandos de lectura (`list_opportunities`, `get_public_opportunity`, `get_process_deadlines`, `whoami`,
`get_company_procurement_profile`, `get_bidder_profile`, `check_experience_threshold`, `search_norms`,
`get_norm_article`, `search_regulations`, `get_regulatory_document`) van por `batch`, y puedes juntar varios en una llamada (p. ej. la
ficha y `whoami`). Si no conoces los argumentos de un comando, pídelos con `describe_command`.

## Flujo

1. **Identifica el proceso.**
   - Id numérico o URL `…/marketplace/oportunidades-publicas/73432-…` → el id es el número inicial.
   - Código (`CM-1755-2026-GRA/AUTODEMA`, `LP-013-2026-…`) → búscalo con `list_opportunities`
     (`type: "public"`, `query: <código>`, `public_process_status: "all"`: sin él solo salen los que aún admiten
     postulantes), confirma con el usuario si hay más de uno.
   - Lee la ficha con `get_public_opportunity` (`id`): entidad, tipo de proceso, cronograma, ítems, documentos y
     `source_document.text` (texto extraído de las Bases / términos de referencia). Si `source_document.scanned` es
     `true` y `text` está vacío, las Bases son un PDF escaneado que aún no se leyó con OCR: dilo, no inventes
     requisitos y usa el PDF (`source_url`) o pídeselos al usuario. Con `extraction_method: "ocr"` el texto viene de OCR:
     verifica cifras y plazos contra el PDF antes de afirmarlos.
2. **Avisa el plazo** según `phase` (fechas en hora de Lima):
   - `open`: di hasta cuándo puede postular (`apply_until`) y cuánto falta. Es el fin del «Registro de participantes»
     en el SEACE: la empresa debe **registrarse como participante antes** de esa fecha, y presenta la oferta del
     `offers_open_at` al `offers_close_at`. En una contratación menor (`quotation_closes_at`) es el plazo para enviar
     la cotización.
   - `offers`: el registro ya cerró; solo puede presentar oferta si ya se registró como participante. Pregúntaselo
     antes de seguir y, si no, detente.
   - `evaluation`, `awarded` o `invite_only`: ya no puede postular (o es solo por invitación). Dilo y detente.
   - `unknown`: aún no hay cronograma; pide al usuario que confirme las fechas en el SEACE.
   `tender_end_date` es la fecha de convocatoria, no un cierre: no la uses como plazo.
   Los plazos legales vienen en `legal_deadlines` de la ficha (o con `get_process_deadlines`): mínimos de consultas y
   ofertas, último día para apelar, consentimiento y firma, en días hábiles y con su artículo; las garantías (fiel
   cumplimiento, apelación) y las bonificaciones. Las fechas `estimado` cuentan desde el cronograma: dilo así, y
   repite lo que diga `warnings`.
3. **Checklist de requisitos**, solo con lo que dicen las Bases (cita la sección o el anexo):
   - documentos a presentar (anexos, declaraciones juradas, constancias, fichas técnicas);
   - experiencia y personal exigidos;
   - plazos de entrega/ejecución, lugar, forma de pago;
   - garantías, penalidades, condiciones de la cotización (vigencia, moneda, si incluye IGV).
   Si el texto de las Bases no está o está incompleto, dilo y pide al usuario el PDF de la sección «Documentos».
4. **¿Puede postular la empresa?** Usa `get_company_procurement_profile` para su rubro, regiones, montos y experiencia
   declarada, y `get_bidder_profile` para los datos del postor (razón social, RUC, RNP por capítulo con vigencia, REMYPE,
   representante legal, cuentas —solo últimos 4 dígitos—, certificaciones, experiencias y `alerts` de lo vencido). Si las
   Bases piden un monto de experiencia similar, `check_experience_threshold` (`specialty` = el rubro, `min_amount` en
   soles, `since` si limitan los años). Las reglas: `search_norms` / `get_norm_article` para la Ley 32069 y su
   Reglamento (cita con su `url`; si `modificado`, el texto vigente es la cita de la nota) y `search_regulations` /
   `get_regulatory_document` para opiniones y resoluciones. Revisa el RNP vigente en el capítulo del proceso,
   impedimentos (Ley, art. 30) y, en contratos menores (≤ 8 UIT), sus reglas (Ley, art. 34). No declares elegible a la
   empresa por tu cuenta: lista lo que el usuario debe confirmar. Si faltan datos del postor, ofrécele guardarlos con
   `update_bidder_profile` / `add_bidder_experience` (escritura: `execute`, con su confirmación).
5. **Borradores en Markdown**, listos para copiar:
   - **Cotización / oferta económica** con los ítems del proceso (cantidad, unidad, precio unitario, total);
   - **Carta de presentación** dirigida a la entidad, con el código del proceso;
   - **Declaraciones juradas** que pidan las Bases.
   Usa solo datos reales de la empresa (`whoami`, `get_bidder_profile`) y del proceso; todo lo que no sepas va como **[completar]**
   (precios, plazos ofrecidos, firmas, números de constancia). Nunca inventes montos, RUC, experiencia ni normas.
6. **Checklist final para el SEACE**: qué archivos subir, en qué formato, antes de qué fecha y hora (el fin de
   «Presentación de ofertas», o de «ETAPA DE COTIZACIÓN» en una contratación menor; en una subasta inversa, el fin del
   «Registro de participantes», donde también se presenta la oferta, y no el «Periodo de lances», que viene después; si
   aún no se registró, antes el fin del registro), y el recordatorio de que se presenta desde el SEACE con el usuario del RNP. Enlaza los documentos del proceso (URLs del SEACE).

## Notas

- Es una ayuda para preparar la propuesta, no asesoría legal vinculante; ante dudas de interpretación, recomienda
  validar con un especialista o con una consulta a la entidad dentro del plazo de consultas.
- El texto de algunas Bases sale con caracteres rotos (problema del PDF); si un dato importante se ve dañado, pide al
  usuario que lo confirme en el PDF original.
