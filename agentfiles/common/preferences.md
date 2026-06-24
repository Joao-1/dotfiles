# Personal Preferences

These are my personal defaults used as seed context when setting up AI in a new project.
They inform generation but are never embedded in project files.

## Languages
- TypeScript (primary)
- Python (secondary)

## Package Managers
- pnpm (Node.js)
- uv (Python)

## Formatters / Linters
- Biome (TypeScript — replaces ESLint + Prettier)
- Ruff (Python)

## Testing
- Vitest (TypeScript)
- pytest (Python)

## Databases
- PostgreSQL (preferred)
- Raw SQL over ORMs when complexity allows

## Patterns
- Functional over class-based where it reduces state
- No ORMs for complex queries — use query builders or raw SQL
- Prefer composition over inheritance
- Small focused modules

## Communication
- English in code, commits, PRs, and agent instructions
