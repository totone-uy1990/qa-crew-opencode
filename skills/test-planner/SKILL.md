---
name: test-planner
description: "Trigger: test plan, test cases, test design, test strategy, QA planning. Create structured test plans using ISTQB techniques, risk-based analysis, and agile test quadrants."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Use this skill when planning tests: user story analysis, test case design, test strategy, or risk assessment.

## Hard Rules

- Every test plan MUST include: scope, test levels, test techniques used, entry/exit criteria, risks, and assumptions.
- Use AT LEAST one structured test design technique from the repertoire below per feature.
- Document ALL assumptions when requirements are ambiguous — do not silently guess.
- Prioritize tests by risk: CRITICAL -> HIGH -> MEDIUM -> LOW.

## Test Plan Structure (based on IEEE 829)

1. **Test Scope**: What is in and out of scope
2. **Test Strategy**: What levels (unit, integration, e2e) and what techniques
3. **Test Design Techniques Applied** (see below)
4. **Test Cases**: ID, title, preconditions, steps, expected result, priority
5. **Entry / Exit Criteria**: When testing starts and when it is done
6. **Risks and Mitigations**: Technical, business, schedule risks
7. **Assumptions and Constraints**: What was assumed due to missing info

## Test Design Techniques (ISTQB)

### Equivalence Partitioning (EP)
- Divide input data into partitions where all values in a partition behave the same way
- Test ONE valid value from each valid partition
- Test ONE invalid value from each invalid partition
- Example: 0-17 (minor), 18-65 (adult), 65+ (senior) → test 15, 30, 70

### Boundary Value Analysis (BVA)
- Test the boundaries of each partition: min-1, min, min+1, max-1, max, max+1
- Most defects live at the edges
- Example: field accepts 1-100 → test 0, 1, 2, 99, 100, 101

### Decision Table Testing
- For combinations of conditions that produce different outcomes
- Each column = a unique combination of conditions
- Every combination must be covered unless declared impossible
- Use for: business rules, discount calculations, permission logic

### State Transition Testing
- For systems that change state based on events
- Cover: all states, all transitions, invalid transitions
- Use for: workflow status, order states, authentication flow

### Use Case Testing
- Test end-to-end scenarios that a user would perform
- Cover: happy path, alternate flows, exception flows
- Use for: user stories, acceptance criteria validation

## Risk-Based Testing

| Risk Level | Criteria | Test Effort |
|---|---|---|
| CRITICAL | Security, auth, payments, data loss | 100% coverage |
| HIGH | Core business logic, main flows | All equivalence classes |
| MEDIUM | Secondary features, edge cases | BVA + happy path |
| LOW | Cosmetic, rarely used, admin only | Smoke test |

## Agile Testing Quadrants (Brian Marick)

| Q1 (Technology-facing, support dev) | Q2 (Business-facing, support dev) |
|---|---|
| Unit tests, component tests | Functional tests, story tests, prototypes |
| **Q3 (Business-facing, critique product)** | **Q4 (Technology-facing, critique product)** |
| Exploratory testing, usability, UAT | Performance, security, load, stress |

- Ensure every feature has coverage in Q2 (acceptance) and Q3 (exploratory)
- For critical features, add Q1 (unit/integration) and Q4 (non-functional)

## Output Contract

Return:
- Test plan with all sections from IEEE 829 structure
- Risk assessment per feature/area
- Structured test cases with ID, priority, steps, and expected results
- Assumptions documented clearly
- Recommended automation candidates (what to automate, what to keep manual)
