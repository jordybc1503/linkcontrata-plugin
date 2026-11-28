---
name: alertas-oportunidades
description: Set up and run opportunity alerts in LinkContrata — saved searches over public SEACE processes (minor contracts included) that mail the company every morning the NEW matching processes with their real deadline and a reconvocatoria mark. Use it when the user says "avísame de los procesos de chatbots", "créame una alerta", "alert me about new tenders for X", "qué salió hoy de mi búsqueda", or wants to see, run or delete their alerts. · Crea y corre alertas de oportunidades en LinkContrata: búsquedas guardadas sobre procesos públicos del SEACE (contrataciones menores incluidas) que mandan cada mañana por correo los procesos NUEVOS que encajan, con su plazo real y la marca de reconvocatoria. Úsala cuando el usuario diga «avísame de los procesos de chatbots», «créame una alerta», «qué salió hoy de mi búsqueda» o quiera ver, correr o borrar sus alertas.
argument-hint: "[rubro o palabras clave]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command, mcp__plugin_linkcontrata_linkcontrata__execute
---

# Alertas de oportunidades

Una **búsqueda guardada** es de la empresa: cada mañana (7:00, hora de Lima) quien la creó recibe por correo los
procesos públicos **nuevos** que encajan, sin repetir nunca uno ya enviado. Guía completa: `get_help` con
`alertas-de-oportunidades`.

| Comando | Herramienta | Para qué |
|---|---|---|
| `list_saved_searches` | `batch` | Las búsquedas de la empresa y sus criterios. **Empieza aquí** (no dupliques una que ya existe). |
| `run_saved_search` | `batch` | Correrla ya: procesos abiertos que encajan, con `deadline` y `reconvocatoria`. No marca nada como enviado. |
| `create_saved_search` | `execute` | Guardar una búsqueda nueva. |
| `delete_saved_search` | `execute` | Borrarla (deja de llegar su correo). |

## Crear una alerta

1. `batch`: `whoami` + `list_saved_searches`. Si ya hay una parecida, ofrece correrla en vez de crear otra.
2. Traduce lo que pide el usuario a criterios (al menos uno):
   - `keywords`: varias formas de decir lo mismo —basta que aparezca una— p. ej. `["chatbot", "asistente virtual",
     "inteligencia artificial", "tokens"]`. Sin tildes ni mayúsculas: da igual.
   - `method_families`: `licitacion`, `concurso`, `adjudicacion`, `directa`, `otros` (vacío = todos).
   - `departments`: región = departamento de la entidad, en mayúsculas como en el SEACE (`"AREQUIPA"`).
   - `budget_min` / `budget_max` en soles: avisa que dejan fuera los procesos sin monto publicado.
   - `include_cm` (por defecto `true`): contrataciones menores ≤ 8 UIT, donde suelen estar los servicios pequeños.
3. **Confirma** nombre y criterios con el usuario, luego `execute` → `create_saved_search`.
4. Córrela con `run_saved_search` para que vea qué tipo de procesos le llegarán, y ajusta si salen muy pocos o
   demasiados (borrar + crear: no hay edición).

## Leer los resultados

- `deadline.label`: el fin del registro de participantes (en una CM, el fin de la cotización). «por verificar» =
  aún no hay cronograma: que lo revise en el SEACE.
- `reconvocatoria`: el proceso vuelve a convocarse (`reasons`: `convocatoria` = el código termina en `-2` o más,
  `desierto`, `mismo_objeto` = la entidad ya publicó lo mismo antes). Si hay `previous`, muéstralo: ahí se ve por qué
  quedó desierto. Es una heurística: que lo confirme en el SEACE.
- Para preparar una oferta a uno de ellos, sigue con la skill `preparar-propuesta` (`get_public_opportunity` con su `id`).

## Reglas

- Nunca crees ni borres sin confirmación. Un token de solo lectura no puede escribir (`WRITE_NOT_ALLOWED`).
- Borrar: quien la creó o un manager/admin (si no, 403).
