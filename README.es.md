# LogLua

**🌐 Idioma / Language:** [Español](README.es.md) | [English](README.md) | [Português](README.pt-BR.md)

Sistema de logging modular y minimalista para Lua: recopile mensajes en memoria, organice por secciones/categorías, agrupe mensajes consecutivos automáticamente, monitoree en tiempo real con modo live, muestre en consola y guarde en archivos con encabezado timestamped.

## ✨ Características

- 📝 **Logging simple** - Agregue mensajes con múltiples valores
- 🏷️ **Sistema de secciones** - Organice logs por categorías
- 📦 **Agrupación automática** - Mensajes consecutivos de la misma sección se agrupan `[1-3][section]`
- 🔴 **Modo Live** - Monitoree logs en tiempo real
- 🔍 **Filtros** - Muestre/guarde solo secciones específicas
- 🐛 **Modo debug** - Mensajes de debug condicionales
- ❌ **Seguimiento de errores** - Contador automático de errores
- 📁 **Guardado en archivo** - Append con timestamps
- 🧩 **Arquitectura modular** - Código bien organizado

## 📦 Instalación

### Via LuaRocks

```bash
luarocks make rockspecs/loglua-1.5-1.rockspec
```

### Manualmente

```lua
package.path = "loglua/?.lua;" .. package.path
local log = require("loglua")
```

## 🚀 Inicio Rápido

```lua
local log = require("loglua")

-- Log simple (acepta múltiples valores)
log("Iniciando aplicación", "v1.0")
log.add("Usuario:", "davi")

-- Mensaje de debug (solo aparece si debug mode está activo)
log.activateDebugMode()
log.debug("Variable x =", 42)

-- Registrar error (incrementa contador interno)
log.error("Fallo al cargar recurso")

-- Mostrar todo en consola
log.show()

-- Guardar en archivo
log.save("./logs/", "app.log")
```

Salida ejemplo (mensajes consecutivos de la misma sección se agrupan):

```text
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--  Tue Nov 25 14:30:00 2025  --
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

[1-2][general]
 Iniciando aplicación v1.0
 Usuario: davi

[3][general]__
 Variable x = 42

[4][general]
////--error: Fallo al cargar recurso

Total prints:  4
Total errors:  1
Sections:  general
```

## 📦 Agrupación Automática

Mensajes consecutivos de la misma sección se agrupan automáticamente para mejor legibilidad:

```lua
local net = log.inSection("network")
net("Conectando...")
net("Handshake OK")
net("Autenticado")

log.add(log.section("database"), "Query ejecutada")

net("Enviando datos")
net("Respuesta recibida")
```

Salida:

```text
[1-3][network]
 Conectando...
 Handshake OK
 Autenticado

[4][database]
 Query ejecutada

[5-6][network]
 Enviando datos
 Respuesta recibida
```

## 🏷️ Sistema de Secciones

Organice sus logs por categorías para facilitar el filtrado:

### Método 1: Usando `log.section()`

```lua
log.add(log.section("network"), "Conexión establecida")
log.error(log.section("database"), "Query falló")
log.debug(log.section("parser"), "Token encontrado:", token)
```

### Método 2: Usando `log.inSection()`

Crea un objeto vinculado a una sección específica:

```lua
local netLog = log.inSection("network")
netLog.add("Conectando al servidor...")
netLog.add("Respuesta recibida")
netLog.error("Timeout!")
netLog("Atajo para add")  -- puede llamar directamente
```

### Método 3: Definiendo sección por defecto

```lua
log.setDefaultSection("game")
log.add("Player spawned")  -- va a sección "game"
log.add("Score: 100")      -- va a sección "game"
```

### Filtrando por secciones

```lua
-- Mostrar solo una sección
log.show("network")

-- Mostrar múltiples secciones
log.show({"network", "database"})

-- Guardar con filtro
log.save("./", "network.log", "network")
log.save("./", "errors.log", {"network", "database"})

-- Listar secciones disponibles
print(table.concat(log.getSections(), ", "))
```

## 🔴 Modo Live (Tiempo Real)

El modo live permite monitorear logs en tiempo real, mostrando solo los nuevos mensajes desde la última llamada de `log.show()`.

### Activando y desactivando

```lua
log.live()      -- activa modo live
log.unlive()    -- desactiva modo live
log.isLive()    -- retorna true si modo live está activo
```

### Ejemplo de monitoreo

```lua
local log = require("loglua")

-- Activar modo live
log.live()

-- Simular aplicación en ejecución
for i = 1, 10 do
    log("Evento " .. i)
    
    if i % 3 == 0 then
        log.show()  -- muestra solo los nuevos logs (últimos 3)
    end
end

log.unlive()  -- volver al modo normal
log.show()    -- ahora muestra todos los logs con header
```

