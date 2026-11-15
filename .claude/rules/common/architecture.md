# Architecture Guidelines

## Core Principles

Design software around clear responsibilities, defined boundaries, explicit dependencies.

Architecture should make system easier to understand, maintain, test, evolve. Prefer simplest architecture that solves problem while leaving room for reasonable future change.

Don't add architectural patterns, abstractions, or layers without meaningful justification.

## 1. Architectural Decision-Making

- Understand existing architecture and requirements before structural changes.
- Extend existing architectural conventions over introducing competing approaches.
- Choose patterns by problem's actual complexity, constraints, expected evolution.
- Optimize for maintainability and clear boundaries, not theoretical flexibility.
- Avoid premature abstraction, speculative generalization, unnecessary infrastructure.
- Consider impact of architectural changes on existing modules, dependencies, testing, deployment.
- Make significant architectural decisions explicit, with trade-offs and rationale.

When evaluating architectural alternatives, consider:

- Complexity and implementation effort.
- Separation of responsibilities.
- Dependency management and coupling.
- Testability and isolation.
- Extensibility and expected change.
- Operational and performance implications.

## 2. Separation of Concerns

- Give each component, module, layer one clearly defined responsibility.
- Separate business logic from infrastructure, external services, persistence, presentation where appropriate.
- Don't mix unrelated responsibilities in same component.
- Keep orchestration separate from individual operation implementation when clearer.
- Ensure changes in one concern don't needlessly propagate into unrelated concerns.

Establish layers only when they represent meaningful responsibilities and boundaries.

## 3. Module Boundaries

- Organize system into cohesive modules representing meaningful capabilities or responsibilities.
- Give each module clear purpose and well-defined public interface.
- Keep implementation details private; expose only what consumers need.
- Minimize dependencies between modules.
- Avoid circular dependencies.
- Avoid modules acting as generic dumping grounds for unrelated functionality.
- Communicate explicitly through public interfaces, not by reaching into another module's internals.
- Keep ownership of data and business rules clear.

Module should ideally be understandable and testable without knowing internals of unrelated modules.

## 4. Cohesion and Coupling

Favor high cohesion, low coupling.

**High cohesion:**

- Group functionality that belongs together.
- Keep related business rules and operations close to domain or feature they serve.
- Don't scatter single responsibility across unrelated modules without clear reason.

**Low coupling:**

- Minimize direct dependencies between unrelated components.
- Depend on stable contracts, not implementation details.
- Avoid unnecessary shared mutable state.
- Avoid implicit dependencies and hidden communication channels.
- Introduce interfaces or abstractions when they meaningfully reduce coupling or enable independent evolution.

Don't add interfaces for every component by default. Abstraction must give meaningful architectural benefit.

## 5. Dependency Management

- Keep dependency directions intentional and consistent.
- Depend on stable abstractions over volatile implementation details.
- Don't let infrastructure concerns dictate business rules.
- Use dependency inversion when it meaningfully separates high-level policies from low-level implementation.
- Make dependencies explicit; avoid hidden service locators and unnecessary global state.
- Prevent circular dependency graphs.
- Keep module initialization and lifecycle responsibilities clear.

Where appropriate, keep high-level business policies independent of infrastructure implementations.

## 6. Choosing Architectural Patterns

Use architectural patterns as tools for concrete problems, not mandatory structures.

Consider these approaches per requirements:

- **Modular Monolith:** Prefer for cohesive app needing strong internal boundaries without distributed-services operational complexity.
- **Vertical Slice Architecture:** Prefer when organizing around independent features or use cases, especially with distinct workflows and responsibilities.
- **Layered Architecture:** Prefer when system has clear presentation, application, domain, infrastructure responsibilities.
- **Hexagonal Architecture:** Consider when business logic needs strong isolation from external systems, infrastructure, or replaceable adapters.
- **Domain-Driven Design:** Consider when business domain has significant complexity, rich business rules, distinct domain boundaries.
- **Microservices:** Consider only when independent deployment, scaling, ownership, or org boundaries justify added distributed-systems complexity.

Patterns not mutually exclusive. Combine compatible approaches when they address different architectural concerns.

Don't adopt pattern just because popular or theoretically beneficial.

## 7. Designing for Change

- Identify likely areas of change; isolate them behind appropriate boundaries.
- Keep volatile implementation details from spreading through system.
- Design public interfaces around stable responsibilities and contracts.
- Let implementations evolve without needlessly affecting consumers.
- Don't design for hypothetical requirements lacking reasonable justification.
- Prefer localized changes over modifications needing coordination of unrelated components.

Extensibility should come from good boundaries and explicit contracts, not excessive abstraction.

## 8. Architectural Consistency

- Keep architectural conventions consistent across project.
- Don't mix architectural styles without clear reason.
- Follow established module boundaries and dependency directions.
- Introduce architectural changes incrementally when possible.
- When modifying existing system, avoid unnecessary large-scale restructuring.
- If existing architectural decision becomes problematic, fix underlying cause instead of adding another abstraction to work around it.

## 9. Practical Design Guidelines

Before adding new module, layer, interface, or architectural pattern, consider:

1. Does it represent meaningful responsibility or boundary?
2. Does it reduce complexity or just relocate it?
3. Does it improve cohesion or reduce coupling?
4. Does it give concrete benefit for testing, maintenance, or evolution?
5. Is added complexity justified by current requirements?
6. Does it stay consistent with existing architecture?

If benefits unclear, prefer simpler design.

## General Rule

Build architecture around actual problem and its meaningful boundaries.

Prefer well-structured modular system over pile of unnecessary abstractions. Keep responsibilities explicit, dependencies intentional, architectural complexity proportional to domain complexity.