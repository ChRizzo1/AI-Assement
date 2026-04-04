# CLAUDE.md — AI Project Guidelines

This file governs how Claude Code behaves in this repository. All contributors (human and AI) should follow these standards.

---

## 1. Clarification & Decision-Making

- **Ask before proceeding** on significant architectural decisions: technology choices, data models, API contracts, authentication strategies, agent orchestration patterns, or anything that would be difficult to reverse.
- For minor ambiguities (variable naming, file placement, minor refactors), make a reasonable choice and note it inline with a `// NOTE:` comment.
- Never silently assume intent on security-sensitive logic. Always confirm.

---

## 2. Code Size & Reviewability

- **Hard limit: 500 lines per file.** If a file approaches this limit, split it into focused modules before continuing.
- Each module should have a single, clear responsibility (single-responsibility principle).
- Prefer many small files over few large ones. Human reviewability is a first-class constraint.
- When splitting is required, create an `index` or barrel file that re-exports public interfaces cleanly.

---

## 3. Security Practices

### General
- Follow the principle of least privilege in all code: functions, roles, API keys, and agent permissions.
- Never hardcode secrets, tokens, or credentials. Use environment variables and reference `.env.example` for expected keys.
- Validate and sanitize all external inputs — including LLM outputs used as inputs to other systems (prompt injection defense).
- Prefer allowlists over denylists for input validation.

### Dependency Security
- Before adding any new `npm` package, check for known vulnerabilities:
  ```bash
  npm audit
  npx better-npm-audit audit
  ```
- Check the package's publish date, weekly downloads, and maintainer activity on [npmjs.com](https://www.npmjs.com) before adopting it.
- Pin dependency versions in `package.json` (`"lodash": "4.17.21"`, not `"^4.17.21"`) for reproducible builds.
- For Python dependencies, run `pip-audit` or `safety check` before adding new packages.
- Flag any package with fewer than 10k weekly downloads or last published > 1 year ago — ask before adding.

### AI / Agent-Specific
- All tool calls made by agents must be logged with inputs and outputs.
- No agent should have write access to production systems without an explicit human-in-the-loop confirmation step.
- Treat all data returned from external APIs or LLM completions as untrusted until validated.

---

## 4. Testing

Claude selects the appropriate testing framework based on the language in use. Default choices:

| Stack | Unit Tests | End-to-End Tests |
|---|---|---|
| TypeScript / Node.js | Vitest | Playwright |
| JavaScript / Node.js | Jest | Playwright |
| Python | pytest | Playwright or httpx (for APIs) |
| Other | Language-idiomatic | Confirm with user |

### Rules
- **Write tests before or alongside code** — never as an afterthought.
- Every new function or module must have at least one unit test covering the happy path and one covering a failure/edge case.
- Every user-facing flow must have at least one E2E test.
- Tests must be **run and passing** before any task is considered complete. Show the output.
- Test files live adjacent to source files (`*.test.ts`, `*.spec.py`) or in a `/tests` directory — be consistent within a given language layer.
- Mock external services and LLM calls in unit tests. E2E tests may use real services against a staging environment.

---

## 5. Documentation

- Every file must begin with a brief comment block describing its purpose (2–5 lines max).
- Every exported function or class must have a docstring / JSDoc comment that covers:
  - What it does
  - Parameters and return type
  - Any side effects or important constraints
- Complex logic blocks must have inline comments explaining *why*, not just *what*.
- Keep a `README.md` at the root and in each major subdirectory. Update it when structure changes.
- Document all environment variables in `.env.example` with a short description of each.

### Example (TypeScript)
```typescript
/**
 * Validates and sanitizes an LLM-generated tool call before execution.
 * Throws if the call references a disallowed tool or malformed arguments.
 *
 * @param toolCall - Raw tool call object from the LLM response
 * @param allowedTools - Set of permitted tool names for this agent context
 * @returns Sanitized ToolCall ready for execution
 */
export function validateToolCall(toolCall: RawToolCall, allowedTools: Set<string>): ToolCall { ... }
```

---

## 6. General Code Quality

- Prefer explicit over implicit. Avoid magic numbers and magic strings — use named constants.
- Handle errors explicitly. Do not swallow exceptions silently.
- Log errors with enough context to debug (include operation name, relevant IDs, sanitized inputs).
- Avoid nested callbacks; prefer async/await.
- Keep functions pure where possible — side effects should be isolated and clearly named.

---

## 7. Git & Change Hygiene

- Each commit should represent one logical change.
- Commit messages follow the format: `type(scope): short description` (e.g., `feat(agent): add prompt injection guard`).
- Do not commit commented-out code. Remove it or delete the block and open a tracked issue instead.

---

## 8. When in Doubt

If a decision could affect security, agent behavior, data integrity, or system architecture — **stop and ask**. A short clarifying question costs seconds. A wrong assumption in this domain can be costly to reverse.
