---
name: autenticacion
description: How to sign in to LinkContrata to use the plugin (OAuth, no token). Use it when the user asks about login, connecting, permissions, or when a tool fails with "No autenticado", 401, a read-only permission error or a forbidden role. · Cómo iniciar sesión en LinkContrata para usar el plugin (OAuth, sin token). Úsala cuando el usuario pregunte por login, conexión o permisos, o cuando una herramienta falle con "No autenticado", 401, un error de solo lectura o un rol sin permiso.
---

# Autenticación de LinkContrata

El plugin se conecta al servidor MCP remoto `https://linkcontrata.lat/mcp` y actúa **como el usuario**:
el usuario **inicia sesión con su cuenta de LinkContrata** (OAuth, como "Iniciar sesión con…") y el API
aplica los mismos permisos (rol + plan) y el mismo aislamiento por empresa que la web. No hay tokens que
copiar: la contraseña nunca pasa por el asistente.

## Cómo conectarse

1. En Claude Code, escribe `/mcp`, elige **linkcontrata** y **Authenticate**. Se abre el navegador.
2. Inicia sesión en LinkContrata (correo y contraseña, o Google).
3. En la pantalla **“¿Conectar … con tu cuenta?”** revisa los permisos y pulsa **Autorizar**:
   - **Leer** — buscar, listar y ver, sin cambios.
   - **Leer y modificar** — además crear proyectos, promover al marketplace y enviar pujas.
4. Vuelve a Claude Code: la conexión queda activa y se renueva sola.

El usuario ve y desconecta sus asistentes en LinkContrata → **Configuración → Asistentes de IA**.

## Diagnóstico de errores

| Síntoma | Causa | Qué decirle al usuario |
|---|---|---|
| "No autenticado" / 401 | no hay sesión, expiró o la desconectó | Vuelve a conectar: `/mcp` → linkcontrata → Authenticate. |
| "Permiso insuficiente: esta conexión es de solo lectura" | autorizó solo lectura | Desconecta en Configuración → Asistentes de IA y vuelve a conectar aceptando lectura y escritura. |
| "No autorizado." (403) | su rol en la empresa no permite la acción | No es un problema de conexión: un administrador debe cambiar su rol. |
| "Tu plan no permite esta acción." (402) | el plan no habilita la acción (p. ej. publicar en marketplace) | Debe mejorar el plan, o usar la alternativa en borrador cuando exista. |

## Verificación rápida

Usa `whoami` (`mcp__plugin_linkcontrata_linkcontrata__whoami`) para confirmar identidad, empresa, plan y capacidades antes de
operar. Para scripts propios fuera del asistente siguen existiendo los tokens de API (`lct_…`) en
Configuración → Asistentes de IA → Tokens de API.
