# QA Crew — Multi-Agent Testing para OpenCode

**Proyecto Manhattan.** Sistema multi-agente para QA/testing automation construido sobre OpenCode. Cuatro sub-agentes especializados (planner, explorer, coder, reviewer) trabajan en equipo, cada uno con su propio LLM, contexto aislado, y skills basadas en metodologías de testing reconocidas (ISTQB, POM, SBTM, Right-BICEP).

---

## ⚙️ Requisitos

| Requisito | Detalle |
|---|---|
| **OpenCode** | Instalado (cualquier versión reciente) |
| **Gentle AI** | El `gentle-orchestrator` es el neurón central — sin él los sub-agentes no se ejecutan. OpenCode lo incluye por defecto si está configurado como agente primary en `~/.config/opencode/opencode.json` |
| **Node.js** >= 18 | Para los tests del demo y ejecutar Playwright |
| **Bash** | Para el switch de perfiles de modelos |
| **Playwright MCP** | Necesario solo si usás `test-explorer`. Configurado en `~/.config/opencode/opencode.json` |
| **Atlassian MCP** | Necesario solo si querés que `test-planner` lea user stories directo de Jira. ⚠️ Requiere configuración manual |

---

## 📂 Estructura del Proyecto

```
qa-crew-opencode/
├── opencode.json                      ← Sub-agentes de testing (viaja con el repo)
├── profiles/
│   ├── full-power.json                ← Perfiles de modelos LLM
│   ├── eco.json
│   ├── balanced.json
│   ├── dev-local.json
│   └── switch-profile.sh              ← Script para aplicar perfiles
├── skills/
│   ├── testing-orchestrator/SKILL.md   ← Orquestación del flujo
│   ├── testing-profiles/SKILL.md       ← Gestión de modelos
│   ├── test-planner/SKILL.md           ← ISTQB + Risk-Based
│   ├── test-coder/SKILL.md             ← POM + AAA + FIRST
│   ├── test-explorer/SKILL.md          ← SBTM + SFDPOT
│   └── test-reviewer/SKILL.md         ← Right-BICEP + CRUD
└── demo-app/
    ├── index.html                      ← App de ejemplo
    ├── playwright.config.ts
    ├── tests/login.spec.ts             ← 7 tests ✅
    └── package.json
```

---

## ⚡ Instalación Rápida (3 pasos)

```bash
# 1. Clonar
git clone git@github.com:totone-uy1990/qa-crew-opencode.git
cd qa-crew-opencode

# 2. Instalar dependencias del demo
cd demo-app
npm install
npx playwright install chromium

# 3. Verificar que los tests de ejemplo pasan
npx playwright test
```

✅ Deberías ver: **7 passed**

---

## 🚀 Usar con OpenCode

Abrí OpenCode desde la carpeta del proyecto:

```bash
cd qa-crew-opencode
opencode
```

OpenCode mergea la configuración del proyecto con la global y tenés disponibles los 4 sub-agentes de testing.

### Ejemplos de uso

| Decile al orquestador | Qué hace |
|---|---|
| "Creame un plan de pruebas para esta user story..." | `test-planner` genera CPs con ISTQB |
| "Explorá la app en busca de bugs" | `test-explorer` navega con Playwright MCP |
| "Pasá estos CPs a código Playwright" | `test-coder` escribe los tests |
| "Revisá estos tests" | `test-reviewer` analiza con Right-BICEP |
| "Cambiame al perfil eco" | Aplica perfil de modelos económicos |

---

## 🧠 Skills por Sub-Agente

| Agente | Metodologías | Fuente |
|---|---|---|
| **test-planner** | Equivalence Partitioning, BVA, Decision Tables, State Transition | **ISTQB** |
| | Risk-Based Testing | Industria |
| | Agile Testing Quadrants (Q1-Q4) | Brian Marick |
| **test-coder** | Page Object Model (POM) | Automatización UI |
| | AAA (Arrange-Act-Assert) | Estándar |
| | FIRST Principles | Tim Ottinger |
| | Playwright Best Practices | Microsoft |
| **test-explorer** | Session-Based Test Management (SBTM) | James Bach |
| | SFDPOT Heuristic Model | Testing industrial |
| | Heuristic Test Strategy Model | James Bach / M. Bolton |
| **test-reviewer** | Right-BICEP | Jeff Langr |
| | CRUD Coverage | Estándar |
| | Test Smells Catalog | Industria |

---

## 📝 Configuración de OpenCode

OpenCode soporta **dos niveles de configuración** que se mergean automáticamente:

| Nivel | Archivo | Qué va ahí |
|---|---|---|
| **Global** | `~/.config/opencode/opencode.json` | MCP servers (Playwright, Atlassian, Engram, Perplexity), SDK providers, permisos globales, agentes del sistema (gentle-orchestrator, SDD, review agents) |
| **Proyecto** | `<proyecto>/opencode.json` | Sub-agentes específicos del proyecto (test-planner, test-coder, etc.) y permisos para que gentle-orchestrator los llame |

### ¿Qué tiene cada uno?

**Global** (`~/.config/opencode/opencode.json`) → MCP servers + gentle-orchestrator + agentes built-in:

```json
{
  "agent": {
    "gentle-orchestrator": { "mode": "primary", "permission": { "task": { "test-*": "allow" } }, ... },
    "sdd-apply": { ... },
    "review-readability": { ... }
  },
  "mcp": {
    "playwright": { "type": "local", "command": ["npx", "@playwright/mcp@latest"] },
    "engram": { "type": "local", "command": ["engram", "mcp"] },
    "perplexity": { "type": "local", "command": [...] }
  }
}
```