### Monitoreo continuo

```lua
log.live()

local running = true
while running do
    -- su código que genera logs...
    processEvents()
    
    log.show()  -- muestra solo los nuevos mensajes
    sleep(1)
end
```

### Modo live con filtros

```lua
log.live()

-- Monitorear solo logs de red
log.show("network")

-- O múltiples secciones
log.show({"network", "database"})
```

### Comportamiento

| Modo | Comportamiento de `log.show()` |
|------|------------------------------|
| Normal | Muestra todos los mensajes con header y estadísticas |
| Live | Muestra solo nuevos mensajes desde la última llamada |

## 📖 API Completa

### Logging Básico

| Función | Descripción |
|--------|-----------|
| `log(...)` | Atajo para `log.add(...)` |
| `log.add(...)` | Agrega mensaje de log |
| `log.debug(...)` | Agrega mensaje de debug (requiere `debugMode`) |
| `log.error(...)` | Agrega mensaje de error (incrementa contador) |

### Secciones

| Función | Descripción |
|--------|-----------|
| `log.section(name)` | Crea tag de sección para usar en add/debug/error |
| `log.inSection(name)` | Retorna objeto con add/debug/error pre-configurados |
| `log.setDefaultSection(name)` | Define sección por defecto para nuevos mensajes |
| `log.getDefaultSection()` | Retorna nombre de la sección por defecto actual |
| `log.getSections()` | Retorna lista de todas las secciones utilizadas |

### Visualización y Guardado

| Función | Descripción |
|--------|-----------|
| `log.show([filter])` | Muestra logs en consola (filtro opcional) |
| `log.save([dir], [name], [filter])` | Guarda logs en archivo (filtro opcional) |

### Modo Live

| Función | Descripción |
|--------|-----------|
| `log.live()` | Activa modo live (tiempo real) |
| `log.unlive()` | Desactiva modo live |
| `log.isLive()` | Verifica si modo live está activo |

### Configuración

| Función | Descripción |
|--------|-----------|
| `log.activateDebugMode()` | Activa modo debug |
| `log.deactivateDebugMode()` | Desactiva modo debug |
| `log.checkDebugMode()` | Verifica si debug mode está activo |
| `log.clear()` | Limpia todos los mensajes y resetea contadores |

### Ayuda

| Función | Descripción |
|--------|-----------|
| `log.help()` | Muestra ayuda general |
| `log.help("sections")` | Ayuda sobre sistema de secciones |
| `log.help("live")` | Ayuda sobre modo live |
| `log.help("api")` | Lista completa de la API |

## 🏗️ Estructura del Proyecto

```text
loglua/
├── init.lua         # Módulo principal (API pública)
├── config.lua       # Configuración y estado (mensajes, debug, contadores)
├── formatter.lua    # Formateo de mensajes y encabezados
├── file_handler.lua # Operaciones de archivo (I/O)
└── help.lua         # Sistema de ayuda integrado
```

### Arquitectura

- **`init.lua`**: API pública, integra todos los módulos
- **`config.lua`**: Gestiona estado interno (mensajes, secciones, contadores)
- **`formatter.lua`**: Formateo de texto (encabezados, mensajes, separadores)
- **`file_handler.lua`**: Operaciones de I/O de archivo
- **`help.lua`**: Documentación integrada accesible via `log.help()`

## 📝 Ejemplos Avanzados

### Logger para múltiples sistemas

```lua
local log = require("loglua")

-- Crear loggers específicos
local networkLog = log.inSection("network")
local dbLog = log.inSection("database")
local uiLog = log.inSection("ui")

-- Usar en diferentes partes del código
networkLog("Conectando...")
dbLog("Query ejecutada")
uiLog("Pantalla cargada")

-- Guardar cada sección en archivo separado
log.save("./logs/", "network.log", "network")
log.save("./logs/", "database.log", "database")
log.save("./logs/", "ui.log", "ui")
```

### Debug condicional

```lua
local log = require("loglua")

local DEBUG = true
if DEBUG then
    log.activateDebugMode()
end

log.debug("Este mensaje solo aparece si DEBUG=true")
```

### Limpiar y reiniciar

```lua
local log = require("loglua")

log("Mensaje 1")
log("Mensaje 2")
log.show()

log.clear()  -- Limpia todo

log("Nueva sesión")
log.show()
```

## 📋 Notas

- Mensajes permanecen en memoria hasta ser limpiados con `clear()`
- Llamar `save` repetidamente hace append en el archivo (con nuevo timestamp)
- Mensajes de debug solo aparecen si `debugMode` está activo
- Secciones se registran automáticamente al agregar mensajes

## 🔧 Compatibilidad

- Lua >= 5.4

## 📜 Licencia

MIT — vea `LICENSE`.
