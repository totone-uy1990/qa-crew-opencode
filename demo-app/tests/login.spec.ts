import { test, expect } from '@playwright/test';

test.describe('Login flow', () => {
  test('should show login form on load', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
    await expect(page.getByPlaceholder('Email')).toBeVisible();
    await expect(page.getByPlaceholder('Password')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Login' })).toBeVisible();
  });

  test('should login with valid credentials', async ({ page }) => {
    await page.goto('/');

    await page.getByPlaceholder('Email').fill('test@example.com');
    await page.getByPlaceholder('Password').fill('password123');
    await page.getByRole('button', { name: 'Login' }).click();

    await expect(page.getByRole('heading', { name: 'Tasks' })).toBeVisible();
  });

  test('should show error with invalid credentials', async ({ page }) => {
    await page.goto('/');

    await page.getByPlaceholder('Email').fill('wrong@example.com');
    await page.getByPlaceholder('Password').fill('wrongpass');
    await page.getByRole('button', { name: 'Login' }).click();

    await expect(page.getByText('Invalid email or password')).toBeVisible();
    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
  });

  test('should show error with empty credentials', async ({ page }) => {
    await page.goto('/');

    await page.getByRole('button', { name: 'Login' }).click();

    // HTML5 validation should prevent submission
    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
  });
});

test.describe('Tasks flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.getByPlaceholder('Email').fill('test@example.com');
    await page.getByPlaceholder('Password').fill('password123');
    await page.getByRole('button', { name: 'Login' }).click();
  });

  test('should add a new task', async ({ page }) => {
    await page.getByPlaceholder('New task').fill('Buy groceries');
    await page.getByRole('button', { name: 'Add Task' }).click();

    await expect(page.getByText('Buy groceries')).toBeVisible();
  });

  test('should delete a task', async ({ page }) => {
    await page.getByPlaceholder('New task').fill('Temporary task');
    await page.getByRole('button', { name: 'Add Task' }).click();

    await page.getByRole('button', { name: 'Delete' }).click();

    await expect(page.getByText('Temporary task')).not.toBeVisible();
  });

  test('should logout', async ({ page }) => {
    await page.getByRole('button', { name: 'Logout' }).click();

    await expect(page.getByRole('heading', { name: 'Login' })).toBeVisible();
  });
});
