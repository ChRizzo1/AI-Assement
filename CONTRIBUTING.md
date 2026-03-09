# Contributing to AI Adoption Platform

Thank you for your interest in contributing to the AI Adoption Platform! This document outlines the process and guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Submitting Pull Requests](#submitting-pull-requests)
- [Development Setup](#development-setup)
- [Branching Strategy](#branching-strategy)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Testing Guidelines](#testing-guidelines)
- [Review Process](#review-process)

---

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment. Please:

- Be kind and constructive in all communications.
- Welcome differing viewpoints and experiences.
- Gracefully accept constructive feedback.
- Focus on what is best for the project and its users.

---

## How to Contribute

### Reporting Bugs

If you discover a bug, please [open an issue](https://github.com/ChRizzo1/AI-Assement/issues/new) and include:

- A clear and descriptive title.
- Steps to reproduce the behaviour.
- Expected behaviour vs. actual behaviour.
- Screenshots or logs if applicable.
- Your environment (OS, Node.js version, browser).

### Suggesting Features

Feature requests are welcome! Please [open an issue](https://github.com/ChRizzo1/AI-Assement/issues/new) and include:

- A clear description of the feature and the problem it solves.
- Any relevant context or examples.
- How this aligns with the product tiers described in [README.md](./README.md).

### Submitting Pull Requests

1. **Fork** the repository and create your branch from `main`.
2. Follow the [Branching Strategy](#branching-strategy) guidelines.
3. Implement your changes with appropriate tests.
4. Ensure all tests pass and linting rules are satisfied.
5. Submit a pull request with a clear description of what was changed and why.

---

## Development Setup

### Prerequisites

- Node.js 18+
- PostgreSQL 15+
- Redis 7+

### Local Setup

```bash
# Fork and clone the repository
git clone https://github.com/<your-username>/AI-Assement.git
cd AI-Assement

# Install dependencies
npm install

# Copy and configure environment variables
cp .env.example .env
# Fill in required values (database URL, auth secrets, Stripe keys, etc.)

# Run database migrations
npm run db:migrate

# Seed development data (optional)
npm run db:seed

# Start the development server
npm run dev
```

The app will be available at `http://localhost:3000`.

---

## Branching Strategy

| Branch type | Pattern | Example |
|-------------|---------|---------|
| Feature | `feature/<short-description>` | `feature/vendor-comparison-tool` |
| Bug fix | `fix/<short-description>` | `fix/assessment-score-rounding` |
| Chore / refactor | `chore/<short-description>` | `chore/update-dependencies` |
| Documentation | `docs/<short-description>` | `docs/api-readme` |
| Release | `release/<version>` | `release/1.2.0` |

- Branch off from `main` for all new work.
- Keep branches short-lived and focused on a single concern.
- Delete branches after they are merged.

---

## Coding Standards

### General

- Write clear, self-documenting code. Prefer readability over cleverness.
- Follow the principle of least surprise.
- Keep functions and components small and focused on a single responsibility.

### Frontend (React / Next.js)

- Use **TypeScript** for all new code.
- Follow the component naming convention: `PascalCase` for components, `camelCase` for hooks and utilities.
- Co-locate tests with components (e.g., `ComponentName.test.tsx` alongside `ComponentName.tsx`).
- Use CSS Modules or Tailwind CSS utility classes — avoid inline styles.
- Ensure all interactive elements are keyboard-accessible and meet WCAG 2.1 Level AA.

### Backend (Node.js / Next.js API)

- Use **TypeScript** for all new code.
- Validate all incoming request data at the API boundary (use Zod or similar).
- Never log or expose sensitive data (PII, credentials, tokens).
- Follow RESTful conventions for API routes.
- Document all public API endpoints with OpenAPI/Swagger annotations.

### Database

- All schema changes must be made via **Prisma migrations** (never edit the database directly).
- Name migrations descriptively: `<timestamp>_add_user_roles_table`.
- Write down any index strategy decisions in the migration file as comments.

---

## Commit Messages

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

**Types:**

| Type | When to use |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `style` | Formatting, missing semicolons, etc. (no logic change) |
| `refactor` | Code change that is neither a fix nor a feature |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks (dependency updates, CI changes) |
| `perf` | Performance improvement |

**Examples:**

```
feat(assessment): add conditional logic to questionnaire engine

fix(payments): handle Stripe webhook retry correctly

docs(readme): add getting started section
```

---

## Testing Guidelines

- **Unit tests:** Cover all pure functions and utility helpers.
- **Integration tests:** Cover API routes and database interactions.
- **End-to-end tests:** Cover critical user journeys (assessment flow, onboarding, payment).
- Target **≥ 80% code coverage** for new code.
- Tests live next to the code they test or in a `__tests__` directory at the same level.

Run the test suite:

```bash
# Unit and integration tests
npm test

# End-to-end tests
npm run test:e2e

# Coverage report
npm run test:coverage
```

---

## Review Process

1. All pull requests require **at least one approving review** from a maintainer before merging.
2. Address all reviewer comments before requesting a re-review.
3. Keep pull requests small and focused — large PRs are harder to review and more likely to introduce bugs.
4. CI checks (lint, build, tests) must be green before a PR can be merged.
5. Squash commits when merging to keep the `main` branch history clean.

---

Thank you for helping make the AI Adoption Platform better! 🚀
