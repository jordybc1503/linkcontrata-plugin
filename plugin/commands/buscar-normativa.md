---
description: Search Peruvian procurement regulations (semantic search over gob.pe). · Busca en la normativa peruana de contrataciones (búsqueda semántica sobre gob.pe).
argument-hint: "[consulta en lenguaje natural]"
---

Busca en la documentación regulatoria de LinkContrata. Consulta: **$ARGUMENTS**.

Sigue la skill `buscar-normativa-regulatoria`: ejecuta el comando `search_regulations` con la consulta
(con `mcp__plugin_linkcontrata_linkcontrata__batch`), lee los fragmentos recuperados y responde **citando el documento de origen**
(lee el comando `get_regulatory_document`, también con `batch`, para el texto completo si hace falta). No
inventes artículos ni números; si el corpus no lo cubre, dilo y sugiere reformular.
Responde en el idioma del usuario. / Reply in the user's language.
