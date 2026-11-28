---
name: preparar-propuesta
description: Prepare the proposal for a PUBLIC Peruvian procurement process (OECE/SEACE) — requirements checklist from the Bases, eligibility check against the regulations, and draft quotation and annexes; the user then submits it in SEACE. Use it when the user asks to prepare, draft or review a proposal/quotation/offer for a public process (a code like CM-123-2026-…, a LinkContrata URL or an id). · Prepara la propuesta para un proceso PÚBLICO del Estado peruano (OECE/SEACE): checklist de requisitos sacado de las Bases, revisión de elegibilidad con la normativa y borrador de cotización y anexos; el usuario la presenta luego en el SEACE. Úsala cuando pida preparar, redactar o revisar una propuesta, cotización u oferta para un proceso público (un código como CM-123-2026-…, una URL de LinkContrata o un id).
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

Esta skill solo lee: todos los comandos que usa (`list_opportunities`, `get_public_opportunity`, `whoami`,
`search_regulations`, `get_regulatory_document`) van por `batch`, y puedes juntar varios en una llamada (p. ej. la
ficha y `whoami`). Si no conoces los argumentos de un comando, pídelos con `describe_command`.

## Flujo

1. **Identifica el proceso.**
   - Id numérico o URL `…/marketplace/oportunidades-publicas/73432-…` → el id es el número inicial.
   - Código (`CM-1755-2026-GRA/AUTODEMA`, `LP-013-2026-…`) → búscalo con `list_opportunities`
     (`type: "public"`, `query: <código>`), confirma con el usuario si hay más de uno.
   - Lee la ficha con `get_public_opportunity` (`id`): entidad, tipo de proceso, cronograma, ítems, documentos y
     `source_document.text` (texto extraído de las Bases / términos de referencia).
2. **Avisa el plazo.** Di cuánto falta para el cierre (`deadline_at`, hora de Lima). Si ya cerró, dilo y detente.
3. **Checklist de requisitos**, solo con lo que dicen las Bases (cita la sección o el anexo):
   - documentos a presentar (anexos, declaraciones juradas, constancias, fichas técnicas);
   - experiencia y personal exigidos;
   - plazos de entrega/ejecución, lugar, forma de pago;
   - garantías, penalidades, condiciones de la cotización (vigencia, moneda, si incluye IGV).
   Si el texto de las Bases no está o está incompleto, dilo y pide al usuario el PDF de la sección «Documentos».
4. **¿Puede postular la empresa?** Usa `whoami` para la empresa y su RUC. Revisa con `search_regulations` /
   `get_regulatory_document` lo que aplique al tipo de proceso: inscripción vigente en el RNP en el capítulo
   correspondiente, impedimentos para contratar con el Estado y, en contrataciones menores (≤ 8 UIT), las reglas
   propias de ese tipo de proceso. Cita el documento de origen. No declares elegible a la empresa por tu cuenta:
   lista lo que el usuario debe confirmar.
5. **Borradores en Markdown**, listos para copiar:
   - **Cotización / oferta económica** con los ítems del proceso (cantidad, unidad, precio unitario, total);
   - **Carta de presentación** dirigida a la entidad, con el código del proceso;
   - **Declaraciones juradas** que pidan las Bases.
   Usa solo datos reales de la empresa (`whoami`) y del proceso; todo lo que no sepas va como **[completar]**
   (precios, plazos ofrecidos, firmas, números de constancia). Nunca inventes montos, RUC, experiencia ni normas.
6. **Checklist final para el SEACE**: qué archivos subir, en qué formato, antes de qué fecha y hora, y el recordatorio
   de que se presenta desde el SEACE con el usuario del RNP. Enlaza los documentos del proceso (URLs del SEACE).

## Notas

- Es una ayuda para preparar la propuesta, no asesoría legal vinculante; ante dudas de interpretación, recomienda
  validar con un especialista o con una consulta a la entidad dentro del plazo de consultas.
- El texto de algunas Bases sale con caracteres rotos (problema del PDF); si un dato importante se ve dañado, pide al
  usuario que lo confirme en el PDF original.
