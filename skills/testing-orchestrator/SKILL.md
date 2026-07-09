---
name: testing-orchestrator
description: "Trigger: test, testing, QA, automation, test plan, exploratory testing, user story, Jira. Coordinate multi-agent testing workflow: plan, explore, code, review."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Load this skill when the user says they want to:
- Create test cases from a user story or Jira ticket
- Run exploratory testing on an app
- Generate Playwright tests from test cases
- Review existing test code
- Any testing workflow involving multiple steps

## Hard Rules

- You are the COORDINATOR. Never do testing work inline — delegate to the appropriate sub-agent.
- Run the workflow in order. Do not skip steps unless explicitly approved.
- Show the user results from each phase before proceeding to the next (interactive mode).
- Each sub-agent starts with a FRESH context. Pass only what they need in the prompt.

## Decision Gates

| User says | Action |
|-----------|--------|
| "crea casos de prueba para esta user story" | Run workflow: planner -> review plan with user -> coder -> reviewer |
| "hace exploratory testing en [url]" | Run exploratory-agent only |
| "pasa estos CPs a codigo" | Run coder -> reviewer (loop if issues found) |
| "revisa estos tests" | Run reviewer only |
| "automatiza todo el flujo" | Run planner -> coder -> reviewer in one pass (auto mode) |

## Execution Steps

### Skill Path Resolution

Each sub-agent has a skill file it needs to load before working. When launching a sub-agent, include a `## Skills to load before work` section with the exact path to its skill file:

- **test-planner**: `skills/test-planner/SKILL.md`
- **test-explorer**: `skills/test-explorer/SKILL.md`
- **test-coder**: `skills/test-coder/SKILL.md`
- **test-reviewer**: `skills/test-reviewer/SKILL.md`

### Workflow: User Story -> Test Cases -> Code -> Review

1. **Planner Phase**: Call `test-planner` via `task` with the user story text. Pass: story description, acceptance criteria, any existing context AND the skill path to `skills/test-planner/SKILL.md`.
   - Return: structured test plan with test cases (markdown)

2. **Review Plan with User**: Show the test plan and cases. Ask for approval or changes via `question` tool. Do not proceed until approved.

3. **Coder Phase**: Call `test-coder` via `task` with the approved test cases AND the skill path to `skills/test-coder/SKILL.md`. Pass: test case IDs and descriptions, project structure context.
   - Return: Playwright test files + verification that tests pass

4. **Reviewer Phase**: Call `test-reviewer` via `task` with the generated test files AND the skill path to `skills/test-reviewer/SKILL.md`. Pass: file paths, original test cases for comparison.
   - Return: review findings with severity levels

5. **Fix Loop**: If reviewer returns BLOCKER or CRITICAL findings, go back to step 3 with the feedback. Loop up to 2 times max to avoid infinite loops. On the third pass, surface remaining issues to the user.

### Workflow: Exploratory Testing Only

1. **Explorer Phase**: Call `test-explorer` via `task` with the target URL or feature description. Pass: URL, feature scope, specific areas to focus on.
   - Return: bug report with severity levels

2. **Show Results**: Present findings to the user immediately.

## Output Contract

After each workflow, return to the user:
- What was done (phases executed)
- Artifacts created (files, reports)
- Key findings or decisions
- Next recommended action

## References

- Playwright MCP: configured in global opencode.json for browser interaction
- Project config: `opencode.json` in project root defines the sub-agents
