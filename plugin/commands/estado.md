---
description: Show your identity, company, plan and a LinkContrata dashboard summary. · Muestra tu identidad, empresa, plan y un resumen del panel de LinkContrata.
allowed-tools: mcp__plugin_linkcontrata_linkcontrata__list_commands, mcp__plugin_linkcontrata_linkcontrata__describe_command, mcp__plugin_linkcontrata_linkcontrata__batch, mcp__plugin_linkcontrata_linkcontrata__show_command
---

Lee los comandos `whoami` y `dashboard_summary` en un solo `mcp__plugin_linkcontrata_linkcontrata__batch` y presenta, en
el idioma del usuario y de forma concisa: usuario y empresa, plan y capacidades, y los conteos clave
(proyectos, oportunidades, pujas) con la actividad reciente. Si el usuario quiere ver el panel, muéstralo
con `show_command` (`dashboard_summary`). Si `whoami` indica que no estás autenticado, explica cómo
conectarse (skill `autenticacion`).
