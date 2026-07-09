---
name: test-reviewer
description: "Trigger: review tests, audit tests, test quality, coverage check, test review. Review test code using Right-BICEP, coverage analysis, and CRUD patterns."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Use this skill when reviewing test code for quality, coverage completeness, and adherence to testing best practices.

## Hard Rules

- BLOCKER findings STOP the review process — do not continue until fixed
- Every finding MUST include: severity, file:line, evidence, and why it matters
- Do NOT flag code style preferences as bugs — focus on behavioral correctness
- Cross-reference each test against its original test case — if a test case is missing, flag BLOCKER
- If all checks pass, say EXACTLY: "REVIEW: APROBADO"

## Right-BICEP (Jeff Langr / "Pragmatic Unit Testing")

Use this framework to evaluate what each test is checking:

| Letter | What to check | Example question |
|---|---|---|
| **R**ight | Are the results correct? | Does the assertion test the right outcome? |
| **B**oundary | Are boundaries tested? | Min-1, min, max, max+1, empty, null, 0, negative |
| **I**nverse | Can the result be reversed? | If you create and delete, is the state back to original? |
| **C**ross-check | Can you verify by another means? | UI shows X but does the API return X? |
| **E**rror | Are error conditions tested? | 404, 500, timeout, network failure, invalid auth |
| **P**erformance | Is performance tested? | Response time, render time, load thresholds |

For every test, ask: does it cover at least **Right** + one more from BICEP?

## CRUD Coverage Checklist

For every entity/feature, verify tests cover:

| Operation | What to check |
|---|---|
| **C**reate | Create with valid data, create with missing required fields, create with duplicate key, create with maximum field lengths |
| **R**ead | Read existing, read non-existing, read with filters, read with no results |
| **U**pdate | Update valid, update with invalid data, update non-existing, update to same value (idempotent) |
| **D**elete | Delete existing, delete non-existing, delete and verify gone, delete and verify related data |

If the feature has CRUD and the test suite has gaps, flag as WARNING or CRITICAL.

## Test Smells to Detect

| Smell | Severity | Why |
|---|---|---|
| `test.only` or `fit` | BLOCKER | CI will only run this test |
| `test.skip` or `xit` | WARNING | Skipped test needs justification |
| Shared mutable state between tests | CRITICAL | Tests are coupled, order-dependent |
| Absence of assertions | BLOCKER | Test passes vacuously |
| Fragile selectors (CSS, XPath) | WARNING | Tests break on UI changes |
| Hardcoded test data (URLs, credentials) | CRITICAL | Not portable, security risk |
| No error scenario coverage | WARNING | Only happy path tested |
| Test over 100 lines | SUGGESTION | Too complex, should be split |
| Sleep/wait in assertions | CRITICAL | Race condition risk, use web-first assertions |

## Coverage Analysis

| Coverage Type | What to check |
|---|---|
| **Requirement coverage** | Does every acceptance criterion have a test? |
| **Boundary coverage** | Are min/max/edge values tested for numeric inputs? |
| **Error coverage** | Are 4xx/5xx responses, timeouts, empty states tested? |
| **Branch coverage** | Are if/else, switch, ternary branches covered? |
| **Data variation** | Are different input types/formats covered? |

## Severity Levels

| Severity | Criteria | Action |
|---|---|---|
| BLOCKER | Missing assertions, test.only, no test for a requirement | Must fix before proceeding |
| CRITICAL | Shared state, fragile selectors, no error tests | Should fix in current cycle |
| WARNING | Skipped tests, weak coverage, long tests | Fix when convenient |
| SUGGESTION | Style, naming, organization improvements | Nice to have |

## Output Contract

Return:
- Overall verdict: APROBADO / CONDITIONAL / REPROBADO
- List of findings grouped by severity (BLOCKER first)
- For each finding: file path, line number, evidence, suggested fix
- Coverage gaps mapped to requirements
- Final recommendation (approve, fix and re-review, reject)
