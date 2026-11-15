---
paths:
  - "**/*.{ts,tsx,mts,cts}"
---
# TypeScript Asynchronous Programming and Concurrency

Write async TypeScript with explicit execution flow, predictable error propagation, well-defined resource lifetimes.

## General Principles

- Prefer `async`/`await` for readable async control flow.
- Make async behavior explicit in function signatures and contracts.
- Know whether operation is sequential, concurrent, or parallel.
- Avoid needless async abstractions.
- Never assume async execution gives parallel CPU execution.
- Handle rejected promises and async failures deliberately.

## Promise Handling

- Await promises when results or failures matter to current operation.
- Avoid unhandled promise rejections.
- Never silently discard promises.
- Use `Promise.all` when independent operations can safely run concurrently and all results needed.
- Use `Promise.allSettled` when every operation must be observed regardless of individual failures.
- Use `Promise.race` or `Promise.any` only when settlement semantics match intended behavior.
- Avoid sequentially awaiting independent operations when concurrency safe and beneficial.
- Never run operations concurrently when they depend on each other's results or ordering.
- Avoid wrapping already-async functions in needless promise chains.

## Concurrency and Shared State

- Treat shared mutable state as potential race condition source.
- Avoid concurrent mutation of shared objects/collections unless synchronization or ownership clearly defined.
- Prefer immutable values and message passing where practical.
- Know async tasks can interleave at suspension points.
- Never assume code between `await` expressions protected from other async operations.
- Protect critical state transitions with proper coordination mechanisms.
- Use queues, semaphores, mutex implementations, or other concurrency primitives only when behavior and lifecycle understood.
- Avoid unbounded concurrency when processing large collections or incoming workloads.

## Cancellation and Timeouts

- Use `AbortController` and `AbortSignal` when underlying operation supports them.
- Propagate cancellation signals through call chain.
- Define clear behavior for cancellation and partial completion.
- Use timeouts for operations that must not wait forever.
- Ensure timeout leaves no resources or background work unintentionally active.
- Never treat timeout as proof underlying operation stopped.
- Never swallow cancellation errors as ordinary success.

## Resource Lifetimes

- Give streams, subscriptions, timers, event listeners, other long-lived resources explicit cleanup.
- Use `try/finally` or established resource-management abstractions for cleanup.
- Unsubscribe from event sources when consumers no longer active.
- Avoid holding references past intended lifetime.
- Ensure async callbacks cannot unexpectedly update disposed or obsolete state.
- Avoid fire-and-forget unless lifecycle, failures, observability deliberately managed.

## CPU-Bound Work

- Know JavaScript runtime's single-threaded event-loop model.
- Avoid long-running sync work on latency-sensitive event-loop threads.
- Use worker threads, Web Workers, or other fitting execution mechanism for genuinely CPU-heavy work when justified.
- Weigh overhead of serialization, message passing, worker lifecycle management.
- Avoid workers for trivial operations.

## Backpressure

- Avoid launching unlimited async operations for large or continuous workloads.
- Use bounded concurrency when processing many independent tasks.
- Define queue capacity, overload behavior, cancellation policies where applicable.
- Avoid unbounded buffering when producers can outpace consumers.
- Ensure streams and async pipelines have explicit completion and error behavior.