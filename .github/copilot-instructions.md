# Copilot Instructions for AI Adoption Platform

This file provides context and guidelines for GitHub Copilot (and the Copilot coding agent) when working in this repository.

---

## Project Overview

This is the **AI Adoption Platform** — a tiered SaaS product that helps small and medium businesses (SMBs) plan and execute AI adoption strategies. The platform is built with a modern TypeScript full-stack architecture.

See [README.md](../README.md) for full product context and [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution workflows.

---

## Tech Stack

- **Frontend:** Next.js (React), TypeScript, Tailwind CSS or MUI, Recharts
- **State management:** Redux Toolkit or Zustand
- **Backend:** Next.js API routes or Node.js / Express, TypeScript
- **Database:** PostgreSQL via Prisma ORM, Redis for caching and sessions
- **Authentication:** Auth0, Clerk, or Supabase Auth
- **Payments:** Stripe
- **Search:** Algolia or Elasticsearch
- **AI/ML service:** Python microservice (scikit-learn, pandas)
- **Testing:** Jest (unit/integration), Playwright or Cypress (e2e)

---

## Coding Conventions

### Language and Types

- Use **TypeScript** for all new frontend and backend code. Avoid `any` — prefer proper types or `unknown`.
- Use **Zod** (or equivalent) to validate all external inputs at API and form boundaries.
- Export types alongside the code that defines them.

### Naming

- React components and pages: `PascalCase`
- Hooks: `camelCase` prefixed with `use` (e.g., `useAssessmentScore`)
- API route files: `kebab-case`
- Database tables and columns: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`

### File Structure

- Group files by **feature/domain**, not by file type (e.g., `features/assessment/`, not `components/`, `hooks/`, `utils/` scattered at root).
- Co-locate tests next to the files they test (e.g., `assessment.service.test.ts` beside `assessment.service.ts`).

### React / Next.js

- Prefer **Server Components** for pages and layouts where data fetching is needed.
- Use **Client Components** only where interactivity (hooks, event handlers, browser APIs) is required.
- Avoid prop drilling beyond two levels — use context or state management instead.
- All interactive UI must be keyboard-accessible and WCAG 2.1 Level AA compliant.

### API Design

- Follow RESTful conventions: `GET /api/assessments`, `POST /api/assessments`, `PATCH /api/assessments/:id`.
- Return consistent JSON error shapes: `{ error: { code: string, message: string } }`.
- Authenticate all non-public endpoints. Never trust client-provided user IDs — derive identity from the auth token.
- Rate-limit all public-facing endpoints.

### Database (Prisma)

- All schema changes go through Prisma migrations. Never alter the database directly.
- Use transactions for operations that must be atomic.
- Avoid N+1 queries — use `include` or `select` appropriately.
- Add database indexes for any column used in `WHERE`, `ORDER BY`, or `JOIN` clauses at scale.

### Security

- Sanitise and validate all user inputs before use.
- Never log PII, credentials, or tokens.
- Use parameterised queries / Prisma's query builder — never concatenate raw SQL.
- Store secrets in environment variables, never in source code.
- Follow the principle of least privilege for database roles and external service tokens.

---

## Testing

- Write tests for all new business logic, API routes, and utilities.
- Unit tests cover pure functions and service layer logic.
- Integration tests cover API endpoints and database interactions.
- E2E tests cover the critical user journeys: assessment flow, onboarding, subscription upgrade, consultant booking.
- Target ≥ 80% code coverage for new code.

Run tests:

```bash
npm test              # unit + integration
npm run test:e2e      # end-to-end
npm run test:coverage # coverage report
```

---

## Domain Glossary

When generating code or naming things, use these domain terms consistently:

| Term | Meaning |
|------|---------|
| `Assessment` | The AI Readiness questionnaire a user completes |
| `ReadinessScore` | The 0–100 score derived from an assessment |
| `Roadmap` | The personalised AI adoption plan generated for a user |
| `UseCase` | A catalogued AI application (e.g., "AI-powered customer service chatbot") |
| `Tier` | The user's subscription level: `SELF_SERVICE` (1), `GUIDED` (2), `PARTNERSHIP` (3) |
| `Initiative` | A specific AI project a user has committed to on their roadmap |
| `Vendor` | An AI tool or platform in the vendor comparison database |
| `Consultant` | A human advisor who delivers Tier 2 & 3 consulting sessions |
| `Session` | A scheduled 1-on-1 consultation between a consultant and a user |

---

## Important Business Rules

- A user's available features are determined by their **Tier**. Always check tier when gating features.
- Assessment progress must be **auto-saved** every 30 seconds.
- Readiness scores must be **recalculated** whenever an assessment is updated — not cached from the previous run.
- Roadmap items have a priority: `QUICK_WIN`, `STRATEGIC`, or `LONG_TERM` — surface `QUICK_WIN` items first in the UI.
- Tier 2 & 3 users can have **team accounts** with multiple members. Row-level access control must respect the `organizationId` on all relevant records.

---

## What to Avoid

- Do not add unnecessary dependencies — check if the functionality exists in the current stack first.
- Do not hard-code configuration values (URLs, API keys, feature flags) — use environment variables.
- Do not bypass the authentication middleware on any non-public route.
- Do not write migrations that drop columns or tables without a data-migration strategy.
- Do not commit `.env` files or any secrets.
