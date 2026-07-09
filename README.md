# QA Crew — Multi-Agent Testing para OpenCode

**qa-crew** es un sistema multi-agente para QA/testing automation construido sobre OpenCode. Cuatro sub-agentes especializados (planner, explorer, coder, reviewer) trabajan en equipo, cada uno con su propio LLM, contexto aislado, y skills basadas en metodologías de testing reconocidas (ISTQB, POM, SBTM, Right-BICEP).

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

OpenCode cargará la configuración del proyecto y tendrás disponibles los 4 sub-agentes de testing.

### Ejemplos de uso

| Decile al orquestador | Qué hace |
|---|---|
| "Creame un plan de pruebas para esta user story..." | `test-planner` genera CPs con ISTQB |
| "Explorá la app en busca de bugs" | `test-explorer` navega con Playwright MCP |
| "Pasá estos CPs a código Playwright" | `test-coder` escribe los tests |
| "Revisá estos tests" | `test-reviewer` analiza con Right-BICEP |
| "Cambiame al perfil eco" | Aplica perfil de modelos económicos |

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

## 🏗️ Arquitectura

```
Tú (usuario)
  │
  ▼
Orquestador (gentle-orchestrator)
  │  Coordina, delega, sintetiza
  │
  ├── 📋 test-planner ──── Plan de pruebas + casos (modelo de razonamiento)
  ├── 🧪 test-explorer ─── Exploratory testing con Playwright (modelo rápido)
  ├── ✍️ test-coder ────── Convierte CPs a código Playwright (modelo de código)
  └── 🔍 test-reviewer ─── Revisa tests generados (modelo económico)
```

Cada sub-agente:
- Arranca con **contexto fresco** (no arrastra basura de tareas anteriores)
- Tiene su **propio modelo LLM** (optimizás costo/calidad por tarea)
- Carga una **skill** con metodologías de testing reconocidas
- **Nunca llama a otro agente** — solo el orquestador coordina

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

## 📂 Estructura del Proyecto

```
qa-crew-opencode/
├── opencode.json                      ← Definición de los 4 sub-agentes
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

## 📋 Requisitos

- **OpenCode** instalado y configurado con OpenRouter
- **Node.js** >= 18
- **Bash** (para el switch de perfiles)

---

## 📚 Más Información

Para detalles sobre flujos de trabajo completos, extensión con nuevos sub-agentes, y referencia de modelos: leer la [documentación completa](./docs/ARCHITECTURE.md) (próximamente).

---

## 🧪 Demo

La carpeta `demo-app/` contiene una app web simple (login + tasks) con 7 tests Playwright que pasan. Sirve como target de ejemplo para probar los sub-agentes.
