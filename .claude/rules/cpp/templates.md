---
paths:
  - "**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,ipp,tpp}"
---
# C++ Templates and Generic Programming

Use templates + generic programming for reusable, type-safe abstractions. Prefer clear compile-time constraints, predictable interfaces over needless template complexity.

## General Principles

- Use templates when they give real compile-time flexibility, reuse, or perf gain.
- Prefer ordinary functions/types when generics unneeded.
- Keep template interfaces small, explicit.
- Avoid excess abstraction, deep nested template machinery, needless metaprogramming.
- Prefer readable, maintainable compile-time code over clever tricks.
- Respect project's configured C++ standard + compiler support.

## Concepts and Constraints

- Use C++ concepts to express template requirements when project standard supports.
- Prefer named concepts for reusable or domain-specific constraints.
- Constrain templates close to interface as practical.
- Make invalid template args fail with understandable diagnostics.
- Avoid overly restrictive constraints that block valid use cases.
- Prefer std library concepts when they express requirement accurately.

## Type Deduction and Forwarding

- Know difference between lvalue refs, rvalue refs, forwarding refs.
- Use forwarding refs + `std::forward` when interface truly must preserve arg value category.
- Don't apply perfect forwarding blindly.
- Prefer explicit types when deduction hurts readability.
- Use `auto` when it improves clarity without hiding key type info.
- Understand reference collapsing + template arg deduction when designing generic interfaces.

## Compile-Time Programming

- Prefer `constexpr` functions/variables for simple compile-time computation.
- Use `consteval` when evaluation must happen at compile time and project supports it.
- Prefer `if constexpr` for compile-time conditional behavior.
- Use type traits + std utilities before custom metaprogramming.
- Avoid complex template metaprogramming when simpler runtime or compile-time solution exists.
- Keep compile-time computation bounded; avoid needless build time growth.

## Generic Interfaces

- Design templates around explicit requirements + stable contracts.
- Prefer composition and policies when they make variation points clear.
- Avoid exposing impl details through public template interfaces needlessly.
- Ensure generic code handles relevant value categories, constness, lifetime requirements correctly.
- Avoid accidental copies + unintended reference retention.
- Document key constraints type system can't express.

## Verification

- Test supported type categories + relevant value categories.
- Test const and non-const usage where applicable.
- Verify behavior with move-only and non-copyable types when meant to be supported.
- Ensure diagnostics understandable for invalid template args.
- Consider compile-time cost when adding complex generic abstractions.