**Proyecto** (`qa-crew-opencode/opencode.json`) → Solo los 4 sub-agentes + permiso para el orquestador:

```json
{
  "agent": {
    "gentle-orchestrator": {
      "permission": {
        "task": {
          "test-planner": "allow",
          "test-explorer": "allow",
          "test-coder": "allow",
          "test-reviewer": "allow"
        }
      }
    },
    "test-planner": { "mode": "subagent", "model": "...", "prompt": "...", ... },
    "test-explorer": { "mode": "subagent", ... },
    "test-coder": { "mode": "subagent", ... },
    "test-reviewer": { "mode": "subagent", ... }
  }
}
```

> **¿Por qué separado?** Porque los MCP servers pueden tener credenciales (API keys, tokens) que no querés comitear al repo. El `opencode.json` del proyecto viaja con git y cualquiera que lo clone obtiene los sub-agentes. Cada uno configura sus MCP servers aparte en su global.

---

## 🔌 MCP Servers

Los sub-agentes se conectan a servicios externos via MCP. Esto se configura en `~/.config/opencode/opencode.json`, NO en el proyecto.

| MCP | Lo usa | Propósito |
|---|---|---|
| **Playwright** | `test-explorer` | Navegar apps web, tomar screenshots, clickear, llenar formularios |
| **Atlassian (Jira)** | `test-planner` | Leer user stories, acceptance criteria, comentarios |
| **Engram** | *(opcional)* | Memoria persistente entre sesiones |
| **Perplexity** | *(opcional)* | Búsqueda web durante exploración |

### Configurar Atlassian MCP (Jira)

El server oficial de Atlassian (Rovo MCP) permite leer issues, proyectos, sprints y comentarios de Jira Cloud.

#### Lo que necesitás de Jira

- Una **cuenta de Atlassian** con acceso a **Jira Cloud** (el server oficial NO funciona con Jira Data Center / Server on-premise)
- Un **proyecto de Jira** con issues creadas
- El **issue key** de la user story (ej: `PROY-123`) — el orquestador le pasa esto al `test-planner`
- Autenticación **OAuth 2.1 via navegador** (sin tokens manuales ni API keys)
- **Permisos de lectura** en el proyecto Jira (Viewer role alcanza)

#### Configuración

Agregalo a tu `~/.config/opencode/opencode.json`:

```json
{
  "mcp": {
    "atlassian": {
      "enabled": true,
      "type": "remote",
      "url": "https://mcp.atlassian.com/v1/mcp/authv2"
    }
  }
}
```

La primera vez que inicies OpenCode se te va a abrir el navegador para autenticarte con OAuth. Una vez autenticado, el token se guarda localmente.

#### Flujo Jira → test-planner

```
Tú: "Analizá PROY-123 y genera un plan de pruebas"

Orquestador:
  1. Llama al MCP Atlassian → obtiene description + acceptance criteria del issue
  2. Pasa ese texto al test-planner
  3. test-planner genera plan con ISTQB, risk-based, etc.
```

---

## 🏗️ Arquitectura

```
Jira (user stories)
  │  ↓ MCP Atlassian
  ▼
Tú (usuario)
  │  ↓ texto / prompts
  ▼
Orquestador (gentle-orchestrator)
  │  Coordina, delega, sintetiza
  │
  ├── 📋 test-planner ──── Plan de pruebas + casos (modelo de razonamiento)
  ├── 🧪 test-explorer ─── Exploratory testing con Playwright MCP (modelo rápido)
  ├── ✍️ test-coder ────── Convierte CPs a código Playwright (modelo de código)
  └── 🔍 test-reviewer ─── Revisa tests generados (modelo económico)
```

Cada sub-agente:
- Arranca con **contexto fresco** (no arrastra basura de tareas anteriores)
- Tiene su **propio modelo LLM** (optimizás costo/calidad por tarea)
- Carga una **skill** con metodologías de testing reconocidas
- **Nunca llama a otro agente** — solo el orquestador coordina

---

## 🔧 Perfiles de Modelos

Cambiá los LLM de los sub-agentes según necesites:

```bash
./profiles/switch-profile.sh full-power    # 🚀 Modelos de pago (~$10-15/mes)
./profiles/switch-profile.sh balanced      # ⚖️ Mix pago+free (~$5-8/mes)
./profiles/switch-profile.sh eco           # 🌱 Todo free (~$0-3/mes)
./profiles/switch-profile.sh dev-local     # 💻 Rápido para desarrollo
```

> **Importante**: reiniciá OpenCode después de cambiar de perfil.

### Asignación por perfil

| Perfil | planner | explorer | coder | reviewer |
|---|---|---|---|---|
| **full-power** 🚀 | qwen3.5-35b-a3b | gemini-flash | qwen-coder-next | gemini-flash |
| **balanced** ⚖️ | qwen3.5-35b-a3b | qwen3.5-9b | qwen-coder:free | qwen3.5-9b |
| **eco** 🌱 | llama-70b:free | qwen3.5-9b | qwen-coder:free | qwen3.5-9b |
| **dev-local** 💻 | qwen3.5-9b | gemini-flash | qwen-coder-next | qwen3.5-9b |

---

## 🧪 Demo

La carpeta `demo-app/` contiene una app web simple (login + tasks) con 7 tests Playwright que pasan. Sirve como target de ejemplo para probar los sub-agentes.

---

## 📚 Más Información

Para detalles sobre flujos de trabajo completos, extensión con nuevos sub-agentes, y referencia de modelos: leer la [documentación completa](./docs/ARCHITECTURE.md) (próximamente).
