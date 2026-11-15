---
paths:
  - "**/*.{ts,tsx,mts,cts}"
---
# TypeScript Coding Guidelines

Write TypeScript type-safe, readable, maintainable, efficient. Prefer explicit contracts, modern features, straightforward impl.

## General Principles

- Prioritize correctness, type safety, readability.
- Prefer simple explicit impl over clever or needlessly abstract code.
- Use project's configured TypeScript/JavaScript module standards.
- Prefer built-in language + stdlib features over custom utils when fit.
- Follow established project conventions + architectural boundaries.
- Avoid needless deps, abstractions, indirection.
- Do not use type system as substitute for runtime validation.
- Avoid relying on undocumented runtime behavior or implicit assumptions.

## Readability

- Use descriptive names for variables, functions, types, interfaces, modules.
- Keep functions focused, responsibilities well-defined.
- Prefer early returns, straightforward control flow.
- Avoid deep nested conditionals + excessive callback nesting.
- Use explicit return types for exported functions + important public interfaces when clarity improves.
- Use `const` by default; use `let` only when reassignment required.
- Avoid `var`.
- Prefer template literals for string interpolation.
- Use optional chaining + nullish coalescing when intent clear.
- Avoid needless type annotations when TypeScript infers type without losing important info.
- Avoid overly compressed expressions + needless one-liners.

## Functions and Data

- Prefer small composable functions, clear inputs/outputs.
- Keep functions deterministic, side effects explicit where practical.
- Avoid mutating function args or shared state unexpectedly.
- Prefer returning new values when mutation not required.
- Use immutable data patterns where they improve predictability.
- Avoid hidden deps via global state.
- Keep object construction + transformation explicit.
- Avoid functions with excessive params; group related options into well-defined object when fit.

## Language Features

- Prefer `async`/`await` over deep nested promise chains.
- Use discriminated unions to model distinct states + outcomes.
- Use `readonly` where mutation not part of contract.
- Use `satisfies` to validate expression against type without needlessly widening inferred type.
- Prefer named exports for ordinary module APIs unless project has established default-export convention.
- Use `import type` and `export type` for type-only deps when fit.
- Prefer modern syntax supported by project's target runtime + compiler config.

## Code Organization

- Keep related functionality together.
- Separate domain logic from infra + presentation concerns.
- Avoid oversized modules + files with unrelated responsibilities.
- Avoid circular deps.
- Keep public exports intentional, minimal.
- Do not introduce generic utils for one-off ops unless reuse/abstraction gives meaningful benefit.

## Maintainability

- Avoid duplicated business logic.
- Prefer explicit behavior over hidden side effects.
- Remove unused variables, imports, unreachable code, obsolete abstractions.
- Keep impl consistent with project's established patterns.
- Do not introduce abstractions solely to anticipate hypothetical future requirements.