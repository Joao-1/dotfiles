# Workflow

## Commits
- Conventional Commits format: `type(scope): description`
- Subject ≤ 50 chars
- Body only when the why is non-obvious
- Small, atomic commits — one logical change per commit
- Never skip hooks (--no-verify)

## Branches
- Feature branches off main
- No force push to main/master
- Delete branch after merge

## Pull Requests
- PR title short (< 70 chars)
- Description explains why, not what
- Tests must pass before merge
- No WIP PRs — ship complete slices

## Testing
- Tests before shipping
- Test the behavior, not the implementation
- No mocking internals — test at boundaries
