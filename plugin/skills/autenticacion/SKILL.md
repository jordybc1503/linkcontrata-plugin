---
name: autenticacion
description: How to authenticate to LinkContrata to use the plugin. Use it when the user asks about login, tokens, or permissions, or when a tool fails with 401 (unauthorized), 403 (insufficient_scope / forbidden) or the hook asks to configure the token. · Cómo autenticarse en LinkContrata para usar el plugin. Úsala cuando el usuario pregunte por login, tokens, permisos, o cuando una herramienta falle con 401 (unauthorized), 403 (insufficient_scope / forbidden) o el hook pida configurar el token.
---

# Autenticación de LinkContrata

El plugin actúa **como el usuario**: cada herramienta `mcp__linkcontrata__*` lleva el token
personal del usuario y el API de LinkContrata aplica los mismos permisos (rol + plan) y el
mismo aislamiento por empresa que la web. El asistente nunca puede hacer más de lo que ese
usuario podría hacer en `https://linkcontrata.lat`.

## Cómo se configura el token

1. En LinkContrata: **Configuración → Tokens de API → Generar token**.
   - **`read`** — solo lectura (buscar, listar, ver). Recomendado para empezar.
   - **`read_write`** — además permite crear proyectos, promover al marketplace y enviar pujas.
   - El token (`lct_…`) se muestra **una sola vez**.
2. Guárdalo en la config del plugin: el campo **Token de API de LinkContrata** (se almacena
   cifrado, en keychain). Alternativamente, exporta `LINKCONTRATA_TOKEN` en el entorno.
3. (Opcional) Ajusta **URL de LinkContrata** si usas una instancia propia.

## Diagnóstico de errores

| Síntoma | Causa | Qué decirle al usuario |
|---|---|---|
| `401 unauthorized` / hook deniega una escritura | falta token o es inválido | Configura un token válido (ver arriba). |
| `403 insufficient_scope` | token de solo lectura intentando escribir | Genera un token con scope **read_write**. |
| `403 forbidden` | el rol del usuario no permite la acción | Su rol en la empresa no lo permite (no es un problema de token). |
| `402 plan_limit` | el plan no habilita la acción (p. ej. publicar en marketplace) | Debe mejorar el plan; o usar la alternativa en borrador cuando exista. |

## Verificación rápida

Usa `whoami` (`mcp__linkcontrata__whoami`) para confirmar identidad, empresa, plan y
capacidades antes de operar.
