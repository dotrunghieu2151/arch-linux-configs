---
paths:
  - "**/*.{ts,tsx,mts,cts}"
---
# TypeScript Modules and APIs

Design TS modules and public interfaces around clear responsibilities, explicit contracts, controlled deps.

## Module Design

- Keep modules focused on cohesive responsibilities.
- Separate domain logic from infra, presentation, external integrations.
- Prefer explicit deps over hidden globals.
- Avoid circular deps.
- Keep module boundaries free of unneeded impl details.
- Expose only what consumers need.
- Prefer named exports for ordinary module APIs unless project conventions say otherwise.
- Avoid oversized modules mixing unrelated functionality.
- Avoid excess one-function modules without real architectural reason.

## Public Interfaces

- Design public interfaces around stable, meaningful contracts.
- Use explicit types for exported functions, classes, key data structures where they improve API clarity.
- Avoid exposing internal impl types needlessly.
- Prefer composition over inheritance when it yields simpler contracts.
- Keep params and return values predictable.
- Make side effects and async behavior clear.
- Document key preconditions, postconditions, lifecycle requirements.
- Avoid exposing mutable internal collections/objects without clear reason.

## Dependency Management

- Prefer DI for deps needing substitution, isolation, or lifecycle management.
- Avoid service locators and implicit global registries unless architecturally justified.
- Keep domain logic independent of framework- and infra-specific impls where practical.
- Depend on abstractions when they give real decoupling.
- Avoid creating interfaces for every impl by default.
- Keep deps flowing in consistent direction.
- Avoid importing impl details from unrelated modules.

## Data Contracts

- Distinguish domain, application, persistence models, and transport DTOs when responsibilities differ.
- Avoid exposing internal persistence representations directly as external API contracts.
- Define explicit serialization/deserialization boundaries.
- Validate external input at runtime before trusting it as app data.
- Avoid coupling public API contracts to internal impl details.
- Make compatibility and versioning requirements explicit when independent systems consume contracts.
- Handle optional, nullable, missing fields consistently.

## API Design

- Design APIs around clear operations, predictable behavior.
- Use explicit request/response types.
- Keep validation close to boundary where untrusted data enters.
- Separate transport concerns from app and domain behavior.
- Return consistent error representations.
- Avoid leaking internal exceptions, infra details, sensitive info via public responses.
- Make pagination, filtering, sorting, partial-update semantics explicit where applicable.
- Consider idempotency, retries, concurrency when designing state-modifying operations.

## Module Exports

- Keep barrel files focused and intentional.
- Avoid broad barrel exports exposing internal impl details.
- Watch for barrel files introducing circular deps.
- Avoid importing from module's own public barrel inside its internal impl when this risks circular deps.
- Keep package entry points explicit and stable.
- Ensure public exports don't unintentionally expand supported API surface.

## Package Boundaries

- Define clear ownership per package in monorepo.
- Avoid unneeded cross-package deps.
- Keep shared packages focused on truly reusable functionality.
- Avoid putting app-specific business logic into generic shared packages.
- Declare package deps explicitly.
- Don't rely on undeclared deps or workspace hoisting behavior.
- Keep package public exports and internal source paths clearly separated.