# Agent Orchestration Rules

## General Principles

- Delegate specialized work to right subagent.
- Don't wait for user to request agent usage.
- Proactively check if task matches agent's responsibility.
- Use agents to improve correctness, architecture quality, implementation discipline.
- Primary agent stays responsible for coordinating work, integrating results.
- Avoid needless agent calls for trivial changes.

## 1. Planning

Delegate to `planner` immediately when:

- Implementing complex feature.
- Modifying multiple modules or architectural boundaries.
- Doing substantial refactor.
- Implementing functionality with big dependencies or unknowns.

Requirements:

- Invoke planner before implementation starts.
- Review its proposed plan.
- Resolve architectural questions before proceeding.
- Use plan as implementation roadmap.

Don't invoke planner for simple, isolated changes.

## 2. Test-Driven Development

Delegate to `tdd-guide` when:

- Implementing new feature.
- Fixing bug.
- Changing existing app behavior.
- Adding functionality with meaningful test requirements.

Requirements:

- Identify expected behavior, relevant test cases.
- Follow RED -> GREEN -> REFACTOR.
- Write/update tests before implementing behavior when practical.
- Ensure tests cover relevant edge cases.
- Run right test suite after implementation.

For trivial non-behavior changes, use engineering judgment.

## 3. Code Review

After meaningful code changes, proactively invoke `code-reviewer`.

Requirements:

- Review full changeset, not just last edited file.
- Include uncommitted changes relevant to task.
- Check correctness, security, performance, maintainability, architectural consistency.
- Fix critical and high-severity findings before calling task complete.
- Re-run relevant tests after fixes.
- Don't re-invoke reviewer for same unchanged findings.

Reviewer must not modify source files.

## 4. Architectural Decisions

Delegate to `architect` when:

- Adding new architectural pattern or abstraction.
- Changing module boundaries or dependencies.
- Evaluating competing implementation strategies.
- Making decisions affecting extensibility, scalability, long-term maintainability.

Requirements:

- Present relevant constraints, existing architecture.
- Evaluate trade-offs, alternatives.
- Prefer consistency with established project architecture.
- Document significant decisions when appropriate.

## 5. Agent Coordination

- Independent investigation tasks may run in parallel.
- Dependent tasks must run sequentially.
- Don't delegate same work to multiple agents needlessly.
- Treat agent output as recommendations; evaluate them.
- Primary agent must verify implementation results before reporting completion.

## 6. Implementation Model Selection

- Use Sonnet with Medium effort as the default for implementation.
- Prefer Opus with High effort for complex reasoning,
  concurrency, resource ownership, and difficult integrations.
- Do not use Opus merely because a task involves many files.
- Escalate to Opus when implementation reveals unresolved
  architectural decisions or significant technical uncertainty.
- Follow the approved plan unless new evidence requires
  revisiting architectural decisions.
- Do not blindly follow the plan when implementation reveals
  correctness or feasibility problems.
