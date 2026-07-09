---
name: test-explorer
description: "Trigger: exploratory testing, explore, discover bugs, ad-hoc testing, charter testing. Use structured exploratory testing with charters, heuristics, and session-based documentation."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Use this skill when doing exploratory testing: finding bugs through unscripted but structured exploration, documenting findings with heuristics and charters.

## Hard Rules

- Every exploratory session MUST have a CHARTER (mission statement) before starting
- Document EVERY finding even if you are not sure it is a real bug
- Use the SFDPOT heuristic to ensure broad coverage
- Always explore: happy path first, then edges, then errors
- Take screenshots of bugs using the Playwright MCP when applicable
- A session with ZERO findings is valid — document it as "stable area"

## Session-Based Test Management (SBTM)

Each exploratory session follows this structure:

```
Session Charter: [short mission statement]
Duration: [target time, e.g. 45 min]
Area: [what part of the app]
Test Data: [accounts, URLs, test data used]
Heuristics Applied: [which heuristics from below]
Findings:
  [BUG] [SEVERITY] Title | Steps | Expected vs Actual
  [NOTE] Observation that is not a bug but worth noting
Coverage: [what was covered, what was not]
Issues Logged: [links or IDs to any bugs filed]
```

### Charter Template
```
Explore the [FEATURE] to find [BUG TYPE] by using [APPROACH]
Example: Explore the LOGIN feature to find AUTH BYPASS bugs by trying INVALID INPUTS and SPECIAL CHARACTERS
```

## SFDPOT Heuristic Coverage Model

Use this to ensure you cover different quality dimensions:

| Letter | Dimension | What to test |
|---|---|---|
| S | Sanity | Does it work at all? Happy path |
| F | Function | Does each feature do what it should? All buttons, links, forms |
| D | Data | Input types, formats, encoding, special chars, empty states, max length |
| P | Platform | Browser differences, screen sizes, responsive behavior |
| O | Operations | Load, concurrent users, timeout, retry, error handling |
| T | Time | Session expiry, daylight saving, timezone, date boundaries |

For each exploratory session, pick at least 3 SFDPOT dimensions to cover.

## Heuristic Test Strategy Model (James Bach / Michael Bolton)

### Input Heuristics
- **Garbage In**: What happens with invalid/empty/unexpected input?
- **Boundary**: What happens at the edges?
- **Stress**: What happens with lots of data, fast clicks, concurrent actions?
- **Variation**: What if the user does things in a different order?

### State Heuristics
- **State Transition**: What happens moving between states (logged in -> logged out -> back)?
- **Sequencing**: What if steps are performed in non-standard order?
- **Persistence**: Is state preserved correctly across page reloads?

### Operation Heuristics
- **CRUD**: Can you create, read, update, delete?
- **Undo**: Can you reverse an action?
- **Consistency**: Is the behavior consistent with similar features?
- **Visibility**: Is the current state visible to the user?

## Bug Severity Classification

| Severity | Definition | Response |
|---|---|---|
| CRITICAL | App crashes, data loss, security breach | Stop testing, report immediately |
| MAJOR | Core feature broken, no workaround | Report, add to fixing queue |
| MINOR | Feature works but with issues, has workaround | Document for next sprint |
| SUGGESTION | Usability improvement, cosmetic | Nice to have |

## Output Contract

Return:
- Session report (charter, duration, area covered)
- All findings with severity, steps to reproduce, expected vs actual
- Screenshots or evidence attached when relevant
- Coverage summary: what was tested and what was not
- Risk assessment: areas that need more testing
