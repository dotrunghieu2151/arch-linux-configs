---
paths:
  - "**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,ipp,tpp}"
---
# C++ Performance

Write efficient C++ while keeping correctness, readability, maintainability. Optimize on measurable requirements, not assumptions.

## General Principles

- Prefer efficient algorithms, fitting data structures.
- Consider time complexity, memory use, allocation behavior, cache locality.
- Avoid premature optimization.
- Profile or benchmark before optimizing suspected bottlenecks.
- Prefer simple implementations unless complexity gives measurable benefit.
- Preserve correctness, maintainability when optimizing.

## Allocations and Memory

- Avoid needless dynamic allocations, copies, conversions, temporaries when they materially hurt performance.
- Prefer stack allocation, value semantics when fitting.
- Reserve container capacity when expected size known and it avoids repeated reallocations.
- Reuse buffers, resources when repeated allocation demonstrably expensive.
- Consider contiguous storage, cache-friendly layouts for perf-sensitive workloads.
- Avoid excess indirection, pointer chasing when data locality matters.
- Understand allocation and invalidation behavior of standard containers.

## Copies and Move Semantics

- Pass cheap types by value.
- Pass larger objects by `const` reference when ownership not needed.
- Use move semantics to transfer ownership or avoid expensive copies.
- Avoid needless `std::move`; can inhibit copy elision or obscure code.
- Prefer return-by-value when it enables RVO and gives clearer interface.
- Avoid complicated forwarding machinery without concrete need.

## Algorithms and Data Structures

- Select algorithms by complexity, workload characteristics.
- Prefer standard library algorithms when clear and efficient.
- Choose containers by access patterns, mutation patterns, memory characteristics.
- Consider cache locality, iteration patterns, allocation overhead when picking data structures.
- Avoid repeated work when results safely reusable.
- Avoid replacing standard library algorithms with handwritten ones without evidence of benefit.

## Concurrency and Real-Time Considerations

- Avoid needless synchronization, contention.
- Keep critical sections small.
- Consider false sharing, cache-line contention in concurrent workloads.
- Avoid unpredictable allocation, blocking ops in latency-sensitive or real-time paths.
- Understand latency and resource cost of scheduling, synchronization, inter-thread communication.
- Do not assume lock-free code automatically faster or safer.

## Benchmarking and Verification

- Establish representative baseline before optimizing.
- Use representative workloads, inputs.
- Measure relevant metrics: throughput, latency, memory use, allocation frequency where applicable.
- Avoid misleading microbenchmarks that don't reflect real app behavior.
- Verify optimizations improve intended metric without regressions.
- Keep benchmarks reproducible; document key measurement assumptions.