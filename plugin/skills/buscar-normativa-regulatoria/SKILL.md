---
name: buscar-normativa-regulatoria
description: Search the Peruvian procurement regulatory documentation (gob.pe corpus) with semantic search. Use it when the user asks about regulations, laws, rules, deadlines, OECE/SEACE procedures, opinions or rulings, or how to proceed under public-procurement law. · Busca en la documentación regulatoria peruana de contrataciones (corpus gob.pe) con búsqueda semántica. Úsala cuando el usuario pregunte por normas, leyes, reglamentos, plazos, procedimientos OECE/SEACE, opiniones o pronunciamientos, o cómo proceder según la normativa de contratación pública.
argument-hint: "[consulta en lenguaje natural]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command
---

# Buscar normativa regulatoria (RAG)

Búsqueda semántica sobre el corpus regulatorio peruano con el comando `search_regulations`,
que se lee con `batch` (`mcp__plugin_linkcontrata_linkcontrata__batch`). Lectura: funciona con cualquier conexión.

## Flujo

1. **Formula la consulta** en lenguaje natural y específica, p. ej. *"plazos para apelar una
   buena pro"* o *"causales de nulidad de oficio en contrataciones"*. Pasa el texto del
   usuario como `query`. Ajusta `top_k` (máx. resultados) y `min_similarity` (umbral 0–1)
   solo si hace falta acotar. Si el usuario quiere ver los resultados en pantalla, usa
   `show_command` con el mismo comando y argumentos.
2. **Lee los fragmentos** devueltos: cada uno trae el documento de origen. Para el texto
   completo de una norma, lee `get_regulatory_document` con su id; para navegar/filtrar el
   catálogo (fuente, año, tipo), `list_regulatory_documents` (también con `batch`; varios
   documentos pueden ir en un mismo `batch`).
3. **Responde citando la fuente.** Resume con base en los fragmentos recuperados y **cita**
   el documento (título / id). No inventes artículos ni números: si el corpus no lo cubre,
   dilo y sugiere afinar la consulta.

## Notas

- Es un asistente de **referencia normativa**, no asesoría legal vinculante; cuando la
  consulta tenga implicancias serias, recomiéndale validar con un especialista.
- Si no hay resultados relevantes, reformula con sinónimos o términos más específicos del
  dominio (OECE, SEACE, OCDS, buena pro, postor, etapa).
