---
paths:
  - "**/*.{ts,tsx,mts,cts}"
---
# TypeScript Type Safety

Use TypeScript type system to make invalid states hard to represent, state contracts clearly, catch errors early.

## Strict Type Checking

- Enable and respect strictness settings.
- Prefer `strict: true`; keep strict compiler options unless documented compatibility requirement prevents it.
- Never weaken compiler settings to dodge single type errors.
- Fix type errors, don't suppress.
- Avoid `any`; prefer `unknown` when type not yet known.
- Narrow `unknown` via validation, type guards, or explicit control flow before use.
- Avoid broad type assertions that bypass compiler checks.
- Don't use non-null assertions (`!`) unless invariant guaranteed and clearly justified.
- Avoid `@ts-ignore`; use `@ts-expect-error` only for intentional, documented expected-error cases.

## Modeling Types

- Prefer precise types expressing real domain constraints.
- Use discriminated unions for mutually exclusive states.
- Use literal types when value belongs to finite, meaningful set.
- Prefer `type` aliases for unions, intersections, type transformations.
- Use `interface` for object contracts needing extension or declaration merging.
- Avoid duplicating equivalent types across modules.
- Prefer composition over deep inheritance.
- Avoid broad types like `object`, `{}`, `Function` when precise type available.
- Use branded/nominal-style types when distinct domain concepts share same primitive and accidental swap would hurt.

## Nullability and Optional Values

- Model absence explicitly with `null` or `undefined` per project convention.
- Distinguish optional properties from explicitly nullable ones.
- Check nullable values before access.
- Prefer nullish coalescing (`??`) for absent values over truthiness checks that reject valid `0`, `false`, or empty string.
- Never use non-null assertions in place of proper control flow.
- Don't add arbitrary fallback values that hide missing/invalid data.

## Type Narrowing and Validation

- Prefer control-flow narrowing and discriminated unions over repeated assertions.
- Use type guards for reusable narrowing.
- Validate external data before treating as trusted domain type.
- Treat HTTP responses, DB records, env vars, file contents, user input, third-party data as untrusted until validated.
- Remember TypeScript types erased at runtime.
- Use runtime validation libraries or explicit validation functions at trust boundaries.
- Keep validation schemas and static types in sync.
- Never claim data valid just because cast to TypeScript type.

## Generics

- Use generics when they preserve input/output type relationships or give real reuse.
- Constrain generic parameters to actual requirements.
- Prefer descriptive generic names when short conventional names unclear.
- Avoid needless generic parameters and excess conditional types.
- Avoid complex type-level programming when plain runtime code clearer.
- Preserve inference; don't force callers to pass generic args needlessly.

## Exhaustiveness

- Handle every discriminated union member.
- Use exhaustive checks for finite states.
- Prefer compiler-assisted exhaustiveness over assumptions about known cases.
- Ensure new union member surfaces incomplete handling at compile time.

## Type Assertions and Suppressions

- Treat `as` assertions as escape hatch, not normal conversion.
- Prefer validation, narrowing, correct modeling over assertions.
- Avoid double assertions like `value as unknown as TargetType`.
- Keep unavoidable assertions near boundary where assumptions established.
- Document non-obvious type-system workarounds and their invariants.