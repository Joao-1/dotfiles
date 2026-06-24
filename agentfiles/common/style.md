# Code Style

## General
- No comments unless the WHY is non-obvious (hidden constraint, workaround, subtle invariant)
- No defensive error handling for scenarios that cannot happen — trust internal guarantees
- No premature abstractions — three similar lines beats a forced helper
- No half-finished implementations
- No backwards-compatibility shims for things you can just change

## Design
- Functional over OOP where it reduces state
- Composition over inheritance
- Small, focused functions with clear names
- Prefer explicit over implicit

## Naming
- Variables and functions in English
- Names describe what, not how
- Avoid abbreviations unless universally understood (e.g. `id`, `url`)
