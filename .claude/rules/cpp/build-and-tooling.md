---

paths:

- "**/CMakeLists.txt"
- "**/*.cmake"
- "**/CMakePresets.json"
- "**/vcpkg.json"
- "**/vcpkg-configuration.json"
- "**/.clang-format"
- "**/.clang-tidy"

---
# C++ Build and Tooling

Keep C++ builds reproducible, portable, diagnosable. Use project's existing build system, dependency management, compiler config, tooling conventions.

## Build Configuration

- Follow project's existing build system and directory conventions.
- Prefer target-based CMake config over global compiler/linker settings.
- Declare dependencies and build requirements explicitly.
- Scope compiler options and definitions to targets needing them.
- Avoid unneeded global config and implicit build dependencies.
- Keep Debug, Release, other supported configs consistent.
- Respect project's configured C++ standard and minimum supported compiler versions.
- Avoid relying on compiler-specific behavior unless intentionally isolated.

## Dependencies

- Prefer established, maintained dependencies.
- Avoid adding dependencies for functionality std library or existing project components already provide.
- Declare dependency versions and config requirements explicitly.
- Isolate third-party dependencies behind interfaces when practical.
- Avoid leaking third-party types into public interfaces unless coupling intentional.
- Weigh portability, licensing, maintenance, build-time cost when adding dependencies.

## Compiler Diagnostics

- Enable appropriate compiler warnings.
- Resolve warnings your changes introduce.
- Avoid suppressing warnings globally.
- If warning must be suppressed, scope suppression narrowly and document reason.
- Do not use compiler-specific flags without checking compiler compatibility.
- Keep compiler and linker config consistent across supported build environments.

## Static Analysis and Sanitizers

- Use static analysis tools where available.
- Use AddressSanitizer to detect memory errors.
- Use UndefinedBehaviorSanitizer to detect undefined behavior.
- Use ThreadSanitizer to detect data races in concurrent code.
- Use extra tooling when project requirements justify it.
- Treat tool findings as issues to investigate; don't suppress without justification.

## Formatting and Code Quality

- Follow project's established formatting config.
- Use automated formatting tools where available.
- Keep formatting consistent across source files.
- Avoid unrelated formatting changes in focused modifications.
- Follow existing naming, include ordering, header conventions.

## Testing and Build Verification

- Build relevant targets after changes.
- Run relevant tests and regression suites.
- Verify supported configs when changes affect platform- or config-specific behavior.
- Test installation and linking behavior when modifying library interfaces or dependency config.
- Do not claim build or test succeeded unless actually executed.
- Report unverified configs and known limitations clearly.

## Portability

- Avoid platform-specific APIs in portable interfaces.
- Isolate platform-specific implementations behind well-defined abstractions.
- Check compiler, std library, OS, architecture compatibility.
- Avoid assumptions about integer sizes, alignment, endianness, ABI unless explicitly guaranteed.
- Use std library facilities and portable language features when practical.