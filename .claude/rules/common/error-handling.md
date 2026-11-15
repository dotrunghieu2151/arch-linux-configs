# Error Handling Guidelines

## Core Principles

Make error handling explicit, predictable, consistent, easy to reason about.

Errors must say what went wrong, keep enough context for diagnosis, let app respond right.

Treat error handling as part of system design and public contracts, not afterthought.

## 1. Explicit Error Handling

- Handle errors deliberately; don't rely on implicit/unpredictable behavior.
- Never silently swallow errors.
- Avoid empty catch blocks or equivalents that discard failures without justification.
- Don't use exceptions, error values, or status codes as normal control flow when clearer alternative exists.
- Avoid overly broad exception handling that hides real failure source.
- Don't assume operations succeed unless contract guarantees it.
- Handle expected failure conditions explicitly.

Give every error-handling path clear purpose.

## 2. Error Propagation

- Propagate errors to right responsibility boundary when current component can't meaningfully handle them.
- Preserve original error info when wrapping/translating.
- Avoid catch-and-rethrow that adds no context or changes no handling responsibility.
- Don't convert errors into success-like return values or silently ignore failed operations.
- Ensure async operations propagate failures correctly.
- Keep propagation consistent with module's public contract.

Prefer handling errors at layer with enough context to decide meaningfully.

## 3. Error Classification

Distinguish failure categories:

- **Validation errors:** Input or state fails required constraints.
- **Business rule violations:** Operation conflicts with domain rules or app policies.
- **Not-found errors:** Requested resource/entity doesn't exist.
- **Authorization errors:** Operation not permitted.
- **Infrastructure errors:** External deps, databases, networks, or other infra fail.
- **Unexpected errors:** Failures not anticipated by normal app behavior.

Use meaningful error types, codes, or categories where fitting.

Avoid exposing low-level implementation details to consumers that should only see domain/app-level failures.

## 4. Error Context and Information

- Give meaningful error messages that explain failure.
- Include relevant context identifying failing operation.
- Preserve underlying cause when translating/wrapping.
- Avoid generic messages that make diagnosis needlessly hard.
- Don't expose passwords, auth tokens, personal data, secrets, or sensitive internal info in errors.
- Keep user-facing messages fit for audience.
- Keep diagnostic info separate from end-user info.

Make messages describe failure without needlessly exposing implementation details.

## 5. Exception Safety and Resource Management

- Ensure resources release correctly on failure.
- Prefer language-native resource management (RAII, scope guards, structured resource management) where available.
- Keep object and app state valid on failure.
- Avoid partially applied operations unless contract explicitly supports partial completion.
- Use transactions or equivalent when multiple operations must succeed/fail together.
- Consider rollback and compensation for operations that can't join atomic transactions.
- Ensure cleanup logic doesn't hide or overwrite original failure.

Make resource ownership and cleanup responsibilities explicit.

## 6. Error Handling at Architectural Boundaries

Handle errors per each architectural layer's responsibilities.

- **Domain layer:** Represent business rule violations and domain failures without depending on infra-specific error types.
- **Application layer:** Coordinate operations, propagate failures, manage use-case-level recovery or compensation.
- **Infrastructure layer:** Translate external failures into meaningful internal errors, preserving causes.
- **Presentation/API layer:** Convert app errors into fitting user-facing messages, response codes, or protocol-specific representations.

Avoid leaking infra-specific exceptions or implementation details across boundaries.

Don't add needless error translation layers when existing error contract already fits.

## 7. Recovery and Resilience

- Distinguish recoverable vs non-recoverable failures.
- Retry only when retry is appropriate and safe.
- Use bounded retries with backoff for transient failures.
- Avoid retrying permanent failures or invalid operations.
- Consider idempotency when retrying possibly partially completed operations.
- Use timeouts for operations with external deps.
- Apply graceful degradation when app can give valid reduced functionality.
- Fail fast when continuing would produce invalid/inconsistent state.

Base recovery strategies deliberately on operation semantics.

## 8. Logging and Observability

- Log errors at right responsibility boundary.
- Include useful diagnostic context (operation IDs, correlation IDs, relevant resource IDs) when fitting.
- Preserve stack traces and underlying causes for unexpected failures.
- Avoid logging same error repeatedly at every layer.
- Avoid logging sensitive info or whole payloads needlessly.
- Use severity levels matching operational impact.
- Ensure unexpected failures are observable and diagnosable.

Use logging to complement error propagation, not replace it.

## 9. Consistency

- Establish consistent error representations and handling conventions in project.
- Reuse existing error types, codes, utilities when fitting.
- Keep error contracts predictable across module boundaries.
- Avoid multiple competing error-handling mechanisms without clear reason.
- Document non-obvious error conditions and recovery behavior in public interfaces.
- Ensure new functionality follows established conventions.

## 10. Testing Error Conditions

- Test expected failure conditions, not just success paths.
- Verify errors propagate correctly across module boundaries.
- Test error translation and preservation of underlying causes.
- Verify cleanup and resource safety on failure.
- Test retry, timeout, recovery behavior where applicable.
- Ensure failures don't leave app in invalid/inconsistent state.
- Verify sensitive info not exposed via error messages or logs.

Treat error-handling behavior as part of component's observable contract.

## General Rule

Never hide failures, lose meaningful error context, or leave resources and app state inconsistent.

Handle errors at right responsibility boundary, preserve their meaning, make failure behavior predictable.

Prefer explicit, reliable error handling over overly defensive code, excessive exception wrapping, or needless recovery mechanisms.