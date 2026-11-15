---
paths:
  - "**/*.{ts,tsx,mts,cts}"
---
# TypeScript Performance

Write efficient TypeScript, keep correctness, readability, maintainability. Optimize per actual runtime behavior and measurable requirements.

## General Principles

- Prefer simple implementations with fitting algorithmic complexity.
- Consider CPU time, memory, allocation behavior, I/O overhead.
- Avoid premature optimization.
- Profile and benchmark before optimizing suspected bottlenecks.
- Understand runtime environment before making performance assumptions.
- Don't assume TypeScript-specific syntax or types cost runtime performance; types erased at compile.

## Algorithms and Data Structures

- Choose data structures by access patterns, mutation patterns, workload.
- Consider time/space complexity for frequent ops or large collections.
- Prefer `Map` and `Set` for keyed lookup and membership.
- Avoid re-searching or re-transforming same collection when result safely reusable.
- Avoid needless nested iteration when better algorithm exists.
- Avoid creating intermediate arrays/objects in hot loops when they materially hurt performance.
- Prefer built-in methods when clear and efficient.
- Don't replace readable standard ops with handwritten low-level code without measurable gain.

## Memory and Allocation

- Avoid needless object, array, closure creation in hot paths.
- Avoid repeatedly cloning large objects when mutation or structural sharing fits better.
- Use immutable updates when they improve correctness or framework requires them; avoid indiscriminate deep cloning.
- Watch retained references blocking garbage collection.
- Avoid unbounded caches and collections.
- Define cache size, eviction, invalidation where applicable.
- Avoid premature object pooling; use only when profiling shows meaningful gain.

## Asynchronous Performance

- Run independent I/O concurrently when safe.
- Use bounded concurrency for large workloads.
- Avoid blocking event loop with expensive sync ops.
- Avoid excess task creation, promise allocation, needless context switching.
- Use streaming or incremental processing for large datasets instead of loading all into memory.
- Apply backpressure when producers outpace consumers.
- Count network latency, serialization, DB queries, external service calls in end-to-end performance.

## Runtime-Specific Considerations

- Understand target runtime's execution model and APIs.
- Don't assume browser and server runtimes behave identically.
- Avoid expensive sync filesystem, crypto, or compute ops on latency-sensitive event loops.
- Consider workers for CPU-bound tasks when justified.
- Avoid needless serialization and copying across worker/process boundaries.
- Use runtime profiling tools to find real bottlenecks.

## Benchmarking

- Establish representative baseline before optimizing.
- Use realistic input sizes and workloads.
- Measure relevant metrics: latency, throughput, memory, allocation.
- Avoid benchmarks dominated by setup overhead or unrealistic synthetic workloads.
- Verify optimization improves target metric without regressions.
- Keep benchmarks reproducible; document assumptions.