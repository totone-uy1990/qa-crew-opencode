---
name: test-coder
description: "Trigger: write tests, generate test code, automate tests, Playwright, test implementation. Convert test cases to production-grade automated tests using POM, AAA, and FIRST principles."
license: Apache-2.0
metadata:
  author: "gentle-ai"
  version: "1.0"
---

## Activation Contract

Use this skill when converting test cases into automated test code, or when reviewing existing test code for structure and maintainability.

## Hard Rules

- EVERY test MUST follow AAA (Arrange-Act-Assert) structure clearly separated by comments or blank lines
- Tests MUST be independent: no shared state, no test ordering dependencies
- Use accessible selectors ONLY (`getByRole`, `getByText`, `getByLabel`, `getByPlaceholder`, `locator` with accessible attributes)
- NEVER use XPath, CSS class names, or fragile selectors
- Every test file MUST start with a `test.describe` block
- Default to headless unless explicitly asked for headed mode

## Page Object Model (POM)

Structure:

```
tests/
├── pages/
│   ├── LoginPage.ts          ← page object
│   └── TasksPage.ts
├── login.spec.ts             ← tests
└── tasks.spec.ts
```

Page Object pattern:

```typescript
class LoginPage {
  constructor(private page: Page) {}

  // Locators (exposed as methods or getters)
  get emailInput() { return this.page.getByPlaceholder('Email'); }
  get passwordInput() { return this.page.getByPlaceholder('Password'); }
  get loginButton() { return this.page.getByRole('button', { name: 'Login' }); }

  // Actions
  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }
}
```

Do NOT over-engineer POM for simple tests — use direct page interactions when a full page object adds more lines than it saves.

## AAA Pattern (Arrange-Act-Assert)

```typescript
test('should login with valid credentials', async ({ page }) => {
  // Arrange
  await page.goto('/');
  const email = 'test@example.com';
  const password = 'password123';

  // Act
  await page.getByPlaceholder('Email').fill(email);
  await page.getByPlaceholder('Password').fill(password);
  await page.getByRole('button', { name: 'Login' }).click();

  // Assert
  await expect(page.getByRole('heading', { name: 'Tasks' })).toBeVisible();
});
```

## FIRST Principles (Tim Ottinger / Clean Code)

| Letter | Principle | Rule |
|---|---|---|
| F | Fast | Tests should run quickly. If slow, mock or refactor |
| I | Isolated | No test depends on another. No shared mutable state |
| R | Repeatable | Same result every time, on any environment |
| S | Self-validating | Pass/fail is automatic. No manual inspection needed |
| T | Timely | Written close to the code they test |

## Playwright Best Practices

1. **Use web-first assertions** (`toBeVisible`, `toHaveText`, `toHaveValue`) — never raw `expect(await ...)`
2. **Prefer user-facing locators**: `getByRole` > `getByText` > `getByTestId` > CSS/XPath
3. **Do NOT use `page.waitFor()`** — use `waitForLoadState`, `waitForResponse`, or locator assertions
4. **Isolate test data** — each test creates its own data and cleans up if needed
5. **Group setup with `beforeEach`**, not beforeAll (keeps tests independent)
6. **Use `test.describe` for logical grouping**, one describe per feature/flow
7. **Avoid `test.only` and `test.skip`** — they should never reach CI
8. **Trace and screenshot on failure** — configure `trace: 'retain-on-failure'` in playwright config

## BDD Style (Given/When/Then)

For complex business flows:

```typescript
test('should apply senior discount for users over 65', async ({ page }) => {
  // Given: a logged-in user over 65
  await loginAs('senior@example.com');

  // When: they add an item to the cart
  await page.getByRole('button', { name: 'Add to Cart' }).click();

  // Then: the 10% senior discount is applied
  await expect(page.getByText('Senior Discount: 10%')).toBeVisible();
});
```

## Output Contract

Return:
- List of test files created or modified
- For each test: what scenario it covers, test technique used (EP, BVA, etc.)
- Any deviations from the original test plan and why
- Verification that tests pass (`npx playwright test` ran)
