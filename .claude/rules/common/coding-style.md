# Coding Style

Write clean, modern, readable, maintainable code. Prefer simple, well-structured solutions to the actual problem; add architectural complexity only when the problem warrants it. Quality over cleverness, premature optimization, or fewer lines.

## Readability
- Descriptive names; single-responsibility functions.
- Straightforward control flow; avoid deep nesting, complex expressions, needless indirection.
- Comments explain intent or non-obvious behavior, never restate code.

## Simplicity
- Follow language idioms and established conventions.
- No overengineering, speculative abstractions, or unnecessary dependencies.
- Composition over inheritance; apply SOLID where practical, not dogmatically.
- Handle errors and edge cases explicitly and consistently.
- Tolerate small duplication over premature generalization.

## Modularity & Architecture
- Cohesive modules with clear responsibilities, small intentional public interfaces, hidden internals; low coupling.
- No monoliths accumulating unrelated responsibilities; no modules that merely split files.
- Separate domain logic, orchestration, and infrastructure when useful; use dependency inversion where it decouples business logic.
- Design interfaces around contracts, not implementations.
- Prefer vertical/feature-oriented slices when functionality belongs together.
- Avoid hidden dependencies and shared mutable state; keep components testable and replaceable.
- Choose patterns by actual complexity; consider the broader architecture before significant changes.

## Consistency
- Follow existing project conventions, architecture, naming, formatting, error handling, and API design unless there's a clear reason to improve.
- One approach per problem category; reuse existing utilities.

## Priority Order
1. Correctness and reliability
2. Readability and simplicity
3. Separation of concerns and modularity
4. Architectural consistency and maintainability
5. Extensibility
6. Performance, only when justified by real requirements
