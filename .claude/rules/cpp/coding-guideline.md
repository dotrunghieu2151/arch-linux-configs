---
paths:
  - "**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,ipp,tpp}"
---
# C++ Coding Guidelines

Write memory-safe, performant, readable, maintainable C++. Prefer modern idioms; respect project's configured standard, compiler support, conventions.

## General Principles

- Prioritize correctness and memory safety before optimization.
- Prefer simple, explicit, readable implementations.
- Use modern C++ features when they improve safety, clarity, or maintainability.
- Prefer standard library over custom implementations unless justified.
- Make ownership, lifetime, resource management explicit.
- Avoid undefined behavior and unnecessary low-level ops.
- Never sacrifice readability for speculative performance gains.
- Follow project's configured C++ standard and conventions.

## Readability and Maintainability

- Use descriptive names for types, functions, variables, template params.
- Keep functions focused, responsibilities well-defined.
- Prefer straightforward control flow over deep nesting.
- Use `const` wherever mutation not required.
- Prefer `enum class` over unscoped enums.
- Use `[[nodiscard]]` when callers must not accidentally ignore result.
- Use `constexpr` and `consteval` when compile-time evaluation gives meaningful benefit.
- Use `noexcept` only when operation genuinely guaranteed not to throw.
- Avoid overly complex expressions, implicit conversions, surprising operator overloads.
- Keep interfaces small, explicit.
- Avoid unnecessary macros; prefer templates and `constexpr`.
- Keep implementation details private; expose only necessary public interface.

## Type Safety

- Prefer strong types over loose primitives when they represent distinct domain concepts.
- Use `std::optional` for optional value.
- Use `std::variant` for values with multiple distinct alternatives.
- Use `std::expected` (when project standard and conventions allow) for operations that can fail with typed error.
- Avoid sentinel values when explicit type expresses absence or failure more clearly.
- Make implicit conversions and ownership transfers intentional.
- Use assertions for internal invariants, not as replacement for validating external input.

## Standard Library

- Prefer standard algorithms and ranges when they express intent clearly.
- Prefer standard containers and utilities unless requirements or profiling justify alternatives.
- Know complexity, invalidation rules, exception guarantees of operations used.
- Avoid adding dependencies that duplicate existing standard library functionality.

## Verification

- Compile with project's configured warnings; resolve relevant ones.
- Use static analysis and sanitizers where supported.
- Test boundary conditions, invalid inputs, failure paths.
- Benchmark performance-sensitive changes against meaningful baseline.
- Never claim code safe, correct, or performant without appropriate verification.