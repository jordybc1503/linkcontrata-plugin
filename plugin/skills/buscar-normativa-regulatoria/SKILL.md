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
   usuario como `query`. Acota con `source`, `year`, `document_type`, `published_from` y
   `published_to` (AAAA-MM-DD) cuando el usuario hable de un tipo de norma, una entidad o un
   periodo (los valores salen de `list_regulatory_documents`). `top_k` va de 1 a 20; con
   `min_similarity` (umbral 0–1) la respuesta se arma solo con los fragmentos que lo pasan. Si el usuario quiere ver los resultados en pantalla, usa
   `show_command` con el mismo comando y argumentos.
2. **Lee los fragmentos** devueltos: cada uno trae el documento de origen. Para el texto
   completo de una norma, lee `get_regulatory_document` con su id; para navegar/filtrar el
   catálogo (fuente, año, tipo), `list_regulatory_documents` (también con `batch`; varios
   documentos pueden ir en un mismo `batch`).
3. **Responde citando la fuente.** Resume con base en los fragmentos recuperados y **cita**
   el documento (título / id). No inventes artículos ni números: si el corpus no lo cubre,
   dilo y sugiere afinar la consulta.

## La Ley 32069 y su Reglamento

Para el texto de la Ley N° 32069 o de su Reglamento usa `search_norms` (por palabras, sin IA: funciona aunque la
búsqueda semántica esté caída) y `get_norm_article` (`norma`: `ley-32069` o `reglamento-32069`, `articulo`). Cita
con la `url` del artículo (el PDF oficial en su página). Si `modificado` es true, el texto vigente de lo modificado es
la cita de la nota «cuyo texto es el siguiente». Si `search_regulations` responde con `base_norms`, son esos artículos:
léelos con `get_norm_article` antes de citarlos.

## Notas

- Es un asistente de **referencia normativa**, no asesoría legal vinculante; cuando la
  consulta tenga implicancias serias, recomiéndale validar con un especialista.
- Si no hay resultados relevantes, reformula con sinónimos o términos más específicos del
  dominio (OECE, SEACE, OCDS, buena pro, postor, etapa).
