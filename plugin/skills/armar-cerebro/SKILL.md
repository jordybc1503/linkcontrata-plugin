---
name: armar-cerebro
description: Build or extend the company's Cerebro (knowledge base + graph) in LinkContrata from documents, a website or a conversation — services, clients, projects done, team, certifications, RNP, prices — so qualifying and preparing offers uses real company evidence. · Arma o amplía el Cerebro de la empresa en LinkContrata a partir de documentos, su web o una conversación (servicios, clientes, obras hechas, equipo, certificaciones, RNP, precios), para que calificar y preparar ofertas use evidencia real.
argument-hint: "[fuente: archivo, URL o tema]"
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command, mcp__plugin_linkcontrata_linkcontrata__execute, Read, Grep, Glob, WebFetch
---

# Armar el Cerebro de la empresa

El **Cerebro** es la memoria de la empresa en LinkContrata: páginas en Markdown (con versiones) y un grafo de nodos
(clientes, obras, personas, certificaciones, equipos…) unidos por relaciones. Calificar una oportunidad y preparar una
oferta salen mejor cuando el asistente cita lo que la empresa **acredita**, no lo que supone.

## Comandos

| Comando | Herramienta | Para qué |
|---|---|---|
| `get_brain_context` | `batch` | Portada, índice de páginas (sin cuerpos) y si puedes editar. **Empieza siempre aquí.** |
| `get_brain_schema` | `batch` | Tipos de nodo y relación que ya usa la empresa: reutilízalos. |
| `search_brain` · `get_brain_page` · `get_brain_neighbors` | `batch` | Buscar, leer una página, recorrer el grafo. |
| `import_brain` | `execute` | Guardar en **una transacción** nodos, relaciones y páginas nuevas. |
| `update_brain_page` | `execute` | Editar una página con `expected_version` (nunca pisa la edición de otro). |

## Pasos

1. **Orientarte** (un solo `batch`): `whoami`, `get_brain_context`, `get_brain_schema`. Anota qué páginas y tipos ya existen.
2. **Leer la fuente** que da el usuario (archivos locales, su web, una conversación). Extrae solo hechos con respaldo:
   - **Empresa**: razón social, RUC, rubros/servicios, regiones, tamaño (MYPE), RNP (capítulos y vigencia).
   - **Experiencia**: cliente, objeto, monto, fechas, conformidad (¿hay acta/constancia?).
   - **Equipo**: personas clave, cargo, especialidad, años; certificaciones con vigencia.
   - **Comercial**: precios de referencia, márgenes, condiciones, lo que NO hacen.
3. **Proponer antes de escribir**: muestra al usuario la lista de nodos, relaciones y páginas que vas a guardar, con la
   fuente de cada dato. Pide confirmación. Lo que no tenga respaldo va como **pregunta**, nunca como dato.
4. **Guardar** con un `execute` de `import_brain` por fuente (máx. 200 nodos, 500 relaciones, 20 páginas):
   - keys estables en minúsculas con guiones (`cliente-sunarp`, `persona-ana-torres`, `cert-iso-9001`); repetir la key
     actualiza el nodo en vez de duplicarlo. La respuesta trae las keys finales.
   - reutiliza los tipos de `get_brain_schema` (`Cliente`, `Obra`, `Persona`, `Certificación`…).
   - en las páginas, `source_label` = de dónde salió (p. ej. «Brochure 2026.pdf», «web linkcontrata.lat», «conversación
     28-nov») y `[[key|texto]]` para enlazar nodos. Una página por tema: «Quiénes somos», «Servicios», «Experiencia»,
     «Equipo», «Certificaciones y RNP», «Precios de referencia».
5. **Editar** una página existente: lee su versión con `get_brain_page` y usa `update_brain_page` con `expected_version`.
   Si responde *version_conflict*, vuelve a leerla y fusiona; no sobrescribas.
6. **Cerrar**: di qué se guardó, qué faltó (y a quién pedírselo) y recuerda que las páginas nuevas **nacen sin indexar**:
   una persona las revisa y enciende *Búsqueda (RAG)* en la web (Cerebro → Documentos) para que `search_brain` las encuentre.

## Reglas

- **Nunca inventes** experiencia, montos, certificaciones ni personas. Si un dato no está en la fuente, pregúntalo.
- Datos personales (DNI, teléfonos, correos de personas): solo si el usuario lo pide y con `read_scope` adecuado.
- Escribir requiere conexión de **lectura y escritura** y rol manager o admin (ver la skill `autenticacion`).
