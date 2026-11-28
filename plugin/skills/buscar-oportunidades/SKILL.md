---
name: buscar-oportunidades
description: Find public (OECE/SEACE) and private LinkContrata opportunities that fit the company — read its procurement profile and Cerebro, search with filters, drop what it cannot meet, qualify the rest with evidence and regulations, and return a short list with the reason and the real deadline of each. Use it when the user asks "¿a qué puedo postular?", "busca oportunidades para mi empresa", "find tenders for us" or wants a shortlist. · Busca oportunidades públicas (OECE/SEACE) y privadas de LinkContrata que encajen con la empresa (lee su perfil de compras y su Cerebro, busca con filtros, descarta lo que no puede cumplir, califica el resto con evidencia y normativa y devuelve una lista corta con el porqué y el plazo real de cada una). Úsala cuando el usuario pregunte «¿a qué puedo postular?», «busca oportunidades para mi empresa» o quiera una lista corta.
argument-hint: "[rubro, región o necesidad (opcional)]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command
---

# Buscar oportunidades para la empresa

Esta skill **solo lee**: todos sus comandos van por `batch` (junta varios en una llamada). Si no conoces los
argumentos de un comando, pídelos con `describe_command`. Si el usuario quiere dejar el trabajo registrado y que la
empresa elija en la web, abre un **radar** con la skill `trabajar-flujo` (`start_flow` con `kind: "radar"`).

## Flujo

1. **Perfil de la empresa.** En un solo `batch`: `whoami`, `get_company_procurement_profile` (rubros
   `preferred_categories`, regiones `preferred_locations`, especialidades `preferred_tags`, rango de montos, tipos de
   contrato, modalidades, experiencia por rubro y notas) y `get_brain_context` (índice del Cerebro). Busca en el Cerebro
   con `search_brain` lo que el perfil no dice (servicios, obras hechas, certificaciones, RNP y su capítulo).
   Si el perfil está vacío y el usuario no dio un rubro, **pregúntale** qué hace la empresa, dónde y por cuánto; no
   supongas.
2. **Busca** con `list_opportunities`, varias búsquedas en un `batch`:
   - públicas: `type: "public"`, `query` con las palabras del rubro (y sinónimos), `department` (el nombre exacto como
     sale en los resultados, p. ej. `LIMA`; es el domicilio de la entidad, no el lugar de ejecución: úsalo como una
     búsqueda más, no como la única), `main_category` (OCDS: `goods`, `services`, `works`),
     `sort` (`relevance` si hay `query`, si no `published_desc`) e `items` (hasta 100); por defecto solo salen los
     procesos en curso;
   - privadas, en otra búsqueda: `type: "private"` solo con `query` (con `department` o `main_category` el feed deja
     fuera las privadas, y con `type: "private"` esos filtros no aplican);
   - una búsqueda por rubro y región del perfil; si no sale nada, amplía (sin región, sinónimos) y dilo.
3. **Descarta por requisitos** antes de leer a fondo: fuera de rubro, monto (`estimated_value`) fuera del
   rango del perfil o muy por encima de la experiencia declarada. Anota cada descarte con su motivo. El plazo y los
   procesos solo por invitación se ven en el paso 4, en sus etapas; la región, en el lugar de ejecución de la ficha
   (ítems, Bases), no en el domicilio de la entidad.
4. **Lee los que quedan** con `get_public_opportunity` (hasta 10 por `batch`) y calcula el **plazo real** con sus
   `etapas` (`nombre_etapa_estandar`, `nombre_etapa`, `start`, `end` en hora de Lima, `estado`), nunca con
   `deadline_at`: en un procedimiento de selección esa es la fecha de convocatoria.
   - Abierto para postular: antes del fin de «Registro de participantes» (la empresa debe registrarse en el SEACE).
   - Registro cerrado y «Presentación de ofertas» sin terminar: solo si la empresa ya se registró; márcalo así.
   - Presentación cerrada (evaluación, buena pro): ya no se puede postular; descártalo.
   - Contratación Menor (en `nombre_etapa`: «ETAPA DE CONSULTAS» / «ETAPA DE COTIZACIÓN», estándar «Otro»): cotiza
     hasta el fin de «ETAPA DE COTIZACIÓN»; si esa etapa ya está `cerrada`, descártalo.
   - Solo «Invitación», sin Registro ni etapas de contratación menor (contratación directa, adjudicación abreviada):
     solo para invitados; descártalo.
   - Sin `etapas`: «fechas por confirmar en el SEACE»; no inventes un cierre.
   Para una oportunidad privada, el plazo es su `deadline_at` y se postula dentro de LinkContrata.
5. **Califica con evidencia.** Contrasta lo que piden (ítems, `source_document.text` de las Bases si está) con el
   Cerebro y el perfil: cita la página del Cerebro (`search_brain`, `get_brain_page`) o el dato del perfil que respalda
   cada punto. Para dudas de elegibilidad (RNP, impedimentos, consorcios, contrataciones menores) usa
   `search_regulations` con filtros si aplican y cita el documento. Lo que no tenga respaldo queda como **por
   confirmar**, nunca como cumplido.
6. **Entrega la lista corta** (lo mejor primero), por cada una: título y código, entidad, monto, **plazo real** (qué
   hacer y hasta cuándo, hora de Lima), por qué encaja (con su fuente) y qué falta confirmar. Después, en breve, los
   descartados con su motivo y los procesos por verificar. Si nada encaja, dilo así: una lista vacía bien explicada es
   un resultado válido.

## Reglas

- Nunca inventes montos, RUC, experiencia, inscripción en el RNP ni artículos de normas; lo que no sepas, pregúntalo o
  márcalo por confirmar.
- No postules, no publiques y no abras flujos sin que el usuario lo pida; para preparar una oferta pública usa
  `preparar-propuesta`, y para una privada `postular-oportunidad-privada`.
- Si el usuario quiere ver los resultados en pantalla, usa `show_command` con `list_opportunities`.

Responde en el idioma del usuario. / Reply in the user's language.
