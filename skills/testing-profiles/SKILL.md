---
name: testing-profiles
description: "Trigger: cambiar modelo, switch profile, cambiar agente, testing profiles, perfiles testing. Manage LLM model profiles for testing sub-agents — switch between eco, balanced, full-power, or custom profiles."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Use this skill when the user wants to:
- Change which LLM model the testing sub-agents use
- Switch to a cheaper/faster/more capable model profile
- Create a new model profile
- Check which models are currently assigned

## Hard Rules

- Never modify the original `~/.config/opencode/opencode.json` — only the project-level `opencode.json` in testing-harness
- Always show the current model assignment before and after switching
- The user must restart OpenCode after switching profiles for changes to take effect
- Profile changes only affect the testing sub-agents (test-planner, test-explorer, test-coder, test-reviewer)

## Available Profiles

| Profile | Cost/mes | Best for |
|---------|----------|----------|
| **full-power** | ~$10-15 | Work: best models for every agent |
| **balanced** | ~$5-8 | Mix: paid planner, free coder, cheap reviewer |
| **eco** | ~$0-3 | Budget: free models everywhere |
| **dev-local** | ~$5-8 | Dev: fast iteration with small models |

## Execution Steps

### Switch profile via CLI

```bash
cd ~/Escritorio/testing-harness
./profiles/switch-profile.sh full-power
# or
./profiles/switch-profile.sh eco
```

### Switch profile via orchestrator (me)

1. User says "cambiame al perfil eco" or similar
2. Run the switch script via bash tool
3. Show the user the result
4. Remind them to restart OpenCode

### Check current models

Read `profiles/<name>.json` to see the model assignments, or check the `model` field under each agent in `opencode.json`.

## Per-Agent Model Recommendations

| Agent | Recommended Model | Why |
|---|---|---|
| **test-planner** | qwen3.5-35b-a3b | Needs reasoning for test design (EP, BVA, risk) |
| **test-explorer** | gemini-3.5-flash | Fast, cheap for browsing |
| **test-coder** | qwen3-coder-next | Best at generating Playwright code |
| **test-reviewer** | gemini-3.5-flash or qwen3.5-9b | Good analysis without being expensive |

## Output Contract

Return:
- Profile name and description applied
- List of model changes (agent: old → new)
- Any agents skipped (defined in profile but not found in opencode.json)
- Reminder to restart OpenCode
