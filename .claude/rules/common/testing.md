# Testing Guidelines

## Core Principles

Write tests that give confidence in correctness, reliability, expected behavior.

Tests should be readable, deterministic, maintainable, focused on meaningful requirements.

Favor testing observable behavior and public contracts over implementation details.

Testing is part of development, not optional post-implementation step.

## 1. Testing Strategy

Choose testing level based on behavior verified.

- **Unit tests:** Verify individual functions, classes, components in isolation.
- **Integration tests:** Verify interactions between modules, infrastructure, external dependencies.
- **End-to-end tests:** Verify full app workflows through externally observable interfaces.
- **Contract tests:** Verify component/service interactions follow agreed contracts.

Prefer testing pyramid: strong base of fast, focused unit tests, plus integration tests, fewer end-to-end tests.

Do not add testing layers without meaningful reason.

## 2. Test Behavior, Not Implementation

- Focus on observable behavior and expected outcomes.
- Verify public interfaces and contracts, not private implementation details.
- Avoid tests needlessly depending on internal data structures, private methods, execution order.
- Avoid duplicating implementation logic in tests.
- Do not modify production code just to satisfy brittle tests.
- Ensure tests stay valid when internals change but external behavior doesn't.

Tests describe what system must do, not how it does it.

## 3. Test Organization and Readability

- Organize tests consistent with project structure and covered functionality.
- Use descriptive test names stating scenario and expected outcome.
- Keep each test focused on one behavior or logical scenario.
- Prefer clear Arrange-Act-Assert (AAA) structure where fit.
- Keep setup/teardown explicit and predictable.
- Extract shared test utilities when they meaningfully cut duplication.
- Avoid overly generic helpers that obscure tested behavior.
- Keep test code readable and maintainable, same standards as production code.

Developer should grasp test purpose without tracing excessive setup or helper abstractions.

## 4. Test Isolation and Independence

- Ensure tests run independently and in any order unless ordering is explicit part of tested behavior.
- Avoid hidden dependencies between tests.
- Avoid shared mutable state causing interference.
- Isolate external side effects when appropriate.
- Use temporary resources and deterministic fixtures.
- Ensure tests clean up resources they create.
- Avoid depending on local machine config, execution timing, or external service availability unless explicitly testing those.

Tests should give consistent results across supported environments.

## 5. Mocking and Test Doubles

- Use mocks, stubs, fakes, other test doubles when they give meaningful isolation.
- Prefer real implementations for simple, deterministic components when practical.
- Mock external boundaries, not internal implementation details.
- Avoid excessive mocking that makes tests verify interactions instead of behavior.
- Do not mock component or functionality under test.
- Keep test doubles faithful to real dependency contracts.
- Use integration tests to verify important interactions unit tests isolate.

Mocking should improve isolation without reducing confidence.

## 6. Coverage and Edge Cases

Test meaningful scenarios, including:

- Normal successful execution.
- Boundary conditions and edge cases.
- Invalid inputs and validation failures.
- Missing or unavailable resources.
- Exceptional conditions and error propagation.
- Empty collections and optional values.
- State transitions and lifecycle behavior.
- Concurrent operations when concurrency relevant.
- Resource cleanup and failure recovery.

Do not optimize for coverage percentage alone.

Coverage metrics help find untested areas; high coverage not guarantee meaningful tests.

Prioritize testing critical business rules, complex logic, public contracts, failure-prone paths.

## 7. Determinism and Reliability

- Avoid arbitrary sleeps and timing-dependent assertions.
- Control time, randomness, other nondeterministic inputs when needed.
- Use synchronization primitives, not timing assumptions, in concurrent tests.
- Avoid dependence on test execution order.
- Make async test completion and failure propagation explicit.
- Avoid flaky tests; investigate root causes instead of retrying repeatedly.
- Keep tests fast enough for frequent runs.

Test suite should be reliable feedback, not source of uncertainty.

## 8. Testing Architectural Boundaries

- Test module public interfaces independently.
- Verify important interactions between architectural layers.
- Ensure infrastructure adapters satisfy expected contracts.
- Test domain logic without needless infrastructure dependencies.
- Verify implementation details stay encapsulated behind module boundaries.
- Test integration points where data, errors, or responsibilities cross boundaries.

Prefer testing modules through intended interfaces, not bypassing architectural boundaries.

## 9. Test-Driven Development

Use Test-Driven Development (TDD) when practically beneficial, esp. for complex business rules, algorithms, behavior with well-defined expected outcomes.

When following TDD:

1. Write test describing expected behavior.
2. Run test; verify it fails for intended reason.
3. Implement simplest solution satisfying test.
4. Refactor while keeping tests passing.
5. Repeat for more scenarios.

Do not enforce TDD mechanically for every change. Choose workflow giving effective feedback without needless overhead.

## 10. Testing During Development

- Run relevant tests after implementing or modifying functionality.
- Run regression tests when changes affect existing behavior.
- Run broader suite before calling significant changes complete.
- Investigate and fix test failures introduced by changes.
- Do not modify or remove existing tests just to make failing suite pass.
- If test outdated or incorrect, understand underlying behavior before updating.
- Do not claim tests pass unless actually executed successfully.
- Clearly communicate tests that couldn't run and why.

Tests part of definition of done for meaningful functionality changes.

## 11. Test Maintenance

- Treat tests as production-quality code.
- Remove obsolete tests when verified behavior intentionally removed.
- Update tests when public contracts or expected behavior change.
- Avoid redundant tests adding no confidence.
- Keep fixtures, test data, utilities easy to understand.
- Refactor tests when structure becomes hard to maintain.
- Avoid coupling tests to unrelated implementation details.

Test suite should evolve with app without becoming maintenance burden.

## General Rule

Write tests giving meaningful confidence in system behavior and correctness.

Prefer deterministic, isolated, behavior-focused tests verifying important contracts and failure conditions.

Good test suite makes changes safer, regressions easier to detect, system easier to evolve.