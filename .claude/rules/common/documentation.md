# Documentation

Write docs that make system easier to understand, use, maintain, evolve. Docs explain intent, contracts, constraints, decisions—not merely repeat what code already expresses.

## General Principles

- Keep docs accurate, concise, relevant.
- Prefer clear, direct language and concrete examples.
- Document non-obvious behavior, important constraints, assumptions, design decisions.
- Avoid documenting implementation details self-evident from readable code.
- Follow project's established doc conventions and tooling.
- Update docs whenever code change makes existing docs inaccurate or incomplete.
- Do not add docs just to have more docs.

## Code-Level Documentation

- Use comments and docstrings to explain why, not just what code does.
- Prefer improving names, structure, implementation over adding comments to compensate for unclear code.
- Document non-obvious algorithms, invariants, edge cases, workarounds, important trade-offs.
- Explain surprising behavior or constraints future maintainers might mistake for defects.
- Remove outdated, redundant, misleading comments.
- Use language-native doc mechanisms when they give useful tooling or API integration.

## Public Interfaces and APIs

Document public interfaces when correct use not immediately obvious.

Where relevant, describe:

- Purpose and expected behavior.
- Parameters, accepted values, constraints.
- Return values and possible outcomes.
- Errors, exceptions, failure conditions.
- Preconditions and postconditions.
- Side effects and external dependencies.
- Resource ownership, lifetime, cleanup responsibilities.
- Thread-safety and concurrency guarantees.
- Important performance characteristics or usage limits.

Make contracts explicit. Do not rely on callers to infer important behavior from implementation details.

Keep internal implementation details private unless needed to understand or use interface.

## Module and Project Documentation

Provide docs at level where they help users and maintainers understand system.

- **Project documentation:** Explain project purpose, prerequisites, setup, configuration, common workflows, how to build, run, test.
- **Module documentation:** Explain module responsibility, public interface, dependencies, important constraints, how it fits larger system.
- **Feature documentation:** Explain meaningful behavior, configuration, usage, relevant limitations.
- **Operational documentation:** Document deployment, maintenance, troubleshooting, recovery, other operational procedures when applicable.

Keep docs close to code or component they describe when practical.

## Architecture Decision Records

Record significant architectural decisions when they have lasting consequences or aren't self-explanatory.

Architecture Decision Record (ADR) should generally capture:

- **Context:** Problem, constraints, relevant requirements.
- **Options:** Meaningful alternatives considered.
- **Decision:** Selected approach and rationale.
- **Consequences:** Benefits, trade-offs, limitations, implications.

Keep records focused and factual. Preserve historical decisions, don't silently rewrite them when architecture changes; document superseding decisions and link related records where appropriate.

Do not create ADR for every minor implementation choice.

## Examples and Usage Instructions

- Provide examples when they make interface or workflow easier to understand.
- Ensure examples reflect current implementation and conventions.
- Prefer minimal, complete examples showing correct usage.
- Include relevant prerequisites, configuration, expected results.
- Avoid examples relying on unexplained project state or omitted setup.
- Verify executable examples when practical.

## Keeping Documentation Maintainable

- Treat docs as part of implementation, not separate afterthought.
- Review affected docs as part of code changes.
- Remove obsolete instructions, duplicated explanations, references to removed functionality.
- Avoid excessive cross-referencing; link to canonical source when info shared.
- Keep terminology consistent across code, APIs, docs.
- Never claim feature, behavior, command, or workflow exists unless implementation supports it.