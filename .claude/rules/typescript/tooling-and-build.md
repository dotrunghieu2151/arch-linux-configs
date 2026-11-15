---
paths:
  - "**/tsconfig*.json"
  - "**/package.json"
  - "**/*lock*"
  - "**/pnpm-workspace.yaml"
  - "**/eslint.config.*"
  - "**/.eslintrc*"
  - "**/prettier.config.*"
  - "**/.prettierrc*"
  - "**/vite.config.*"
  - "**/vitest.config.*"
  - "**/tsup.config.*"
  - "**/turbo.json"
  - "**/biome.json"
  - "**/biome.jsonc"
---
# TypeScript Tooling and Build

Keep TS dev/build workflows reproducible, type-safe, efficient. Follow project's existing tooling/config conventions.

## TypeScript Configuration

- Enable `strict` mode when project compat allows.
- Use explicit, fitting compile target.
- Configure module + module-resolution consistent with target runtime and bundler.
- Keep path aliases consistent across TS, runtime tooling, tests, bundlers.
- Use `noEmit` when TS only type-checks and other tool transpiles.
- Use `declaration` + fitting declaration settings when publishing TS libs.
- Don't weaken compiler checks to bypass errors.
- Keep config focused; skip unneeded compiler options.
- Understand implications of `skipLibCheck`, `allowJs`, `isolatedModules`, other compat options before changing them.

## Package Management

- Use project's established package manager.
- Respect existing lockfile + workspace config.
- Don't mix package managers or generate competing lockfiles.
- Declare direct deps explicitly.
- Don't rely on transitive deps.
- Pin or constrain dep versions per project conventions.
- Review maintenance, compat, security, bundle-size impact before adding packages.
- Skip dep upgrades unrelated to task.

## Build Configuration

- Keep build config explicit, reproducible.
- Separate dev, test, type-check, prod build responsibilities.
- Ensure build output matches intended runtime + deploy env.
- Avoid env-specific assumptions in shared config.
- Keep generated files + build artifacts out of source control unless explicitly required.
- Don't duplicate config across packages when shared config maintainable cleanly.
- Don't add build tools without clear benefit.

## Linting and Formatting

- Follow project's existing ESLint, Biome, Prettier, or equivalent config.
- Apply automated formatting consistently.
- Enable rules catching unsafe typing, unused code, common correctness issues where fitting.
- Avoid broad lint suppressions.
- Scope needed suppressions narrowly; explain non-obvious cases.
- Don't introduce conflicting format/lint configs.

## Monorepo Configuration

- Keep package boundaries + workspace deps explicit.
- Make shared TS configs reusable without coupling unrelated packages.
- Avoid needless project references or build orchestration complexity.
- Keep task deps + caching behavior correct.
- Make package-specific compiler/build settings intentional.
- Don't import package internals via filesystem-relative paths when public package interface should be used.
- Verify package exports, declaration files, runtime entry points agree.

## Verification

- Run relevant type-check command after changing TS code or compiler settings.
- Run lint + format checks per project conventions.
- Build affected packages when changing package config or public interfaces.
- Verify prod builds, not just dev builds, when build behavior changes.
- Check generated declaration files + package exports valid when publishing libs.
- Never claim build, lint, or type-check succeeded unless actually executed.