---
paths:
  - "**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx,ipp,tpp}"
---
# C++ Memory Management

Write C++ with explicit ownership, predictable lifetimes, safe resource management. Prefer RAII and value semantics over manual resource management.

## Ownership and RAII

- Follow RAII (Resource Acquisition Is Initialization) for resources.
- Give every resource clear owner and well-defined lifetime.
- Prefer automatic storage duration and value semantics when appropriate.
- Use standard containers and RAII wrappers for dynamic resources.
- Avoid manual `new` and `delete`; prefer standard ownership types.
- Release resources correctly on normal execution, early returns, exceptions.
- Avoid ownership hidden behind unclear interfaces.

## Smart Pointers

- Use `std::unique_ptr` for exclusive dynamic ownership.
- Use `std::shared_ptr` only when shared ownership genuinely required.
- Use `std::weak_ptr` to observe shared ownership without extending lifetime, or to break ownership cycles.
- Avoid smart pointers when plain values, references, or non-owning pointers suffice.
- Avoid needless shared ownership and refcount overhead.
- Make ownership transfers explicit.

## Pointers, References, and Views

- Treat raw pointers and references as non-owning unless ownership explicitly documented.
- Avoid dangling pointers, references, iterators, views.
- Do not return references or pointers to objects that won't outlive returned value.
- Use `std::span`, `std::string_view`, other non-owning views only when referenced storage guaranteed to stay valid.
- Document lifetime requirements for public interfaces accepting or returning non-owning views.
- Mind container invalidation rules on insert, erase, resize, reallocate.
- Avoid needless pointer arithmetic and unsafe casts.
- Validate bounds before memory access when interface doesn't guarantee them.

## Object Lifetime and Special Member Functions

- Follow Rule of Zero whenever possible.
- Define custom special member functions only when type genuinely needs them.
- Follow Rule of Five when manually managing resources or custom copy/move behavior.
- Ensure copy and move preserve valid ownership and object state.
- Use `std::move` only to transfer resources or avoid meaningful copy.
- Do not move from objects that must stay usable.
- Keep constructors and destructors predictable.
- Avoid throwing from destructors.
- Ensure partially constructed objects release acquired resources correctly.

## Exception Safety

- Prefer RAII so exceptions can't leak resources.
- Maintain strong or basic exception-safety guarantee where appropriate.
- Leave objects in valid state after failed operations.
- Avoid manual cleanup paths when scope-bound resource management does same more safely.

## Verification

- Test ownership transfers, destruction, lifetime boundaries.
- Use AddressSanitizer, UndefinedBehaviorSanitizer, other available tooling where appropriate.
- Watch async operations, callbacks, and references that may outlive original scope.
- Do not assume pointer or reference stays valid after owning object or container changes.