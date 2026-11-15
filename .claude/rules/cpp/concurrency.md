---
paths:
  - "**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,ipp,tpp}"
---
# C++ Concurrency

Write concurrent C++ with explicit sync, clear ownership, predictable thread lifetimes. Prefer simple concurrency models over needless sync complexity.

## General Principles

- Make shared mutable state explicit.
- Prefer immutable data, message passing where practical.
- Define which thread owns, modifies each resource.
- Set clear thread-safety guarantees for public interfaces.
- Avoid data races, deadlocks, livelocks, uncontrolled contention.
- Don't assume `const` member functions auto thread-safe.
- Prefer standard concurrency facilities over custom sync primitives unless justified.

## Synchronization

- Protect shared mutable state with proper sync.
- Use mutexes, locks for clear critical sections.
- Keep critical sections small; don't hold locks during blocking/expensive ops.
- Use RAII locking like `std::lock_guard`, `std::unique_lock`.
- Avoid inconsistent lock ordering (deadlock risk).
- Use condition variables with predicates to handle spurious wakeups.
- Skip needless sync when ownership or message passing removes shared state.

## Atomics and Memory Ordering

- Use atomics only when sync semantics understood.
- Prefer default seq-consistent ordering unless weaker ordering justified, proven correct.
- Use acquire/release only when sync relationship clear.
- Don't weaken memory ordering on intuition alone.
- Document non-obvious memory-ordering assumptions.
- Don't assume atomics make surrounding non-atomic state safe.

## Thread and Task Lifetimes

- Ensure threads, async tasks can't outlive resources they access.
- Define clear startup, shutdown, cancellation behavior.
- Join or safely manage thread lifetimes.
- Prefer `std::jthread` + stop tokens when supported, appropriate.
- Avoid detached threads unless independent lifetime intentional, safely managed.
- Ensure callbacks, queued tasks can't touch destroyed objects.
- Don't block indefinitely during shutdown.
- Handle exceptions at thread/task boundaries.

## Communication and Work Distribution

- Prefer message passing or queues when it simplifies ownership, sync.
- Define queue capacity, backpressure behavior where applicable.
- Avoid unbounded queues when producers can outpace consumers.
- Consider cancellation, timeouts, shutdown signaling.
- Make cross-thread ownership transfer explicit.
- Don't share mutable buffers without clear sync + lifetime contract.

## Real-Time and Latency-Sensitive Code

- Avoid unpredictable allocations, blocking locks, filesystem ops, other unbounded work in real-time paths.
- Keep time-critical callbacks short, deterministic.
- Move expensive processing to worker threads when appropriate.
- Use bounded buffers, explicit overflow policies.
- Avoid ops that may block or call unpredictable external code in latency-sensitive contexts.
- Don't assume lock-free algorithms give bounded latency.

## Verification

- Test concurrent behavior, shutdown, cancellation, failure paths.
- Use ThreadSanitizer where supported.
- Review sync, lifetime assumptions explicitly.
- Test under contention, realistic workloads.
- Don't claim thread safety without verifying all shared-state access paths.